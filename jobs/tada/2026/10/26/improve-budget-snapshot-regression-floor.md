## Completion report: improve-budget-snapshot-regression-floor

When a budget reading comes in below the last published spend for the same window, the snapshot now keeps the published high-water spend, even if the re-measure also reads low. A drop is published only when an entitlement boundary is clearly identified after the last published sample. Pushed to main2 as `13683d24992`.

**What changed**
- **`scripts/jobs/usage-meter.sh`, `_budget_spend_regression_recheck`:** it still re-measures once and takes the larger reading. If that reading is still below the published spend, it now publishes the old spend instead of the lower one, and logs a WARN that says it is holding.
- **The one exception:** a drop is published when `_meter_entitlement_cutoff` finds an effective boundary that is later than both the window start and the published sample's `sampled_at_epoch`. That means a new server epoch started after the last sample. A snapshot with no `sampled_at_epoch` never counts as a transition, so it keeps the floor.
- A change of window (`window_start_epoch` differs) is still never compared with the old window. The entitlement scan only runs when a reading has regressed twice, so normal ticks cost nothing extra.
- **`scripts/jobs/test/budget-snapshot-spend-regression-test.sh`:** I replaced the old "genuine drop publishes" case, which encoded the bug, with:
  - the exact 47944967 → 47922983 replay, which now holds 47944967;
  - two undercounting ticks in a row, which both hold 900;
  - an entitlement boundary after the published sample, where the drop publishes;
  - a boundary before the published sample, which still holds.

**Verification**
- The regression test passes, including after rebasing onto the latest main2.
- The other `budget-snapshot-*` and `meter-*` tests pass.
- `budget-live-percent-label-test.sh` (commit-message check) and `live-budget-admission-test.sh` (4 leveling failures) fail. They fail the same way on main2 without my change, so this commit didn't cause them.

**Follow-up:** someone should look at those two failing suites, which are already broken on main2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-snapshot-regression-floor.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (832753 cached reads)
- Output: 7601 tokens
- Cost: $0.8474986
- Wall-clock: 295s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
