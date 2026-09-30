I added a second, independent time limit on the claimed handler in `scripts/jobs/gardener.sh`. It kills the handler's whole process group even when `timeout` fails, and a new test shows a descendant that ignores TERM can no longer keep the worker running past its limit. Pushed to `main2` as `3414686f1df`.

I didn't find out why `timeout` failed in the 05:36:39Z incident. The watchdog makes that failure harmless without explaining it.

**What changed**
- **New watchdog (`handler_wall_watchdog` in `scripts/jobs/common.sh`).** It runs in the background beside `timeout`, in the gardener's own process group so killing the handler group can't kill it. It checks the handler's process group once a second:
  - at budget + `GARDEN_HANDLER_WATCHDOG_GRACE` (default 10s) it sends TERM to the whole group;
  - at budget + `GARDEN_HANDLER_KILL_AFTER` + `GARDEN_HANDLER_WATCHDOG_KILL_LAG` (default 2s) it sends KILL to the whole group, including the `timeout` process itself;
  - it stops as soon as the group is empty, and has the same safety checks as `reap_process_group` (it won't signal a non-numeric target, init, or its own group).
- **Wiring in `gardener.sh`.** The watchdog starts right after the handler launches. It is cancelled and waited for on every handler exit, before the existing group cleanup.
- **Exit code.** If the watchdog's KILL fired, meaning `timeout` really failed, the outcome is recorded as rc=124 (a wall-clock overrun) and logged. If only its TERM fired, `timeout`'s own exit code stands, so the existing rc=137 kill-after path doesn't change.
- **Claim-TTL invariant.** The 2s lag lets `timeout`'s own KILL act first when it works. The worst-case lifetime becomes budget + KILL_AFTER + about 3s. That fits inside the reaper's existing 30s `GARDEN_REAP_SAFETY_SLACK` in `reap_age_threshold`, so no budget limits changed. I added a note about this to `reaper.sh`'s invariant comment.

**Tests**
- New `scripts/jobs/test/handler-wall-watchdog-test.sh` passes 15/15. It covers:
  - the safety checks;
  - a group that exits early (the watchdog stops without sending anything);
  - a TERM-ignoring group killed on schedule;
  - the real `gardener.sh` running a new stub, `wall-bypass-handler-stub.sh`, whose TERM-ignoring child freezes `timeout` with SIGSTOP. The worker still returns, the child dies within budget + kill-after + lag + polling slack (9s against a 10s limit), rc=124 is logged, and the marker file is cleaned up.
- The existing `handler-orphan-reap-test.sh` still passes 15/15.
- `timeout-classifier-test.sh` (14 failures) and `handler-budget-test.sh` fail, and they fail the same way on unmodified `main2`. Their fixture job is never claimed (`budget-pool-refuse-unknown`), so that breakage is older than this change.

**Follow-ups**
- Fix the claim refusal in the `timeout-classifier-test` and `handler-budget-test` fixtures; those suites currently test nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gardener-handler-wall-bound.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1774300 cached reads)
- Output: 26118 tokens
- Cost: $1.6481960000000002
- Wall-clock: 353s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
