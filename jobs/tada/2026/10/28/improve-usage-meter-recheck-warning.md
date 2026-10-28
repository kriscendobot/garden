The meter no longer logs WARN when a second measurement fixes a briefly low reading. The fix is pushed to main2 as `abed1bbfc34`.

**What changed**
- **`scripts/jobs/usage-meter.sh`** (`_budget_spend_regression_recheck`): when the second measurement comes back at or above the published spend, the line is now logged at info (no `WARN:` prefix, so journald files it as info). The new line reads: `<pool> spend re-measure recovered a transient low reading below the published <old> for window <cutoff>; publishing <spend>`. This is the case from 2026-10-28T20:02:05Z, which re-measured 85,199,489 against a published 83,780,782.
- **WARN is still used for the two real cases:**
  - the second reading is still low, so the published high-water spend is kept;
  - the drop is published because a change of usage window (entitlement transition) was identified.
- I updated the function's comment to say this.
- **`scripts/jobs/test/budget-snapshot-spend-regression-test.sh`:** the test now checks the log level of each case. The recovered case must log its line with no WARN, the held case must WARN with "holding", and the entitlement-drop case must WARN with "publishing the drop".

**Checks:** the regression test passes all 7 cases. Shellcheck reports nothing new; its only warnings were already in the file.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-usage-meter-recheck-warning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (428553 cached reads)
- Output: 3249 tokens
- Cost: $0.5748346000000001
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
