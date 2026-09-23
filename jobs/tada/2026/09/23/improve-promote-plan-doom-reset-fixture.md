I updated the fixture in `scripts/jobs/test/promote-plan-doom-reset-test.sh` for how the reaper works now. It passes 35/35, down from 2 failures on every run, and is pushed to `main2` as `e47b4d0803c`.

**Why it failed:** the reaper no longer puts a job in `plan/` after its first overrun. Now it sends the job back to `todo/` for an orchestrator to split it. So SUBTEST 2's starting point ("the overrunning job is parked in `plan/`") and its control always failed. Its "not parked again after promotion" check passed without testing anything, because the job was never in `plan/`. SUBTEST 4 had the same blind spot: it used the overrun marker, which now always leads back to `todo/`.

**Changes:**
- **SUBTEST 2** now reaches the park the way the reaper still parks a job in `plan/`: its one retry is already spent (`<!-- garden-reaped: 1 -->`) and it exits again without progress. It checks:
  - **(a) The park:** the job lands in `plan/` marked `doom_signature: requeue-exhausted` and `requeue_cycles: 2`, with no cycle markers left in its body.
  - **(b) Promotion:** the job really moves from `plan/` to `todo/`, and on its next stale cycle it gets its one delayed retry (count back at 1, with a not-before time) instead of being parked again.
  - **(c) A body with markers already in it**, as an older host or a hand edit would leave. Promotion records the reset (`cleared=reaped=2`) and the job then gets a real retry. Only the promotion-time strip protects this case.
  - **(d) The control:** the same body with the counter still on it is parked again straight away, so the reaper's protection still works.
  - **(e) An overrun** goes to the split orchestrator in `todo/` with its marker removed, not to `plan/`.
- **SUBTEST 4** now uses the `garden-reaped: 1` counter, so a leftover counter would actually cause the job to be parked again.

**Mutation check:** I temporarily removed the marker stripping from `promote-plan.sh` and `post-plan.sh`. That made 4 checks fail, including both end-to-end ones (2(c) and 4), so the test now catches the bug. I then restored the originals.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-promote-plan-doom-reset-fixture.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (627810 cached reads)
- Output: 9049 tokens
- Cost: $0.8741340000000001
- Wall-clock: 104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
