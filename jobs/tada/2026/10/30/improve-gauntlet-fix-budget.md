Gauntlet fix stages now have their own handler budget, separate from clean's. It defaults to 10800s (3h) instead of the 7200s shepherd budget that killed `endojs-endo-but-for-bots-pr1573-gauntlet-fix-1` at 7201s. Pushed to main2 as `0366a1927d0`. Both affected test suites pass: `gauntlet-test.sh` 101/101 and `follow-up-gauntlet-budget-test.sh`.

**What changed**
- **`scripts/jobs/gauntlet.sh`**:
  - Adds a new setting, `GARDEN_GAUNTLET_FIX_HANDLER_TIMEOUT`, defaulting to 10800s. That is the same value as the panel stage's budget.
  - Fix stages now get this budget. Clean stays on `GARDEN_GAUNTLET_STAGE_HANDLER_TIMEOUT`, which still defaults to 7200s.
  - The default leaves about an hour of headroom under the claim ceiling (about 14339s), so a fix round still fits in one claim. The 3600s CI-wait deadline is unchanged.
- **`scripts/jobs/handlers/follow-up-claude.sh`**: follow-up jobs from fix stages (`fu-…-gauntlet-fix-N-M`) now get the fix budget. Clean follow-ups keep the clean budget, and an explicit valid `handler-timeout:` still wins.
- **Regression coverage**:
  - `gauntlet-test.sh` asserts that a fix stage carries `handler-timeout: 10800`, still fits within the claim TTL, and keeps `handler-budget-role: shepherd`.
  - `follow-up-gauntlet-budget-test.sh` asserts that fix follow-ups default to 10800 rather than the shepherd budget, that overriding the fix setting changes only fix follow-ups, and that clean is unaffected.
- **`skills/job-board/SKILL.md`**: documents the three gauntlet stage budgets (clean, fix, panel) and how each overrides the role default.

**Follow-ups**
- This only takes effect once hosts deploy the new main2.
- Fix stages that are already queued keep their old 7200s budget, because it was written into the stage when it was posted. A pr1573 fix stage posted after deploy gets the new 10800s.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-fix-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1170030 cached reads)
- Output: 9571 tokens
- Cost: $1.021034
- Wall-clock: 985s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
