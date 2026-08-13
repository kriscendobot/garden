# Standing up an OpenAI-compatible `/v1` endpoint

The three ways to serve local inference over an OpenAI-compatible `/v1` surface
on this iGPU — **Ollama** (the recommended default and the verified path),
**vLLM**, and **llama.cpp** — plus the two operational gotchas that actually
bit this host: **which serving unit owns which port** (the garden
`garden-ollama.service` on `:11435` vs. the installer's system `ollama.service`
on `:11434`) and **container GPU access** (device nodes present is not access;
the bot user needs `video`/`render` group membership). Read this to get a live
`/v1/chat/completions` responding. What model to pull is
[model-selection.md](model-selection.md); baking the endpoint into the image so
it comes up with no hand-steps is [durability.md](durability.md).

Three viable paths on this iGPU, in increasing order of effort. **Ollama is the
recommended default** for a headless garden worker: single binary, bundles its
own ROCm runtime (no system `/opt/rocm` needed), auto-manages model load/unload,
and exposes both its native API and an **OpenAI-compatible `/v1`**.

## Path A — Ollama (recommended; verified installed on this host)

The AMD "Getting Started with Ollama" playbook is the reference
(<https://github.com/amd/playbooks/blob/main/playbooks/supplemental/ollama-getting-started/README.md>);
it installs with `curl -fsSL https://ollama.com/install.sh | sh` and pulls
`gpt-oss:20b`.

**What actually happened installing it in this container (2026-07-13):**

1. The one-line installer needed two host packages absent from the image:
   `zstd` (the release tarballs are `.tar.zst`) and `pciutils`/`lshw` (the
   installer's GPU auto-detect greps `lspci -d 1002:`). Without `lspci` the
   installer silently falls back to CPU-only and never fetches the ROCm bundle.

   ```sh
   sudo apt-get update && sudo apt-get install -y zstd pciutils lshw
   ```

2. The installer placed the binary (`ollama` **0.31.2**) in `/usr/local/bin`
   and the runtime libs in `/usr/local/lib/ollama`, but on the first run only
   the CUDA runtime extracted; the ROCm bundle had to be fetched explicitly:

   ```sh
   curl -fSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst \
     | zstd -d | sudo tar -xf - -C /usr/local
   ```

   This landed `/usr/local/lib/ollama/rocm_v7_2/` — **ROCm 7.2**
   (`librocblas.so.5.2.70201` = 7.2.1), and crucially its rocBLAS kernel
   library includes **gfx1100/1101/1102/1150/gfx1151** — so this host's iGPU
   is covered by a prebuilt kernel with no source build. Ollama bundling its
   own ROCm confirms the docs: a full system ROCm install is **optional** for
   Ollama; you only need the amdgpu **kernel** driver
   (<https://github.com/ollama/ollama/blob/main/docs/linux.mdx>).

**Serve + smoke test:**

> **STANDING WAY TO SERVE (LANDED): the supervised `garden-ollama.service` unit.**
> Do **not** hand-run `ollama serve &` in production — the endpoint is now a
> supervised systemd `--user` unit, `garden-ollama.service` (source
> `scripts/systemd/garden-ollama.service`, wrapper `scripts/jobs/ollama-serve.sh`),
> with `Restart=always` so a crash self-restarts. It is the **intended** sole owner of
> `:11435` — but see § Which unit is actually serving, because on a container built
> before 2026-07-28 the installer's system `ollama.service` may still be enabled on
> `:11434`. The garden and system units now serve **different ports** (`:11435` vs
> `:11434`), so they no longer race for the same bind address.
> It is enabled **only on hosts that
> declare hermits** (`hermits: N>0` in `hosts/<host>` → `install-units.sh scale
> hermit N` enables it; a zero-hermit host never does) and derives its `OLLAMA_HOST`
> from `GARDEN_LOCAL_OLLAMA_URL` (via `ollama_serve_host`, `common.sh`) so the served
> bind address and the hermit handler's client URL cannot drift. The hermit handler
> additionally **self-heals** a down endpoint: its per-job preflight
> (`codex-provider-common.sh`) starts this unit and polls `/v1/models` for readiness
> before failing, so a pinned `model: qwen3.6` tick never strands on a crashed or
> never-started endpoint (see [durability.md](durability.md)) — noting that the start
> it issues is `systemctl --user start garden-ollama.service`, which cannot displace a
> system `ollama.service` already on the port. A zero-hermit host enables **the garden unit**
> nowhere; whether it serves local inference at all still depends on the installer's
> system unit (§ Which unit is actually serving). The manual line below is the underlying
> invocation the unit runs, kept for a one-off smoke test:

```sh
# Serve (ONE-OFF smoke only; production uses garden-ollama.service — see above).
# OLLAMA_IGPU_ENABLE=1 is mandatory or the iGPU is ignored.
# Must run as a user in the video+render groups, or as root (see § Container GPU access).
OLLAMA_IGPU_ENABLE=1 OLLAMA_HOST=127.0.0.1:11435 ollama serve &

ollama pull llama3.2:3b            # small, ~2 GB — good first smoke model
                                  # or: ollama pull gpt-oss:20b  (~12 GB, the playbook's pick)

# Native API:
curl http://localhost:11435/api/generate -d '{"model":"llama3.2:3b","prompt":"hello","stream":false}'

# OpenAI-compatible /v1 (this is the surface a worker backend targets):
curl http://localhost:11435/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"llama3.2:3b","messages":[{"role":"user","content":"Say hi in five words."}]}'
```

Ollama exposes `/v1/chat/completions`, `/v1/completions`, `/v1/models`, and
`/v1/embeddings` — enough for any OpenAI-SDK client to point `base_url` at it.

### Which unit is actually serving (check this before diagnosing anything)

**The garden unit serves `:11435` and the installer's system unit serves `:11434`.**
**They no longer race for the same port, but which one is up is still per-host. Do not assume.**

| Unit | Scope | Runs as | When it is up |
| --- | --- | --- | --- |
| `garden-ollama.service` | `systemctl --user` (bot user) | the bot user | **hermit-count-gated** — enabled only where `hermits: N>0` (`install-units.sh scale hermit N` → `reconcile_ollama_unit`). A zero-hermit host has it *installed but disabled*. |
| `ollama.service` | system (`/etc/systemd/system`) | the `ollama` user | Enabled by the Ollama installer. The Dockerfile stopped enabling it on **2026-07-28** (`d4a40ed9ba`, "make garden Ollama the sole endpoint owner"), so it is gone from newly built images — but **any container from an earlier image still has it enabled, running, and holding the port**. |

```sh
systemctl --user is-active garden-ollama.service   # the garden-supervised endpoint
systemctl is-active ollama.service                 # the installer's system endpoint
curl -fsS http://127.0.0.1:11435/v1/models         # what the garden endpoint serves
```

Observed on `endolin-garden2` (2026-07-28): `hermits: 0` → `garden-ollama.service`
disabled/inactive, while the system `ollama.service` was **active** and serving an
**empty** model list. Sending an operator to `garden-ollama.service` there is a dead
end: it is disabled by design, and starting it cannot displace the system unit (it
would fail on address-in-use — the case `ollama-serve.sh` refuses to stand down for).
The hermit preflight therefore no longer hardcodes a unit name: `codex_local_endpoint_unit_hint`
(`scripts/jobs/handlers/codex-provider-common.sh`) probes both read-only and names
whichever one this host is really running.

**The model store follows the serving daemon, not the user you are logged in as.** The
system unit's store belongs to the `ollama` user (`/usr/share/ollama/.ollama`); the
garden unit's belongs to the bot (`~/.ollama`). A model pulled into the *other* store
is invisible to the live endpoint — the bot's store held `qwen3.6` while the system
unit served nothing. Because `ollama pull` is a **client** call against `$OLLAMA_HOST`,
running it while the endpoint is up always lands the model in the right store:

```sh
ollama pull qwen3.6        # goes to the garden daemon on :11435
```

## Path B — vLLM (production serving; now supports gfx1151)

vLLM is the AMD "Quick Start on vLLM" playbook path
(<https://github.com/amd/playbooks/blob/main/playbooks/supplemental/vllm-inference/README.md>),
and that playbook is **explicitly aimed at the Strix Halo integrated GPU**
(device tag `halo_box`): it serves an **OpenAI-compatible server on
`http://localhost:8001/v1`** via a `vllm-launch` wrapper, health at `/health`.

- **gfx1151 is now officially in vLLM's supported list**: the upstream ROCm
  install doc names "Ryzen AI MAX / AI 300 Series (gfx1151/1150)" and requires
  **ROCm 7.0.2+**
  (<https://github.com/vllm-project/vllm/blob/main/docs/getting_started/installation/gpu.rocm.inc.md>);
  in-tree `docker/Dockerfile.rocm_base` sets
  `PYTORCH_ROCM_ARCH=…;gfx1150;gfx1151` and `vllm/platforms/rocm.py` maps
  `"0x1586" → AMD_Radeon_8060S` (this host's PCI id).
- **Use the image `vllm/vllm-openai-rocm`** (`:latest`/`:nightly`); AMD's older
  `rocm/vllm` and `rocm/vllm-dev` images are **deprecated** (same doc, official
  images on Docker Hub since Jan 20 2026).
- **Reality check:** on this single iGPU, vLLM is supported but **less polished
  than Ollama/llama.cpp** — community reports call it "working but flaky,"
  ~15–16 tok/s, Flash-Attention instability, occasional GPU hangs
  (UNVERIFIED/community:
  <https://community.frame.work/t/how-to-compiling-vllm-from-source-on-strix-halo/77241>).
  Prefer vLLM only if you need its throughput/batching; otherwise Ollama.

## Path C — llama.cpp + ROCm (lightweight)

`llama-server` exposes an OpenAI-compatible API directly and has a documented
**known-good gfx1151 stack on ROCm 7.2.0**
(<https://github.com/ggml-org/llama.cpp/discussions/20856>). It is the leanest
option (no daemon lifecycle, no container) but you manage the model file and
flags yourself (`llama-server -m <model.gguf> -ngl 999 --host 0.0.0.0`). The
AMD llama.cpp playbook covers RPC clustering across two Halo boxes if you ever
want to pool two hosts' memory
(<https://github.com/amd/playbooks/blob/main/playbooks/supplemental/clustering-rpc-server/README.md>).

## Container GPU access (the gotcha this host hit)

The garden container is launched with the GPU **device nodes** bind-mounted
(`/dev/kfd`, `/dev/dri/card1`, `/dev/dri/renderD128` are all present inside it),
so **ROCm inference runs in-container with no passthrough work** — confirmed.
**But device-node presence is not access.** The nodes are owned:

```
/dev/kfd            root video (gid 44)
/dev/dri/renderD128 root <gid 992>   # the "render" group
```

The garden bot user starts in `kris`, `sudo` — **not** `video` or `render` — so its
first `ollama serve` discovered **0 B VRAM and fell back to CPU**.

**LANDED (2026-07-14): the entrypoint now grants this automatically, host-adaptively,
on every container start.** `entrypoint.sh` (running as root before systemd — PID 1 —
starts) reads the *live* owning gid off `/dev/kfd` and `/dev/dri/renderD128`, ensures a
**named** group exists at each gid (creating one when the render gid is unnamed, as it
is on a fresh rebuild — e.g. `992`), and adds the bot user to both. It is done there,
before the `user@<uid>` manager and the worker pool spawn, precisely because a process
started *before* the `usermod` does **not** inherit the new groups in its live
credentials (you can see this: right after a manual `usermod`, `id -nG <user>` lists
the groups from `/etc/group` while a pre-existing shell's plain `id` still does not).
So the grant must precede the workers, and it must be **runtime** (not a hardcoded
`groupadd -g 992` in the Dockerfile) because the render gid is host-specific. This
survives a garden reset / image rebuild / container recreation with **no manual step**.
Verify after a rebuild: `id <botuser>` shows `video` and `render`, and the render node
is R/W to the bot.

Manual fallbacks, if ever needed (e.g. a host predating the entrypoint change):

- **Add the bot user to the GPU groups** (durable; needs a re-login or fresh
  process to take effect):
  ```sh
  sudo usermod -aG video,render "$USER"
  ```
- Or run the inference server as **root** (`sudo … ollama serve`) — simplest for
  a dedicated box, but the whole daemon then runs privileged.
