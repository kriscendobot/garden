---
role: fixer
---
# Self-heal local Ollama inference for hermit workers (supervised unit + handler retry)

Garden-self change on `main2` (no PR — garden convention; push `main2` directly to
origin). Goal: a `model: qwen3.6` (local-provider) tick must never fail merely
because the on-box Ollama `/v1` endpoint is down. Today `scripts/jobs/handlers/cleric-codex.sh:74`
just `die`s ("host defect") when the endpoint is unreachable, and there is no
supervised Ollama process — so a crashed/never-started `ollama serve` silently
strands every pinned hermit tick. Maintainer directive (@kriskowal, 2026-07-20, via
the liaison): make this SELF-HEAL, using the garden's standing instructions for
running Ollama in `context/operations/local-inference-amd.md` (§ 2 Path A, § 6
Durability, § Container GPU access). Chosen shape: **supervised unit + handler retry**.

Do NOT add a paid-inference fallback — a `model: qwen3.6` job stays local. If
self-heal genuinely fails, `die` with the host-defect diagnostic; the hourly press
tick retries next cadence.

## Part 1 — a supervised `garden-ollama` systemd unit (hermit hosts only)

- Add a templated user unit under `scripts/systemd/` (e.g. `garden-ollama.service`)
  that runs the endpoint per the standing doc: `OLLAMA_IGPU_ENABLE=1` (mandatory or
  the iGPU is ignored) `OLLAMA_HOST=127.0.0.1:11434 ollama serve`, with
  `Restart=always` so a crash self-restarts. Honor the GPU-access caveats in
  § Container GPU access (the entrypoint gid-fix for `/dev/kfd` + `/dev/dri/renderD128`;
  the process must run as a video+render-group user).
- Wire install/enable into `scripts/jobs/install-units.sh` and gate it so it is
  enabled ONLY where hermits run — key off the host file `hermits:` count (>0), the
  same signal `install-units.sh scale hermit N` / the scaler uses. Zero-hermit hosts
  (e.g. `endolin-garden`) must not enable it.
- Make `GARDEN_LOCAL_OLLAMA_URL` and the unit's `OLLAMA_HOST` derive consistently so
  a host serving on a non-default port/box stays in agreement.

## Part 2 — handler retry in `cleric-codex.sh`

In the `provider = local` preflight branch (around lines 66–75): when
`curl .../v1/models` is unreachable, RECOVER instead of dying —
`systemctl --user start garden-ollama.service` (start if not active), then poll
`/models` for readiness (~30s, 1s interval). Proceed (set the auth marker) on
success; `die` with the existing host-defect diagnostic only if recovery still fails.

Also fix the **per-boot `auth_marker` gap**: today the local reachability check is
gated behind a once-per-boot marker, so if Ollama dies mid-boot every subsequent
hermit job SKIPS the check and codex fails deep in the run. For the `local` branch,
do a cheap liveness curl per job (or clear the marker on a failed run) so a mid-life
crash re-triggers self-heal rather than being masked for the rest of the boot.

## Constraints / done

- Keep green: `scripts/jobs/test/model-routing-test.sh`,
  `scripts/jobs/test/worker-spine-kinds-test.sh`; shellcheck-clean. Add a unit test
  for the self-heal branch if practical (mock `curl`/`systemctl`).
- Update `context/operations/local-inference-amd.md` to document the supervised unit
  as the STANDING way to run Ollama (superseding the manual `ollama serve &` in § 2
  and § 6 Durability), and note the handler self-heal.
- ACTIVATION note: this only takes effect on the hermit host (leader `endolin-garden2`)
  after a deliberate deploy + enabling the new unit there — call that out in your
  completion report so the leader-side liaison runs the deploy. Live end-to-end
  verification (kill `ollama`, watch a `model: qwen3.6` tick recover) requires that
  host; if you are not on it, verify the logic statically + via tests and say so.
- Report the branch/commit on `main2`, test output, and the activation follow-up.
