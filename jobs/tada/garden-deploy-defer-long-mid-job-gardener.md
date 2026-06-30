Pushed to `main2` on the first attempt. Work complete.

---

## Completion report

**Job:** `garden-deploy-defer-long-mid-job-gardener` — stop a single long mid-job gardener from fleet-pausing every deploy attempt.

**What I did (option 1 — fast defer check, no doomed drain):**

Added a **DEFER check** to `scripts/jobs/deploy-garden.sh` that samples each gardener's busy-marker age *before* engaging the drain. The busy marker's mtime is set when a gardener starts its current job (`gardener.sh` recreates it just before invoking the handler, clears it at the next between-claims point), so its age is exactly how long that gardener has been mid-job — a deterministic long-job signal needing no LLM or job introspection.

- New helper `oldest_busy()` echoes `<age> <idx>` for the longest-running gardener.
- New knob `GARDEN_DEPLOY_LONG_JOB_THRESHOLD` (default 300s, half the drain budget).
- If a gardener is already mid-job past the threshold, the deploy **defers with the drain NEVER engaged** — the fleet is never paused on a doomed attempt — and **exits 0** (a deferral is not a failure; the persistent Upgrade-ready signal makes a later trigger retry once the long job finishes). This kills the *repeated* 600s fleet-pause: by the time the auto-trigger re-fires, the long-running repro/ingest marker is already old, so each retry bails instantly.
- The same check runs **each quiesce poll**, so a job that was under the threshold at the check but crosses it mid-drain lifts the drain and defers rather than burning the rest of the budget paused — bounding even the first-attempt pause.
- **Operator-pre-drained deploys are unchanged:** the defer check is skipped (deferring wouldn't un-pause their drain; they explicitly asked to deploy), so the original timeout/abort semantics stand.
- **Safety invariant preserved:** half-old/half-new code is never permitted — a long job still blocks the merge; the only thing changed is whether the fleet is paused while it blocks.

**Tests (`scripts/jobs/test/deploy-garden-test.sh`):** three new scenarios using a backdated busy marker (no sleeps for the main case) —
1. *LONG-JOB DEFER*: proves the drain is never engaged ("drain engaged" absent), no quiesce wait, no restart, root not advanced, exit 0.
2. *operator-pre-drained variant*: proves the defer check is skipped and the operator's drain is preserved on abort.
3. *LONG-JOB DEFER (MID-DRAIN)*: a near-threshold marker proves the drain *is* engaged, then lifted-and-deferred once the job crosses the threshold mid-wait.

All **63 tests pass** (the 8 prior scenarios unaffected — the existing quiesce-timeout test uses a fresh age-0 marker, well under the threshold). `bash -n` clean; no new shellcheck warnings.

**Scope:** touched only `deploy-garden.sh` and its test, per the job's constraint. Landed on `main2` from an isolated worktree off `origin/main2` (commit `8f5bc6e7d`, pushed first-try).

**Possible follow-up (out of scope here):** `designs/deliberate-deploy.md` could gain a sentence documenting the new step-0 defer posture and the `GARDEN_DEPLOY_LONG_JOB_THRESHOLD` knob; I left the design doc untouched to honor the "touch only the deploy path" constraint.
