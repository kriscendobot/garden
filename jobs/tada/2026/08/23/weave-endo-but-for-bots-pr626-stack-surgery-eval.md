Rebased PR #627 onto current `llm`, then restacked PR #626 onto it. Updated the stack-surgery evaluation for the landed replay API, including explicit history-rewrite permission and bounded status results.

Pushed heads:
- #627: `080c93c33a2ca25f172f03fa31884c307f89d5af`
- #626: `1da6472809b89ca8529ee4281f2902bd96e36f66`

Both PRs remain DRAFT, are conflict-free, and have fully green CI. Local `@endo/agentry` tests passed (225 passed, 1 todo), focused tests passed (22), lint and pre-push probes passed. Posted completion summaries to both PRs. No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endo-but-for-bots-pr626-stack-surgery-eval.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 33 tokens (3619550 cached reads)
- Output: 27845 tokens
- Cost: $6.413828500000001 (1 engagement(s) unpriced)
- Wall-clock: 7294s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
