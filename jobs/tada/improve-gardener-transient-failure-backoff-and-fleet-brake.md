Inbox empty. Work is complete, verified, committed, and pushed to origin/main2.

## Completion report

**Problem.** On a correlated Claude quota/usage outage, `scripts/jobs/gardener.sh` applied *zero* delay on both transient-failure paths — the `elif [ "$hrc" -eq 0 ]` exit-0-unsatisfying branch and the `if [ "$transient" -eq 1 ]` non-zero branch each fell straight back to the claim head. ~100 gardeners re-ran jobs against an already-exhausted quota in lockstep, amplifying the outage and churning todo↔doin (the 2026-07-01 poisoning of a dozen unrelated jobs).

**What I did** (cadence-only; the reaper stays the sole requeue owner, no board-ownership change):

- **(a) Per-worker exponential+jittered backoff.** Added a `fail_attempt` counter to the gardener loop — the failure-path analog of `idle_attempt`, reusing `idle_backoff`. On *any* transient-classified handler failure the just-failed worker sleeps `idle_backoff "$fail_attempt"` before its next claim. It grows across consecutive transient failures and resets **only** on a genuine completion (not on every claim, which would erase the growth), so a sustained outage backs a single worker off exponentially up to `GARDEN_IDLE_SLEEP_CAP`. Wired into both transient branches.

- **(b) Shared fleet brake.** New host-local rolling ledger in `$GARDEN_STATE`: every gardener stamps it on a transient failure (`record_transient_failure`); before each claim it reads the fleet-wide density (`transient_failure_density` / `fleet_brake_engaged`) and, when it crosses `GARDEN_FLEET_BRAKE_THRESHOLD` (default 10) over `GARDEN_FLEET_BRAKE_WINDOW_SECS` (default 300s), pauses claiming for a jittered window (`fleet_brake_pause`, default 60s). A braked worker records nothing, so the density ages out and the brake releases — the storm drains instead of being fed. Fail-open (unreadable ledger → density 0 → released); threshold 0 disables it.

**Files changed** (committed `8ddc0bc72`, pushed to origin/main2):
- `scripts/jobs/common.sh` — 5 helpers + tunables (`record_transient_failure`, `transient_failure_density`, `fleet_brake_engaged`, `fleet_brake_pause`, `_fleet_brake_prune`/`_fleet_brake_now`).
- `scripts/jobs/gardener.sh` — `fail_attempt` counter, the pre-claim brake gate, the reset on completion, and the record+backoff on both transient paths.
- `scripts/jobs/test/fleet-brake-test.sh` — new unit test, 14 assertions, deterministic (frozen clock, no real sleeps).

**Verification.** `bash -n` clean on both scripts; new test 14/14 pass; the five sibling classifier tests (empty-output, signal-kill, claude-session-limit, elapsed-constancy, handler-budget) all still pass; the full end-to-end `run-test.sh` passes 252/4 — the only 4 failures are in the unrelated issue-inbox / issue-source-gh subsystem (empty `gh`/`jq` fixture output) that this change never touches.

**Follow-ups / notes.** Defaults (threshold 10 / window 300s / pause 60s) are first-cut estimates — all overridable via env; worth tuning against a real storm's observed rate. The brake is deliberately host-local (a cross-host brake would need journal coordination the storm-response path must not depend on). Unrelated: the postmortem's `endolinbot2` host-identity drift (`/home/kris/.garden` vs the `endolinbot` leader marker) is still live and outside this job's scope.
