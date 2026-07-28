# Local LLM inference on the AMD Ryzen (Strix Halo) host

Host-setup guide for running a local, OpenAI-compatible LLM endpoint on this
garden's AMD Ryzen host, so the fleet can add a **third worker backend** — a
worker that dispatches to local inference instead of a paid API. Grounded in
AMD's playbooks (<https://github.com/amd/playbooks>) and the ROCm docs
(`rocm.docs.amd.com`); every version and command carries its source, and
anything not confirmed from a primary source is marked **UNVERIFIED**.

**Verify-by-doing status (2026-07-13).** Ollama was actually installed in the
garden container on this host and its ROCm 7.2 runtime (with gfx1151 kernels)
confirmed present. The one gotcha that bit the live run — the container grants
the GPU *device nodes* but the bot user needs `video`/`render` group membership
(or root) to open them — is documented in § Container GPU access. Figures for
models this host has not personally run are cited from the primary Strix Halo
benchmark dataset and marked as such.

---

## 0. The host, as probed

| Fact | Value | How probed |
| --- | --- | --- |
| APU | AMD Ryzen AI Max+ 395 w/ Radeon 8060S | `/proc/cpuinfo` |
| iGPU | Radeon 8060S, **gfx1151**, RDNA 3.5; PCI device `0x1586` | `lspci -d 1002:` → `Device 1586`; matches vLLM's `"0x1586": "AMD_Radeon_8060S"` |
| NPU | XDNA2 (not used for LLM serving here) | spec |
| System RAM | **125 GiB** unified | `free -h` |
| OS | Ubuntu 24.04.4 LTS | `/etc/os-release` |
| Kernel | 6.17.0-35-generic | `uname -r` |
| ROCm host-side | **absent** (`/opt/rocm` does not exist) | `ls /opt/rocm` |
| GPU device nodes in container | `/dev/kfd`, `/dev/dri/card1`, `/dev/dri/renderD128` all present | `ls -l` inside the container |
| Default VRAM carve-out | **512 MiB** (`mem_info_vram_total` = 536870912) | sysfs |
| Default GTT budget | **50 GiB** (`mem_info_gtt_total` = 53687091200) | sysfs |

**Unified memory.** The iGPU has no dedicated VRAM to speak of — a 512 MiB
BIOS carve-out — and instead maps system RAM through the **GTT** (Graphics
Translation Table), defaulting to ~50% of RAM (here ~50 GiB, raisable; see
§ Raising the GPU memory budget). This is what lets large models fit: a 63 GB
`gpt-oss-120b` loads into the same DRAM the OS uses, at a bandwidth lower than a
discrete card's but on a very large pool.

---

## 1. ROCm for gfx1151 — version, install, and whether an override is needed

### Minimum version

**gfx1151 stable Linux support begins at ROCm 7.0.2; current/recommended is
ROCm 7.2.x.**

- gfx1151 PyTorch **preview** first shipped in **ROCm 6.4.4**; **ROCm 7.0.2**
  (Oct 14 2025) is the first stable release explicitly naming gfx1150/gfx1151
  Linux support, per the AMD-maintainer thread
  (<https://github.com/ROCm/ROCm/issues/5339>).
- **Caveat — gfx1151 is absent from the canonical (Instinct-oriented)
  compatibility matrix** in every ROCm version, which is a documented source of
  confusion (<https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html>;
  issue #5339). Its support lives instead on the **"Use ROCm on Radeon and
  Ryzen"** shelf, which lists "Ryzen™ APUs (AI Max 300 Series …)" — the
  AI Max+ 395 is in that series
  (<https://rocm.docs.amd.com/projects/radeon/en/latest/docs/compatibility/native_linux/native_linux_compatibility.html>).
- AMD publishes a **dedicated Strix Halo system-optimization page**, confirming
  first-class attention to this APU
  (<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>).

### Ubuntu 24.04 install (system ROCm)

From the ROCm 7.2.4 Quick Start
(<https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html>):

```sh
wget https://repo.radeon.com/amdgpu-install/7.2.4/ubuntu/noble/amdgpu-install_7.2.4.70204-1_all.deb
sudo apt install ./amdgpu-install_7.2.4.70204-1_all.deb
sudo apt update
sudo apt install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"
sudo apt install amdgpu-dkms                       # SKIP on an in-tree driver — see below
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME           # REQUIRED — see § Container GPU access
sudo apt install rocm
```

- **Kernel 6.17 is supported**: ROCm 7.2.4 system-requirements lists Ubuntu
  24.04.4 kernels 6.8 [GA] and **6.17 [HWE]**
  (<https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>).
- **amdgpu-dkms is NOT required when using the kernel's in-tree amdgpu
  driver.** The installer's own `--no-dkms` option "skip[s] the installation of
  the kernel-mode driver"
  (<https://rocm.docs.amd.com/projects/install-on-linux/en/docs-6.4.0/install/install-methods/amdgpu-installer/amdgpu-installer-ubuntu.html>);
  a compute-only install is `amdgpu-install -y --usecase=rocm --no-dkms`.
  Prefer in-tree on 6.17 — there are reports of amdgpu-dkms failing to build
  against newer kernels (<https://github.com/ROCm/ROCm/issues/5110>). On this
  host the GPU nodes already exist inside the container, so the amdgpu **kernel
  driver is already loaded on the host** and DKMS should be skipped.

### HSA_OVERRIDE_GFX_VERSION

**Not needed on a current stack.** gfx1151 is a natively supported target once
ROCm ≥ 7.0.2 / a gfx1151-aware runtime is in play; the llama.cpp "known-good
Strix Halo stack" note states "HSA_OVERRIDE_GFX_VERSION: not required"
(<https://github.com/ggml-org/llama.cpp/discussions/20856>).

- If you must set it, the **exact-match nudge is `11.5.1`** (gfx1151's own
  version — tells an almost-aware ROCm to recognize the device), reported
  working in Ollama issue #14855 (<https://github.com/ollama/ollama/issues/14855>).
- **`11.0.0` is the legacy spoof** (pretend to be gfx1100/RDNA 3) used before
  runtimes shipped gfx1151 code objects — a hack, architecturally wrong since
  gfx1151 is RDNA 3.5 (<https://github.com/ollama/ollama/blob/main/docs/gpu.mdx>).
- iGPU gotcha: some tools drop integrated GPUs by default — Ollama needs
  **`OLLAMA_IGPU_ENABLE=1`** (<https://github.com/ollama/ollama/issues/16529>).

### Kernel 6.17 memory-stability caveat (real gotcha)

AMD's Strix Halo page states stable unified-memory behavior needs
**"Linux 6.18.4+ or Ubuntu 24.04 HWE 6.17.0-19.19~24.04.2+"**
(<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>);
a community toolbox README independently reports "kernels older than 6.18.4 have
a bug causing stability issues on gfx1151"
(<https://github.com/kyuz0/amd-strix-halo-toolboxes>). **This host is on
6.17.0-35**, which is past the `-19.19` HWE point release, so it should be on
the safe side — but confirm the exact HWE build before pushing large models,
and be ready to move to the 6.18 HWE if you see GTT/VRAM under-reporting or GPU
hangs.

---

## 2. Standing up an OpenAI-compatible `/v1` endpoint

Three viable paths on this iGPU, in increasing order of effort. **Ollama is the
recommended default** for a headless garden worker: single binary, bundles its
own ROCm runtime (no system `/opt/rocm` needed), auto-manages model load/unload,
and exposes both its native API and an **OpenAI-compatible `/v1`**.

### Path A — Ollama (recommended; verified installed on this host)

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
> with `Restart=always` so a crash self-restarts. It is the **only** unit permitted to
> serve `:11434`: the installer-created system `ollama.service` remains disabled.
> It is enabled **only on hosts that
> declare hermits** (`hermits: N>0` in `hosts/<host>` → `install-units.sh scale
> hermit N` enables it; a zero-hermit host never does) and derives its `OLLAMA_HOST`
> from `GARDEN_LOCAL_OLLAMA_URL` (via `ollama_serve_host`, `common.sh`) so the served
> bind address and the hermit handler's client URL cannot drift. The hermit handler
> additionally **self-heals** a down endpoint: its per-job preflight
> (`codex-provider-common.sh`) starts this unit and polls `/v1/models` for readiness
> before failing, so a pinned `model: qwen3.6` tick never strands on a crashed or
> never-started endpoint (§ 6 Durability). A zero-hermit host enables neither unit and
> serves no local inference at all. The manual line below is the underlying
> invocation the unit runs, kept for a one-off smoke test:

```sh
# Serve (ONE-OFF smoke only; production uses garden-ollama.service — see above).
# OLLAMA_IGPU_ENABLE=1 is mandatory or the iGPU is ignored.
# Must run as a user in the video+render groups, or as root (see § Container GPU access).
OLLAMA_IGPU_ENABLE=1 OLLAMA_HOST=127.0.0.1:11434 ollama serve &

ollama pull llama3.2:3b            # small, ~2 GB — good first smoke model
                                  # or: ollama pull gpt-oss:20b  (~12 GB, the playbook's pick)

# Native API:
curl http://localhost:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"hello","stream":false}'

# OpenAI-compatible /v1 (this is the surface a worker backend targets):
curl http://localhost:11434/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{"model":"llama3.2:3b","messages":[{"role":"user","content":"Say hi in five words."}]}'
```

Ollama exposes `/v1/chat/completions`, `/v1/completions`, `/v1/models`, and
`/v1/embeddings` — enough for any OpenAI-SDK client to point `base_url` at it.

### Path B — vLLM (production serving; now supports gfx1151)

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

### Path C — llama.cpp + ROCm (lightweight)

`llama-server` exposes an OpenAI-compatible API directly and has a documented
**known-good gfx1151 stack on ROCm 7.2.0**
(<https://github.com/ggml-org/llama.cpp/discussions/20856>). It is the leanest
option (no daemon lifecycle, no container) but you manage the model file and
flags yourself (`llama-server -m <model.gguf> -ngl 999 --host 0.0.0.0`). The
AMD llama.cpp playbook covers RPC clustering across two Halo boxes if you ever
want to pool two hosts' memory
(<https://github.com/amd/playbooks/blob/main/playbooks/supplemental/clustering-rpc-server/README.md>).

### Container GPU access (the gotcha this host hit)

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

---

## 3. Model selection for a ~50–110 GB unified-memory budget

The decisive fact on this box is **MoE-vs-dense**: because the iGPU's memory
bandwidth is the bottleneck, a Mixture-of-Experts model (few active params per
token) runs an order of magnitude faster than a *dense* model of the same total
size. Pick MoE and quantized (MXFP4 / Q4) models.

Measured on gfx1151 / Radeon 8060S, 128 GB, llama.cpp `-fa 1`, from the primary
Strix Halo benchmark dataset
(<https://github.com/kyuz0/amd-strix-halo-toolboxes/blob/main/docs/results.json>;
viewer <https://kyuz0.github.io/amd-strix-halo-toolboxes/>). pp512 = prompt
processing, tg128 = generation, tokens/sec:

| Model / quant | Type | ~size | pp512 t/s | **tg128 t/s** |
| --- | --- | --- | --- | --- |
| **gpt-oss-20b** (MXFP4) | MoE | ~12 GB | ~1800 | **~72** |
| **gpt-oss-120b** (MXFP4) | MoE | ~63 GB | ~650 | **~51** |
| Qwen ~35B-A3B (Q4) | MoE | ~20 GB | ~1100 | **~50** |
| Qwen ~122B-A10B (Q5) | MoE | ~80 GB | ~336 | **~19** |
| llama-2-7b (Q4_0) | dense | ~4 GB | ~1520 | **~52** |
| ~31B (gemma-class, Q4) | dense | ~18 GB | ~315 | **~10** |

Reading it for garden work:

- **Everyday worker default: `gpt-oss:20b`** — ~72 tg t/s is genuinely
  interactive, fits with huge headroom, and is the AMD playbook's own pick.
- **Best "large + still usable": `gpt-oss-120b` (MXFP4, ~63 GB) at ~51 t/s** —
  the flagship model this unified-memory box can run that a 24 GB discrete card
  cannot. Needs the GPU budget raised toward ~96 GB (§ below).
- **8B-class dense Q4 (e.g. Llama 3.1 8B):** no direct dataset row; the
  llama-2-7b Q4 proxy puts it at **~40–55 tg t/s** (proxy; specific Llama 3.1 8B
  numbers UNVERIFIED).
- **Avoid dense ≥30B** (e.g. Llama 70B): a 70B dense Q4 fits (~40 GB) but would
  sit **below ~10 t/s** — extrapolated ~4–6 t/s, UNVERIFIED — and prompt
  processing is the weak point. Not worth it when MoE models of similar quality
  run 5–10× faster.
- **Quantization sweet spots:** MXFP4 (for gpt-oss) and Q4_K_XL per the dataset.

### Raising the GPU memory budget (to fit the 63–80 GB models)

Default GTT here is ~50 GiB; the big models need more. Per AMD's Strix Halo page
(<https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>)
and the AMD memory-config playbook
(<https://github.com/amd/playbooks/blob/main/playbooks/dependencies/memoryconfig.md>):

- Keep the **BIOS "dedicated VRAM" small** (e.g. 0.5 GB, as it already is) and
  raise the **shared TTM/GTT limit** instead.
- **`amdgpu.gttsize` is deprecated** at the kernel level
  (<https://www.kernel.org/doc/html/latest/gpu/amdgpu/module-parameters.html>);
  the current knob is **`ttm.pages_limit`** (in 4 KiB pages), managed by AMD's
  helper `amd-ttm` (`pipx install amd-debug-tools`; `amd-ttm --set 100` = 100 GB).
- **Keep GTT and `ttm.pages_limit` aligned**, or ROCm under-reports memory (a
  124 GB box showed only 62 GB when they diverged —
  <https://github.com/ROCm/ROCm/issues/5595>). A community-tuned kernel cmdline
  for a 128 GB box: `amd_iommu=off ttm.pages_limit=32505856` (= 124 GiB;
  `amd_iommu=off` measured 5–12% faster) —
  <https://github.com/kyuz0/amd-strix-halo-toolboxes>.
- **Caveat:** these are **host kernel** parameters (cmdline / modprobe). They
  cannot be set from inside the container; a maintainer sets them on the host
  and reboots. Effective GPU memory = min(GTT, `ttm.pages_limit`) drawn from the
  same physical RAM as the OS — leave OS headroom (AMD's worked example uses
  ~100 GB to GPU on a 128 GB box).

---

## 4. Wiring a local-inference worker backend

The parked design **`cleric-worker-bid-auction-reputation`**
([designs/cleric-worker-bid-auction-reputation.md](../../designs/cleric-worker-bid-auction-reputation.md),
gated by orchestration `orch-cleric-worker-system`) factors the gardener loop
into a **worker spine** with a **worker-kind registry** (§2.1 there). Adding a
backend is deliberately cheap: *one handler script implementing the contract,
one registry row, one rate-card block, one tier map, and a `hosts/<host>` count
line* (§2.2, "Adding a third backend"). Local inference is exactly that third
backend. Two ways to build it:

### Option 1 (recommended first step) — a codex-cleric pointed at the local endpoint

**`codex` can target any OpenAI-compatible `base_url`** via a custom
`model_provider`. The cleric handler already drives `codex exec` (design §1.1);
point it at the local Ollama `/v1` instead of OpenAI by adding a provider block
to `~/.codex/config.toml` and selecting it with `-c model_provider=…`:

```toml
# ~/.codex/config.toml
[model_providers.local]
name = "local-ollama"
base_url = "http://127.0.0.1:11434/v1"
env_key = "OLLAMA_API_KEY"   # any non-empty value; Ollama ignores it
```

```sh
codex exec --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check \
  -c model_provider=local -m gpt-oss:20b "…the job prompt…"
```

(Exact `config.toml`/flag surface to be re-verified against the installed codex
CLI when built — the catalog warns the CLI surface is server-resolved and
living. **UNVERIFIED** against a specific codex version here.)

This reuses the **entire cleric handler** (`handlers/cleric-codex.sh`) — session
resume, worktree lifecycle, completion-marker contract, and the `--json` usage
adapter — for **zero new handler code**. It is the fastest path to a working
local worker and the right first move.

- Registry-wise, the cleanest expression is a **new kind** (say `hermit`) whose
  registry row reuses the codex handler but sets `provider: local` (so its
  reputation and rate-card rows are distinct from the paid-OpenAI `cleric`),
  plus a `hosts/<host>` line `hermits: N`. The provider field is exactly why the
  design keeps `worker_kind` and `provider` distinct (§4.2): "a future kind
  could drive either provider" — a codex-harness kind driving a *local* provider
  is that case.

**LANDED (2026-07-14): the `hermit` kind is wired.** Concretely:
- `common.sh` worker-kind registry gains a `hermit` row: handler
  `handlers/cleric-codex.sh` (reused verbatim), `provider: local`, unit
  `garden-hermit@`, count_key/state_ns `hermits`. `worker_kinds` enumerates it, so
  the scaler, `install-units.sh scale hermit N`, and the systemd template render it
  with **no per-kind source** (the same factoring the cleric proved).
- `resolve_model_tier local <tier>` maps the served Ollama tags (`20b →
  gpt-oss:20b`, `120b → gpt-oss:120b`, colon-tags pass through); the `openai` map
  now explicitly rejects `gpt-oss*` so a local tag can't be mis-claimed as a paid
  model. `claim-job.sh`'s backend-fit filter routes a `gpt-oss:*`-pinned job to a
  hermit only, and keeps a hermit off claude-/codex-pinned jobs.
- `cleric-codex.sh` is now provider-parameterized: for `provider=local` it skips the
  ChatGPT `codex login` check (does a `/v1/models` reachability probe instead),
  defaults to `gpt-oss:20b`, and adds `-c model_provider=local` plus an **inline**
  `-c model_providers.local.{name,base_url,env_key}` block (endpoint from
  `GARDEN_LOCAL_OLLAMA_URL`, default `http://127.0.0.1:11434/v1`) — so no
  `~/.codex/config.toml` is required and the wiring is reset-proof. **Zero new
  handler file.**
- Declare a host's count with `scripts/jobs/set-hermits.sh <N> [host]` (the
  `set-clerics.sh` analogue). Recommended initial sizing on a host that serves local
  inference: a small pool (e.g. 2) to accrue reputation data.
- **UNVERIFIED against a live codex on a GPU host:** the exact `-c model_provider`
  key names / string-quoting were transcribed from this guide, not re-run (codex was
  not on PATH in the build worktree). Re-verify on the live CLI before the first real
  hermit job. `codex --oss` is a native alternative shortcut for a localhost Ollama.

### Option 2 — a dedicated local handler

Write `handlers/hermit-local.sh` that calls the local `/v1` directly (via a
thin OpenAI client or `curl`) instead of going through codex. Worth it only if
codex's agentic loop proves a poor fit for a small local model, or to drop the
codex dependency. It implements the same handler contract:
`handler <base> <jobfile> <report-out>`, writes the completion sentinel iff the
run genuinely finished, and fills `GARDEN_USAGE_OUT` with normalized usage
`{provider, model, thoughtfulness, input_tokens, output_tokens, …}` — which for
local inference comes straight from the `/v1` response's `usage` block.

**Recommendation:** ship **Option 1** first (a `provider: local` codex-cleric —
no new handler), measure it under the auction, and only write a dedicated
handler if the reuse proves inadequate.

### Model/tier and eligibility

- Add an `openai`-shaped (OpenAI-compatible) tier map entry resolving the local
  model ids (`gpt-oss:20b`, `gpt-oss:120b`, …) — these are the served model tags,
  not paid slugs.
- The interim claim-eligibility predicate (design §1.3) must treat local model
  tags as **local-only** so a paid-cleric never claims a job pinned to a local
  model and vice-versa; under the auction this becomes a priced bid rather than
  a hard filter.

---

## 5. Feeding the bid-auction cost model — local inference is very cheap, not free

The reputation/bid model values every arm in **aggregate dollars = agentic $ +
human-review $** (design §4.4). For a paid API, agentic $ = Σ tokens × rate
card. For **local inference the marginal dollar cost is near zero** (no
per-token price — only electricity and amortized hardware). The design's dollar
axis must price a local arm as **very cheap, not literally $0**, or a single
lucky local success would look infinitely efficient and starve exploration of
the paid arms it should still be measured against.

**Honest tokens/$ for this host (amortized hardware + power).** Illustrative,
to seed a `provider: local` rate-card row — replace with the real purchase price
and local kWh rate:

- **Power:** Strix Halo APU under sustained inference draws on the order of
  ~100–140 W (whole-box; UNVERIFIED — measure with `amd-smi`/wall meter). Take
  **120 W**. At generation throughput ~50 tok/s (gpt-oss-120b) that is
  120 W / 50 tok/s = **2.4 W·s per token** = 0.000667 Wh/token. At even
  $0.30/kWh, power ≈ **$0.0000002/token → ~$0.20 per million tokens.**
- **Amortized hardware:** a ~$2,000 box over a 3-year useful life at ~30% duty
  ≈ 2,000 / (3 × 365 × 24 × 0.30 h) ≈ **$0.25/hr**. At ~50 tok/s that is
  0.25 / (50 × 3600) ≈ $0.0000014/token → **~$1.40 per million tokens.** (The
  amortization dominates; power is a rounding error.)
- **Combined ≈ $1–2 per million output tokens**, versus paid API rates of
  **$5–50 per million** (Opus $25/MTok out, per the design's rate card §4.4).

So a local arm's agentic-$ rate is roughly **1–2 orders of magnitude cheaper
per token** than the cheapest paid arm — cheap enough that on the reputation
axis (aggregate-$-to-merge-worthy) it wins decisively **whenever its acceptance
rate is comparable**. Concretely, for the rate card:

- Add a `reputation/rate-card.md` row `provider: local` with
  `price_basis: amortized`, e.g. **`$1.50 / MTok` flat** (input and output —
  local has no in/out asymmetry), dated, with the box price + kWh rate recorded
  as the derivation so it can be re-run.
- **Bidding posture:** a local worker should **bid aggressively on low-risk
  work-classes** — `doc`, `triage`, small `fix:s`, mechanical `ops` — where a
  20B/120B open model's quality is adequate and the near-zero agentic cost makes
  its aggregate-$ unbeatable even after amortizing a lower acceptance rate. It
  should **not** low-ball high-stakes `build`/`design` on `master`, where a
  weaker model's re-work and heavier human review inflate the *aggregate*
  dollar (agentic cheapness is swamped by human-$ at $125/hr) — the auction's
  merge-worthiness-per-dollar objective handles this automatically once the arm
  accrues real acceptance data. Seed it wide (design §4.6) so the auction
  explores it, and let the human-$ term keep it honest on hard targets.

---

## 6. Durability — what to bake into the image

Following the codex-CLI capture pattern in the Dockerfile (`RUN npm install -g
@openai/codex && command -v codex`), make a rebuilt image ship the endpoint so
no host hand-steps are needed.

**LANDED (2026-07-14): the Dockerfile now installs Ollama + its ROCm 7.2 bundle, and
the entrypoint grants GPU-group access host-adaptively (§ Container GPU access), so a
rebuilt image brings up local inference end to end with no manual steps.** What each
part does is below; the one check that could NOT be run here (it needs a real rebuild
on the GPU) is the end-to-end token-generation smoke test — see follow-ups. **Note:**
as with the codex line, these are *rebuild-time* additions — `ollama` is present on
this host only because of the earlier manual verify-by-doing install, and `codex` is
not yet on PATH in the running container until the next image rebuild.

**Host prerequisites (maintainer, once per host — cannot be done in-image):**

- amdgpu **kernel driver** loaded (already true here — the GPU nodes exist in
  the container). A full system ROCm install is **not** required for the Ollama
  path (Ollama bundles ROCm); it *is* required for the vLLM/PyTorch paths.
- Kernel memory tuning for the large models: `ttm.pages_limit` on the host
  cmdline + reboot (§ Raising the GPU memory budget). Optional for ≤50 GB models.
- Confirm the host kernel is ≥ the HWE `6.17.0-19.19~24.04.2` point release
  (§ 1 caveat).

**Dockerfile additions (LANDED — `Dockerfile`, 2026-07-14):** the deps + Ollama/ROCm
install ship in the image (retry-looped like the claude/codex installs, version pinned
via `ARG OLLAMA_VERSION`, `command -v ollama` asserted at build):

```dockerfile
# GPU userspace deps the Ollama installer needs (else it silently goes CPU-only)
RUN apt-get update && apt-get install -y zstd pciutils lshw \
    && rm -rf /var/lib/apt/lists/*

# Ollama + its bundled ROCm 7.2 runtime (includes gfx1151 kernels). Version pinned.
ARG OLLAMA_VERSION=0.31.2
RUN for attempt in 1 2 3; do \
        curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION="${OLLAMA_VERSION}" sh \
        && curl -fSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst \
             | zstd -d | tar -xf - -C /usr/local \
        && command -v ollama && exit 0; \
        [ "$attempt" -eq 3 ] && exit 1; sleep "$attempt"; done
```

The GPU-group grant is **NOT** a Dockerfile `usermod -aG video,render` (that hardcodes
gids that vary per host) — it is the host-adaptive entrypoint block described in
§ Container GPU access. Pre-`ollama pull` the chosen model(s) at build time only if you
want them in the image layer — otherwise the first serve pulls on demand into the
bind-mounted home (intentionally left to first serve here).

**LANDED: the supervised `garden-ollama.service` unit (self-healing endpoint).** The
endpoint is no longer a hand-run `OLLAMA_IGPU_ENABLE=1 ollama serve &`; it is a
supervised systemd `--user` unit — `scripts/systemd/garden-ollama.service`, whose
`ExecStart` is the thin wrapper `scripts/jobs/ollama-serve.sh` (sets the mandatory
`OLLAMA_IGPU_ENABLE=1` and derives `OLLAMA_HOST` from `GARDEN_LOCAL_OLLAMA_URL` via
`ollama_serve_host`, so the served and client endpoints cannot drift). The image does
**not** enable the installer-created system `ollama.service`: exactly one unit may own
`:11434`, and it is `garden-ollama.service`. `Restart=always`
self-restarts a crash. It is a **per-host** singleton (NOT leader-only: every host with
its own hermits runs its own endpoint), enabled **only where `hermits: N>0`** —
`install-units.sh scale hermit N` (the same hermit-count signal the scaler reads)
enables+starts it when N>0 and disables+stops it at N==0, and a zero-hermit host (e.g.
`endolin-garden`) never enables it (`reconcile_ollama_unit`). Two recovery layers work
together: (1) `Restart=always` covers a crash **between** jobs; (2) the hermit handler's
per-job preflight (`codex_provider_preflight` in `scripts/jobs/handlers/codex-provider-common.sh`,
self-heal requested by `cleric-codex.sh`) covers "the endpoint was **already down** when
a hermit job started" — it starts `garden-ollama.service` and polls `/v1/models` for
the pinned model (not merely HTTP 200) for ~`GARDEN_OLLAMA_HEAL_TIMEOUT`s (default 30)
before dying with the host-defect diagnostic.
That preflight is a **per-job** liveness check for the local provider (it does **not**
use the once-per-boot auth marker the paid providers use), so a mid-life Ollama crash
re-triggers self-heal on the very next hermit tick instead of being masked for the rest
of the boot. There is **no** paid-inference fallback — a `model: qwen3.6` job stays
local; if self-heal genuinely fails the tick dies and the hourly press cadence retries.
**Activation:** on the hermit host (leader `endolin-garden2`) this takes effect after a
deliberate deploy of `main2` + `set-hermits.sh N` (which the scaler turns into `scale
hermit N`, enabling the unit); on a fresh bring-up the entrypoint's GPU-group grant and
the Dockerfile's Ollama install make it come up with no manual step.

**Not yet captured / follow-ups:**

- **Live token-generation smoke test on the GPU is still the one un-run check.** The
  install path, the ROCm-7.2/gfx1151 runtime, the entrypoint group-grant logic (dry-run
  verified against the live device gids), and the hermit wiring (73/73 unit tests) are
  all confirmed — but a clean end-to-end `/v1/chat/completions` **GPU** generation must
  be confirmed **on a real rebuild**: rebuild the image, start a fresh container, then
  as the bot user `ollama pull gpt-oss:20b`, confirm `ollama ps` shows `100% GPU`, and
  curl `/v1/chat/completions`. This remains the single claim **not-yet-verified-by-doing
  on this host**.
- **First real `hermit` job** likewise needs a live codex on a GPU host to confirm the
  `-c model_provider=local` flag surface (§ 4, marked UNVERIFIED).
- Host kernel memory tuning (`ttm.pages_limit`) is untested on this host.
- The `provider: local` rate-card numbers in § 5 (seeded ~$1.50/MTok amortized; the row
  now also lives in `designs/provider-model-catalog.md` § 2.5) are illustrative —
  replace with the measured box price and `amd-smi` power draw. The token-cost ledger
  that would *apply* this rate is not yet wired (a sibling design), so the row is
  seed-config until then.
- vLLM on this iGPU is officially supported but community-flaky; not exercised
  here.

---

## Sources (primary)

- ROCm compatibility matrix — <https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html>
- ROCm on Radeon/Ryzen (lists AI Max 300 series) — <https://rocm.docs.amd.com/projects/radeon/en/latest/docs/compatibility/native_linux/native_linux_compatibility.html>
- ROCm Strix Halo optimization — <https://rocm.docs.amd.com/en/latest/how-to/system-optimization/strixhalo.html>
- ROCm 7.2.4 quick-start install — <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html>
- ROCm system requirements (kernel 6.17 HWE) — <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>
- gfx1151 support timeline (ROCm 7.0.2) — <https://github.com/ROCm/ROCm/issues/5339>
- AMD playbooks: Ollama — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/ollama-getting-started/README.md>
- AMD playbooks: vLLM — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/vllm-inference/README.md>
- AMD playbooks: memory config (amd-ttm) — <https://github.com/amd/playbooks/blob/main/playbooks/dependencies/memoryconfig.md>
- AMD playbooks: llama.cpp RPC — <https://github.com/amd/playbooks/blob/main/playbooks/supplemental/clustering-rpc-server/README.md>
- Ollama GPU/Linux docs — <https://github.com/ollama/ollama/blob/main/docs/gpu.mdx>, <https://github.com/ollama/ollama/blob/main/docs/linux.mdx>
- vLLM ROCm install (gfx1151, ROCm 7.0.2+) — <https://github.com/vllm-project/vllm/blob/main/docs/getting_started/installation/gpu.rocm.inc.md>
- llama.cpp known-good Strix Halo stack — <https://github.com/ggml-org/llama.cpp/discussions/20856>
- Strix Halo benchmark dataset — <https://github.com/kyuz0/amd-strix-halo-toolboxes/blob/main/docs/results.json>
- amdgpu kernel module params (gttsize deprecated) — <https://www.kernel.org/doc/html/latest/gpu/amdgpu/module-parameters.html>
- GTT/TTM alignment issue — <https://github.com/ROCm/ROCm/issues/5595>
- Design: cleric worker / spine / bid-auction / reputation — [designs/cleric-worker-bid-auction-reputation.md](../../designs/cleric-worker-bid-auction-reputation.md)
