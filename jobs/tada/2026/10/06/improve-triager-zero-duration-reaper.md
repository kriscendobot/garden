I fixed the zero-duration path in `triager_run_reaped` and pushed it to `main2` as commit `dc9cced94a7`. When the tick deadline is disabled, the triage handler now runs in its own process group without `timeout`. A new regression test checks that the handler actually runs.

**Root cause:** when `GARDEN_TRIAGE_TICK_DEADLINE` is disabled, the triager ran the handler as `timeout … 0 <handler>`. On this host GNU `timeout` 9.4 treats 0 as "no limit", so I could not reproduce the 04:04Z failure locally. Even so, a `timeout` that rejects a zero duration (exit 125) never runs the handler at all, and that matches the reported failure.

**Changes:**
- **`scripts/jobs/triager.sh`:**
  - `triager_run_reaped` now runs a zero duration (`0`/`0s`) under `setsid "$@" &` instead of `timeout`. The child still gets its own process group, so `triager_cleanup` can stop it the same way. Non-zero durations still use `timeout` as before.
  - Without `timeout`, nothing would escalate to SIGKILL, so a child that ignores TERM could make the stop hang. `triager_cleanup` now waits at most the kill-after grace (stored at launch, default `GARDEN_TRIAGE_HANDLER_KILL_AFTER`), then SIGKILLs the whole group.
- **`scripts/jobs/test/triager-pacing-test.sh`:** a new case runs a tick with `GARDEN_TRIAGE_TICK_DEADLINE=0` and a stub `timeout` on PATH that refuses a zero duration. It asserts the handler was called with the new SHA and the stub was never asked for a zero duration.

**Verification:**
- `triager-pacing-test.sh`: 15 passed, 0 failed, both before and after rebasing onto a peer's concurrent edit to the same test file.
- Against the old `triager.sh`, the new case fails with "stub timeout: refusing zero duration", so it catches the bug.
- `triager-test.sh`, which includes the cleanup tests for a stop mid-handler: 170 passed, 0 failed.
- `shellcheck` reports only more of the existing SC2317 "unreachable" notices on trap-invoked code.

**Follow-up:** hosts pick this up on their next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-zero-duration-reaper.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (883901 cached reads)
- Output: 9902 tokens
- Cost: $0.9488522000000001
- Wall-clock: 256s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
