# Durability — what to bake into the image

What ships in the image so a rebuilt container brings up local inference end to
end with no host hand-steps: the Dockerfile Ollama + ROCm 7.2 install, the
host-adaptive entrypoint GPU-group grant, and the supervised, self-healing
`garden-ollama.service` unit (two recovery layers: `Restart=always` between jobs
+ a per-job preflight for an already-down endpoint). Also the standing
**follow-ups** — chiefly the one un-run check: a live token-generation GPU smoke
test on a real rebuild. Read this to know what is automated vs. what a
maintainer still does once per host. The serving mechanics this hardens are
[serving-endpoint.md](serving-endpoint.md); the kernel memory tuning listed as a
host prerequisite is [model-selection.md](model-selection.md).

Following the codex-CLI capture pattern in the Dockerfile (`RUN npm install -g
@openai/codex && command -v codex`), make a rebuilt image ship the endpoint so
no host hand-steps are needed.

**LANDED (2026-07-14): the Dockerfile now installs Ollama + its ROCm 7.2 bundle, and
the entrypoint grants GPU-group access host-adaptively (see § Container GPU access in
[serving-endpoint.md](serving-endpoint.md)), so a
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
  cmdline + reboot (§ Raising the GPU memory budget in
  [model-selection.md](model-selection.md)). Optional for ≤50 GB models.
- Confirm the host kernel is ≥ the HWE `6.17.0-19.19~24.04.2` point release
  (§ Kernel 6.17 memory-stability caveat in [host-and-rocm.md](host-and-rocm.md)).

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
§ Container GPU access in [serving-endpoint.md](serving-endpoint.md). Pre-`ollama pull`
the chosen model(s) at build time only if you want them in the image layer — otherwise
the first serve pulls on demand into the bind-mounted home (intentionally left to first
serve here).

**LANDED: the supervised `garden-ollama.service` unit (self-healing endpoint).** The
endpoint is no longer a hand-run `OLLAMA_IGPU_ENABLE=1 ollama serve &`; it is a
supervised systemd `--user` unit — `scripts/systemd/garden-ollama.service`, whose
`ExecStart` is the thin wrapper `scripts/jobs/ollama-serve.sh` (sets the mandatory
`OLLAMA_IGPU_ENABLE=1` and derives `OLLAMA_HOST` from `GARDEN_LOCAL_OLLAMA_URL` via
`ollama_serve_host`, so the served and client endpoints cannot drift; the binary it
execs is `ollama` on PATH unless an operator pins one with `GARDEN_OLLAMA_BIN`, which
is authoritative and fail-closed — an unrunnable pin backs off and exits rather than
quietly serving with a different binary). Since
**2026-07-28** (`d4a40ed9ba`) the image no longer enables the installer-created system
`ollama.service`, so the garden unit (`garden-ollama.service`) owns `:11435` and
the system unit (if still enabled) owns `:11434` — they no longer conflict. That is an **image-build-time** change, so it holds only for
containers built after it — an older container still has the system unit enabled and
serving, and § Which unit is actually serving in
[serving-endpoint.md](serving-endpoint.md) is how you tell which world you are in
before diagnosing. `Restart=always`
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
  `-c model_provider=local` flag surface (see [worker-backend.md](worker-backend.md),
  marked UNVERIFIED).
- Host kernel memory tuning (`ttm.pages_limit`) is untested on this host.
- The `provider: local` rate-card numbers (seeded ~$1.50/MTok amortized; the row
  now also lives in `designs/provider-model-catalog.md` § 2.5) are illustrative —
  replace with the measured box price and `amd-smi` power draw (see
  [cost-model.md](cost-model.md)). The token-cost ledger
  that would *apply* this rate is not yet wired (a sibling design), so the row is
  seed-config until then.
- vLLM on this iGPU is officially supported but community-flaky; not exercised
  here.
