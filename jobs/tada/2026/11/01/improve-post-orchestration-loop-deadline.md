`post-orchestration.sh`'s push-retry loop now stops at the `GARDEN_POST_DEADLINE_SECS` limit (default 300s), the same way `post-job.sh` does. The new tests pass, and the change is pushed to `main2` as `796949fbe1a`.

**The fix** (`scripts/jobs/post-orchestration.sh`): the loop records its start time and checks elapsed time at the top of each attempt. Once the limit passes, it logs the reason and exits with rc=75 (`GARDEN_OFFLINE_RC`). Before this, a degraded journal remote could keep it going for all 50 attempts. Each attempt holds the producer clone lock, which is how the 2026-11-01 30-minute lock hold starved every other producer.

**The test**: I added three post-orchestration cases to `scripts/jobs/test/post-loop-wallclock-deadline-test.sh`. That file already holds the same checks for `post-job.sh` and `post-plan.sh`, so I put them there rather than in a new file.
- **Deadline already passed:** it exits rc=75 on the first attempt and records nothing.
- **Degraded journal:** the fetch works but every push fails (`GARDEN_PUSH_CMD=false`), with a 50-attempt budget and a 1s deadline. It gives up with rc=75 after about 1s, logs the deadline, and records nothing. A following `post-job.sh` then posts successfully, so the producer clone is free again.
- **Healthy run:** under the default deadline it still records the orchestration.

All 16 checks in the file pass (about 35s). `shellcheck` reports nothing on `post-orchestration.sh`. The test file's two shellcheck warnings were there before this change.

**What the test does not cover:**
- I simulated "unreachable" with failing pushes, not failing fetches. When the fetch itself fails, an earlier step (`sync_clone`) already exits with rc=75 on the first attempt, so the loop never repeats in that case. The repeated attempts only happen when fetches work and pushes keep failing.
- I didn't run the degraded case against the old code, so the test hasn't been seen failing without the fix. It does check for the new "wall-clock deadline" log line, which only the fix writes.
- I didn't run the longer `orchestrate-test.sh`.

No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-post-orchestration-loop-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1446079 cached reads)
- Output: 9963 tokens
- Cost: $1.0854438000000002
- Wall-clock: 851s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
