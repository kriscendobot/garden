PR #1402 is merged into the live `llm` trunk. I also found and fixed a bug in the garden's frozen-base cleanup script: it was silently skipping the old snapshot branch.

**The merge**
- I marked the PR ready for review. It had two design commits and no fixup commits, so there was nothing to tidy.
- The merge script switched the base from the frozen `llm-825c598bc` to `llm` and rebased cleanly (head `9ae6854838` → `0e0c8342986`). It then force-pushed with a lease.
- The first run exited "head changed, still unmerged" because GitHub hadn't yet picked up the pushed head. On the re-run CI went green on the new head (30 checks, 0 failed, after waiting on `lint`). kriskowal's approval still counted, and the script merged with a merge commit.
- I confirmed the result: `state=MERGED` on base `llm`, merge commit `346409f6d5f987f15493682c365db0bc1fec42d9`.
- No downstream PRs were based on this PR.

**The cleanup bug**
- After the merge, `sweep-frozen-bases.sh` found nothing to delete, although the `llm-825c598bc` branch still existed and no open PR used it.
- Cause: the script read base-change history from GitHub's REST issue-events feed, which leaves out the branch names on base-change events. So every PR switched from a frozen base back to the live trunk before merging (exactly what the conductor always does) kept its old snapshot branch.
- Fix: the script now reads the old and new branch names from GraphQL. I updated the test's fake `gh` and its fixture to match, and the test passes 23/23. The fix is pushed to main2 as `c810e1e6c42`.
- With the fix, the sweep deleted `llm-825c598bc` (it was at `825c598bc649`).

**Follow-up:** earlier merges from frozen bases have likely left snapshot branches behind for the same reason. Re-running the fixed sweep on recently merged PRs, or a one-off audit, would clean them up. I did not post that job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/conduct-endojs-endo-but-for-bots-pr1402-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1189647 cached reads)
- Output: 6666 tokens
- Cost: $0.8891294000000002
- Wall-clock: 862s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
