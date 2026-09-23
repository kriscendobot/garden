Done. Completion report follows.

---

## Job complete: `improve-scheduler-preflight-gate`

**What I did**

Added an optional deterministic preflight gate to the scheduler and wired it into the scholar schedule, moving the scholar's idle/active decision off the dispatched LLM agent into plain code.

**Code changes (landed on `origin/main2`, commit `be3b94617`)**

1. **`scripts/jobs/scheduler.sh`** — the recurring path now parses an optional `preflight:` frontmatter field. When present and the cadence has elapsed, it runs the named script *inside the CAS loop* (resolved relative to `scripts/jobs/`, or absolute; passed the schedule name):
   - exit `0` → work present: post the job + stamp `last_dispatched` (normal path)
   - exit `2` → no work: stamp `last_dispatched` only (advance the clock, post nothing) and log `preflight gated: no work`
   - any other exit → treated as work-present (**fail open**, so a broken/erroring/offline gate never silently starves a schedule)
   
   Added a `write_schedule` helper used by both the gated and dispatch paths so the `preflight:` line is preserved on every re-stamp.

2. **`scripts/jobs/scholar-preflight.sh`** (new, +x) — returns `0` iff the scholar role inbox (`inbox/scholar/unread`) is non-empty, OR a claimable `scholar-*` job exists in `jobs/todo/`, OR a `role/scholar` broadcast (`sent_at`) is newer than the schedule's `last_dispatched`; else `2`. Reuses `common.sh`'s standing-scan helpers (`ensure_clone`/`sync_clone`/`list_jobs`); read-only against the board.

3. **`scripts/jobs/set-schedule.sh`** — accepts `GARDEN_SCHEDULE_PREFLIGHT=<script>` to write a `preflight:` line, and preserves an existing one across later cadence edits exactly like `last_dispatched`.

4. **`skills/schedule/SKILL.md`** — documented the new `preflight:` field and its exit-code contract.

**Live wiring (on `journal2`)** — ran the new `set-schedule.sh` to add `preflight: scholar-preflight.sh` to `schedules/scholar-library-cycle.md`; cadence (`hourly`), `last_dispatched` (`2026-06-28T09:05:02Z`), `job_basename_prefix`, and the full body were all preserved (verified byte-identical).

**Verification** — built throwaway local journal repos and confirmed end-to-end: all 5 scholar-preflight conditions (empty board→2, inbox→0, scholar-* job→0, non-scholar job→2, stale broadcast→2, fresh broadcast→0); the scheduler gate path (no job posted, clock advanced, `preflight:` preserved); the scheduler dispatch path (job posted when work present); and a no-preflight schedule regression (dispatches normally, no `preflight:` line leaked).

**Process notes / follow-ups**

- I initially edited the root checkout directly (a defect per the gardener brief); I corrected this by moving all source changes into an isolated worktree off `origin/main2`, pushing from there, and restoring the root tree to clean. `scheduler.sh`/`set-schedule.sh` were identical between root HEAD and `origin/main2`, so the rebase was clean (only `common.sh` had diverged, which I didn't touch).
- **The new scheduler code is on `main2` but not yet deployed to this host's root checkout** — the running `garden-scheduler` won't honor `preflight:` until the next deliberate deploy (`deploy-garden.sh`). This is harmless: the deployed scheduler simply ignores the unknown `preflight:` field and dispatches normally (status quo) until then; the gate also fails open by design. No action needed beyond a normal deploy.
- Inbox drained (empty) at the final checkpoint.
