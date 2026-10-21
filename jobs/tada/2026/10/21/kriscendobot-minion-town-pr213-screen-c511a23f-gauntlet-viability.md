**Viability check for kriscendobot/minion.town PR #213** ("Re-land #200 (three-item settings); accounts-store migration applied")

The gauntlet can go ahead. Nothing newer has replaced this PR, and the reason for re-landing it still holds.

**Deciding question:** Is #213 still the only route for the #200 settings work to reach `main`, and is it now deployable because the accounts-store migration has run?

**Evidence:**
- **PR state:** open, not merged, not a draft. Head `c511a23f`, base is the pinned branch `main-a84d6d6`.
- **Nothing has replaced it:** `main`'s latest commit is still `a84d6d6`, which is the merge of #211 (the revert of #200). `main` has no commits after the pinned base (ahead_by=0). No other open or merged PR re-lands #200.
- **The reason still holds:**
  - #200's deploy failed closed at startup because the `guest-formula-fingerprint` index was missing. #211 reverted #200 for that reason.
  - I checked live just now: `aws dynamodb describe-table minion-town-accounts` shows that index as `ACTIVE`. So the migration has run and the blocker is gone.
- **What it changes:** the PR reverts the revert (`87cebebf`). Its description says the result is byte-identical to the #200 merge `f6fe2b5`, which already passed its gauntlet.
- **Reviews and comments:** none yet, and nothing in the discussion argues against it.

**Follow-up for whoever deploys:** the PR notes that #210 (last-active time) also needs `deploy-accounts-store.sh` re-run before it deploys. This screen did not act on that.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr213-screen-c511a23f-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179569 cached reads)
- Output: 1308 tokens
- Cost: $0.4284578
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
