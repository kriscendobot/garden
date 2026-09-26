Implemented and pushed commit 07a7d198027e to main2.

- Added verified garden-fork branch fallback using `GARDEN_BOT_LOGIN`.
- Refuses fallback when upstream availability cannot be verified.
- Verifies fetched SHA before checkout.
- Added regression coverage for fork fallback and failure cases.
- Tests: project-worktree-isolation 46/46 passed; botanist worktree tests 7/7 passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-branch-worktree.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 238s

<!-- garden-usage-end -->
