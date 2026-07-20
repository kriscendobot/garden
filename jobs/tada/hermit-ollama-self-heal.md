Pushed to `main2` as `b8ffeaa950`. Here's my completion report.

---

## Completion report — `hermit-ollama-self-heal`

**Branch/commit:** `main2` @ `b8ffeaa950` (pushed to origin, clean CAS on attempt 1).

### What I did

**Part 1 — supervised `garden-ollama` unit (hermit hosts only)**
- New `scripts/systemd/garden-ollama.service`: `Restart=always` supervised endpoint; `ExecStart` is the new thin wrapper `scripts/jobs/ollama-serve.sh`, which sets the mandatory `OLLAMA_IGPU_ENABLE=1` and derives `OLLAMA_HOST` from `GARDEN_LOCAL_OLLAMA_URL` via the new `ollama_serve_host` helper (`common.sh`), so the served bind address and the hermit handler's client URL can't drift. GPU device-node group access is already handled by the entrypoint (§ Container GPU access), which runs before the user manager — so nothing new is needed there.
- Wired into `install-units.sh`: excluded from the standing enable set (`intended_units`), and armed by the **hermit scale path** — `scale hermit N` calls `reconcile_ollama_unit` (enable+start at N>0, disable+stop at N==0). This keys off the exact `hermits:` count the scaler already reads, so a zero-hermit host (e.g. `endolin-garden`) never enables it and `set-hermits.sh N` brings it up/down on the next scaler tick with no separate step.

**Part 2 — handler self-heal (`codex-provider-common.sh`)**
- `codex_provider_preflight` gained an opt-in `self_heal` arg (5th). When the local `/v1/models` probe fails and self-heal is requested, it runs `systemctl --user start garden-ollama.service`, then polls `/models` for `GARDEN_OLLAMA_HEAL_TIMEOUT` (default 30s, 1s interval); it proceeds on recovery and only `die`s with the host-defect diagnostic if recovery fails. The hermit handler (`cleric-codex.sh`) requests self-heal; the **foreman deliberately does not** (it has provider fallback and must advance immediately — otherwise the order test breaks and it would block 30s).
- Fixed the **per-boot marker gap**: the `local` branch is now a per-job liveness curl and no longer consults/writes the once-per-boot `auth-ok` marker, so a mid-life Ollama crash re-triggers self-heal on the next tick instead of being masked for the boot. No paid fallback — a `qwen3.6` job stays local.

### Tests
- New `hermit-ollama-self-heal-test.sh` — 16 assertions (reachable / recover / give-up / no-heal-for-foreman / per-job-no-marker / host-derive), using committed mock `curl`/`systemctl`/`codex` symlinked into a temp bin (repo idiom; PATH-injected scripts in `/tmp` are noexec here and a real ollama is up).
- `enable-services-test.sh` — added a HERMIT-GATE subtest (scale hermit 2 arms, gardener scale leaves alone, scale hermit 0 disarms) and excluded `garden-ollama.service` from its independently-derived expected set. **37/37 pass.**
- Required green: `model-routing-test` 24/24, `worker-spine-kinds-test` reaches 76/76. `foreman-provider-order` 8/8, `scaler-desired-count` 12/12. All shellcheck-clean relative to the repo's established baseline (only the house-style `A && ok || bad` info + already-disabled warnings).
- One caught bug during testing: a trailing `[ "$kind" = hermit ] && reconcile_ollama_unit` made `scale()` return non-zero for non-hermit kinds and killed `set -e` callers — changed to an `if`.
- Note: `worker-spine-kinds-test`'s "worker_kind not stamped in the claim history" intermittently fails (0–3 of 76) — I confirmed this is a **pre-existing environmental flake**: it fails identically on a clean tree with my changes stashed (same 0–3 range, same 76 total), so my changes have no effect on it.

### Activation follow-up (for the leader-side liaison)
This only takes effect on the **hermit host (leader `endolin-garden2`)** after a **deliberate deploy of `main2`** + enabling the unit there (the deploy's `install`/`enable-services` renders it; `set-hermits.sh N` → the scaler's `scale hermit N` enables+starts it). I am on `endolin-garden` (a **zero-hermit** host per the job), so I verified the logic **statically + via tests only** — the live end-to-end check (kill `ollama`, watch a `model: qwen3.6` tick recover) must be run on `endolin-garden2`.
