When the shared GitHub API cooldown is active, terminal gauntlet receipts no longer log a warning each. They are now saved as pending records quietly and posted after the cooldown ends. The fix is pushed to `main2` as commit `893ccdaa1a1`.

**What changed**
- **`scripts/jobs/gauntlet.sh`**: `gauntlet_terminal_comment` now checks `api_cooldown_active rest` before it reads the PR's comments, the same check `retry_terminal_pending` already does. If the cooldown is active, it returns "retry later" without a warning. The caller then saves the pending receipt along with the finish, as it does for any other deferral. The cooldown's owner still logs its one quota warning, so the per-gauntlet warnings (like the two at 07:53:01 and 07:53:11) are gone.
- **`scripts/jobs/test/gauntlet-test.sh`**, new subtest 15: two gauntlets halt while the cooldown is set. The test checks that both finish and leave pending records, that neither logs a warning, and that no comment read reaches the `gh` stub. After the cooldown is cleared, it checks that each receipt is posted exactly once and its pending record is removed. Against the old `gauntlet.sh` the subtest fails on the warning spam (67/68); with the fix the whole suite passes (68/68).
- **`scripts/jobs/test/gauntlet-gh-stub.sh`**: the stub can now log comment reads (`GAUNTLET_GH_READS_LOG`) so the test can count them.

**A second fix the test needed:** the gauntlet suite already failed at subtest 1 on unmodified `main2`, and on this host every run would fail. The token meter was counting this host's real Claude transcripts (about 102M tokens) against the test's 73M budget. That parked every stage as `over-token-budget`. The suite now points `GARDEN_CCUSAGE_LOGDIR` and `GARDEN_API_COOLDOWN_DIR` at its throwaway directory, so real host state no longer affects it.

**Possible follow-up:** other tests that use `seed_calibrated_test_pool` may fail the same way on busy hosts. Setting `GARDEN_CCUSAGE_LOGDIR` in the shared test helper would cover them all.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-terminal-receipt-cooldown-noise.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1788583 cached reads)
- Output: 9479 tokens
- Cost: $1.2279365999999998
- Wall-clock: 448s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
