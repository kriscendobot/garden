All 8 files landed on `origin/main2`. The job is complete.

## Completion report

**Build: backend-verified provisioning + auth auto-tune for gnomes** — implemented per `designs/gnome-backend-verified-autotune.md`, pushed directly to `origin/main2` as `f33bdf6402` (no PR, per CLAUDE.md).

### What changed (8 files, +501)
- **`scripts/jobs/common.sh`** (+195) — three new functions, sitting alongside the landed `worker_health_gate` (unchanged):
  - `claude_auth_ok` — the one *new* probe: `claude` on PATH + (`ANTHROPIC_API_KEY` **or** a non-empty Claude Code OAuth credential). Presence, not freshness (Claude Code refreshes expired tokens); catches a human logout.
  - `worker_backend_probe <kind>` — dispatches on the registry `provider`, **reusing the handlers' existing preflights verbatim** (codex/kimi/fireworks); wall-clock-bounded (`_probe_bounded`, default 8s) so a hung `codex login status` can't stall the tick; spends no tokens. `GARDEN_BACKEND_PROBE_CMD` is a test/override seam.
  - `backend_effective_count <kind> <declared>` — the runtime cap with hysteresis (ramp up after 1 confirmed pass, down after 2 fails, hold in-band), pure per-host `$GARDEN_STATE/<ns>/backend/` state (no journal write), logs every transition, raises one deduped alert after a sustained cap.
- **`scripts/jobs/gardener-scaler.sh`** — scales to the *effective* count; the gardener floor stays on *declared* (an effective 0 from a failed Claude probe is intended).
- **`scripts/jobs/handlers/codex-provider-common.sh`** — `GARDEN_PROBE_LIVE=1` bypasses the per-boot `auth-ok` marker so the scaler sees a mid-boot logout.
- **`scripts/jobs/set-workers.sh`** — refuses a non-gardener kind's count > 0 until its probe passes; `GARDEN_FORCE_DECLARE=1` overrides (runtime cap still holds it at 0).
- **`context/operations/starting.md` + `context/first-run/auth.md`** — the provisioning-gate operator flow.
- **Tests** — new `backend-autotune-test.sh` (28 cases: claude_auth_ok, probe dispatch, full hysteresis, gardener floor on declared, no-journal-write, transition logging, deduped degradation alert, and the set-workers gate incl. force-declare and gardener exemption). `run-test.sh` SUBTEST 4 pins the probe to always-pass so its size assertions stay backend-independent.

### Verification
- `backend-autotune-test.sh`: 28/28 pass. `scaler-desired-count-test.sh`: 12/12. `run-test.sh` SUBTEST 4 (the scaler): all pass. `tests/checks/run.sh` (CI grep-gates): 7 suites pass. `bash -n` clean on all changed files. The other `run-test.sh` failures (git-corruption classifier, `sync_clone` re-clone, gh-wrapper shellcheck) are **pre-existing and environmental** — confirmed by a stashed-baseline run showing the identical set (30 fails on baseline vs my run), all network-blocked `github.com` fetches, none touching the scaler/set-workers path.

### Behavior delivered
- **Claude-only gnome (ps23):** declares `gardeners: N` freely; effective gardeners auto-ramp from 0 to N on the first confirmed Claude auth and drop to 0 on logout — and it **cannot** declare `clerics`/`hermits`/`mystics`/`fireworkers` (set-workers refuses, naming the missing piece).
- **All-backend gnome (garden/garden2):** each declared kind auto-tunes to its live auth each tick, with hysteresis absorbing transient blips.

### Follow-ups / notes
- **Reaches running hosts only via a later deploy** (root checkout is a deployed version).
- **Incident during the run:** for a baseline comparison I ran `git stash` in this worktree — which shares its stash stack with the whole host repo — and a concurrent worker's `git stash push` raced mine, so my `pop` grabbed *their* WIP. I fully recovered: their 4 files are re-preserved at `stash@{0}` ("RESTORE: foreign WIP accidentally popped…") and my changes are committed. No data lost, but `git stash` is repo-global across worktrees and should be avoided here; a future guard/mention in the gardener brief may be worth encoding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gnome-backend-autotune-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 128 tokens (8843575 cached reads)
- Output: 63958 tokens
- Cost: $7.8246075
- Wall-clock: 1175s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
