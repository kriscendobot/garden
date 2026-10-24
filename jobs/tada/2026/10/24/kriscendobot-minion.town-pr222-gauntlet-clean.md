**Clean stage for kriscendobot/minion.town PR #222: done, CI is green.**

PR #222 is the heal revert of #218, the guest bond ledger and backfill change that broke the `main` deploy. It is still a draft.

- **Coverage and dead code:** No changes were needed. I compared the PR head `be6889a5` against `c104813b^1`, which is `main` as it was before #218 landed, and the trees are identical. So the revert leaves nothing orphaned and adds no new code to test. Nothing was pushed.
- **CI:** `ci-wait-merge.sh --no-merge` exited 0 with all 4 checks passing: `changes`, `test`, `Claude harness (amd64)` and `Claude harness (arm64)`. My first run of the wait script was moved to the background and stopped when it hit the tool time limit. I then polled CI myself until only `Claude harness (arm64)` was left, and reran the script in the foreground to get the green result above.
- **Follow-ups:** None for this stage. The gauntlet goes on to the panel stage. Before #218 can land again, the operator has to run its account-store provisioning step against production (`LEGACY_BOND_WRITERS=active`, per its DEPLOYMENT.md), as the PR body says.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (408230 cached reads)
- Output: 2295 tokens
- Cost: $0.5161060000000001
- Wall-clock: 1795s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
