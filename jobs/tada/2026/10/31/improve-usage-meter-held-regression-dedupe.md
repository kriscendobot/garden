A held spend regression now WARNs once instead of on every tick. The published spend is still held on every tick. The fix is pushed to `main2` as `a257ff3c3ed`.

**What changed** (in `_budget_spend_regression_recheck`, `scripts/jobs/usage-meter.sh`):
- **Fingerprint:** when a regression is held, a fingerprint of the pool is saved to `$GARDEN_STATE/usage/held-regression/<pool>`. It holds the window start, the held spend and the entitlement cutoff. The location can be changed with `GARDEN_BUDGET_HELD_REGRESSION_DIR`.
- **Same fingerprint on a later tick:** it logs at info, ending `holding N (already warned)`, and still holds the high-water spend.
- **When it warns again:** the fingerprint is cleared when the reading recovers or advances, the window changes, or a drop is published across an entitlement change. A different held spend or entitlement cutoff also counts as a new fingerprint, so it warns again.

**Tests:** I added a case to `scripts/jobs/test/budget-snapshot-spend-regression-test.sh` that reproduces the 13:31:40Z/13:46:42Z repeat. It checks that the hold warns once, that repeat ticks log at info while holding 900, and that each re-warn condition fires. All 8 cases pass.

**Unrequested fix to the test:** it was scanning this host's real Claude session logs, so a single run took more than 10 minutes. I pointed it at empty temporary directories, and it now runs in under a second.

**Not checked:** I didn't run the new test against the old code to see it fail first. Shellcheck shows one warning (SC2034, an unused variable around line 159 of `usage-meter.sh`), which was there before this change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-usage-meter-held-regression-dedupe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (926047 cached reads)
- Output: 8191 tokens
- Cost: $0.8406774
- Wall-clock: 705s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
