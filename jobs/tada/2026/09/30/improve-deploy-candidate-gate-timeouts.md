**Completion report: improve-deploy-candidate-gate-timeouts**

The deploy candidate gate now gives a suite that timed out on attempt 1 a larger per-suite cap on its one retry. It rejects the candidate instead if that larger retry can't fit the total time budget. Pushed to `main2` as `17a2d4b4999`.

**What changed in `scripts/jobs/deploy-garden.sh`**
- **New setting:** `GARDEN_DEPLOY_TEST_SUITE_RETRY_TIMEOUT` (default 150s) sets the retry cap for a timed-out suite. It is checked to be a positive integer like the other limits. If it isn't larger than the base cap, the base cap is used.
- **Tracking timeouts:** `execute_gate_suites` now records which suites timed out (rc 124, or 137 after the `--kill-after` kill). It also accepts per-suite cap overrides. The first attempt passes none, so it behaves exactly as before.
- **Before retrying:** suites that timed out get the larger cap and other failed suites keep the base cap. The gate adds up those caps:
  - **If the total fits** `GARDEN_DEPLOY_TEST_TOTAL_TIMEOUT`, it logs the escalation and runs the retry in a fresh gate root as before.
  - **If it doesn't fit,** it runs no retry and rejects the candidate with a `timeout-escalation-over-total-budget(need=…; total=…)` entry, reported through the normal failure path. The attempt-1 diagnostics are kept.
- **Unchanged:** syntax (`bash -n`) errors, missing suites and the total wall-clock limit still fail closed with no retry. Diagnostics from both attempts are still kept under per-attempt filenames. The header comment now describes the escalation.

**New fixtures in `scripts/jobs/test/deploy-garden-test.sh`** (14 new assertions, all passing). Both use a probe that sleeps 3s against a base cap of 1s:
1. **Escalation passes:** with a retry cap of 8s and a total of 20s, attempt 1 fails with rc=124 and the escalation is logged. The suite runs exactly twice, the attempt-1 diagnostic is kept, the deploy goes ahead and the drain is lifted.
2. **Budget refusal:** with a retry cap of 30s and a total of 20s, the refusal is named in the rejection and no retry is attempted. The suite runs once, the attempt-1 diagnostic is kept, the checkout is not advanced and the drain is never engaged.

**Test result:** the suite reports 171 passed, 5 failed. The same 5 checks also fail on the untouched base commit (157 passed, 5 failed), so this change didn't cause them. They are the busy-marker deferral and stale-marker checks. Their failure messages show the unexpected `kind: monk` and the gate's own log lines instead of the expected deferral output. That looks like the monk worker kind on this host leaking into the fixtures, but I didn't dig further.

**Follow-ups**
- Someone should fix those 5 environment-sensitive deferral checks in `deploy-garden-test.sh`. That wasn't part of this job.
- With the defaults (60s cap, 150s retry cap, 300s total), the retry fits only if the retried suites' caps add up to 300s or less. Two timed-out suites need exactly 300s, so the incident's shape now gets its escalated retry, but three or more would be refused. Raise the total if longer retries are wanted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deploy-candidate-gate-timeouts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (694136 cached reads)
- Output: 10791 tokens
- Cost: $0.8485672000000002
- Wall-clock: 212s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
