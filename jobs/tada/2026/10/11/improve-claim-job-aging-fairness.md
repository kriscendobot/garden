**Completion report: improve-claim-job-aging-fairness**

`claim-job.sh` now tries jobs that have waited past an age threshold before the usual rotation, so a job like PR 171's panel-7 can't sit unclaimed for hours while newer jobs are taken. The fix is on main2 as `d6a3b1ba04c`. The new test passes.

**What changed in `scripts/jobs/claim-job.sh`:**
- **New claim order:** canary probes first, then aged jobs, then the existing worker-offset rotation for everything else.
- **Threshold:** a job is aged once it has been in `todo/` longer than `GARDEN_CLAIM_AGING_SECONDS`. The default is 3600 (one hour). Setting it to `0` turns the age tier off.
- **How age is measured:** the `posted_at:` header if the job has one. Otherwise, the time of the commit that added the file to `todo/`.
- **Cheap check:** one `git log --since` covering only the last hour finds the recently added jobs, and every other job counts as aged. If a clone's history is shorter than an hour, header-less jobs all look aged, which just falls back to the plain rotation.
- **Collisions:** among aged jobs each worker keeps its own rotation, so workers spread across several old jobs instead of all racing for one.
- **Eligibility unchanged:** host requirements, provider fit, the boatman lockout, project pause and the retry back-off are all still checked per job, so an aged job this host can't run is skipped as before.

**Decision for you:** requeueing a job (moving it from `doin/` back to `todo/`) counts as a fresh add, so its clock restarts. I chose that so a job that keeps failing doesn't stay at the front of the line. If you'd rather a reaper-requeued job keep its original age, producers would need to stamp `posted_at`.

**Tests:**
- New `scripts/jobs/test/claim-aging-priority-test.sh` (4 checks, all pass). It covers:
  - every worker offset claiming the eligible aged job first;
  - an aged job pinned to another host being skipped;
  - an old `posted_at` header winning over a recent add commit;
  - a canary probe still beating aged work;
  - setting the threshold to `0` restoring the plain rotation.
- `canary-probe-claim-priority-test` and `host-requirements-gating-test` still pass.
- `live-budget-admission-test` fails 4 checks and `auction-reputation-test` fails 9. They fail the same checks with and without this change, so they were already failing and are unrelated.

**Follow-ups (not done):**
- Producers don't write `posted_at` yet. Adding it would make job age independent of git history.
- If there's a standing claim-latency SLO, the one-hour default may need tuning to match it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-claim-job-aging-fairness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (831263 cached reads)
- Output: 11238 tokens
- Cost: $0.8931566000000001
- Wall-clock: 442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
