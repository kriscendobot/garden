# run-test.sh SUBTEST 8 (scheduler cadence): make the 1s-cadence assertion clock-deterministic

Follow-on from `run-test-isolate-shared-clone-flake` (which isolated the
self-heal/shared-clone subtests onto dedicated throwaway clones and scrubbed the
inherited fleet env). With that landed, `scripts/jobs/test/run-test.sh` is green
under fleet load EXCEPT for an occasional SUBTEST 8 failure:

    FAIL: re-run dispatched (tick 1→2, weekly 1→1)

Root cause: SUBTEST 8 asserts that an IMMEDIATE second `scheduler.sh` run
dispatches nothing because the 1-second cadence has not elapsed. On a busy host
(~100 gardeners) the wall-clock gap between the two `scheduler.sh` invocations
can exceed 1s, so the 1s schedule legitimately re-fires and the assertion fails.
This is a timing/clock-determinism fragility, NOT a shared-clone/journal
isolation issue, so it was left out of the isolation job's scope.

Fix direction: give `scheduler.sh` a deterministic now-override hook (mirror the
existing `GARDEN_FOREMAN_NOW` / `GARDEN_USAGE_NOW` pattern — e.g.
`GARDEN_SCHEDULER_NOW`) and drive the cadence assertions in SUBTEST 8 with it
instead of real `date`/`sleep`, OR widen the test cadence so a loaded host cannot
cross it between the two scheduler runs. Keep the existing assertions' intent.

Map: build (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2; commit explicit pathspecs; push HEAD:main2
with a git-rebase CAS loop.

---
claim:
  host: endolinbot
  gardener: 53
  claimed_at: 2026-06-27T05:44:35Z
