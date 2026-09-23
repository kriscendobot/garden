Merged endojs/endo-but-for-bots PR #1040.

- Marked the draft ready for review.
- Confirmed kriskowal’s approval applied to head `ae296e0d0f84`.
- Confirmed 27 CI checks green and the branch current with `llm`.
- Merged with a merge commit: `e22e67acade25f4eda59f954902351b4ac867f8e`.
- Confirmed the merge commit is on `llm`; no downstream PR used the deleted head branch.
- Notified the dependent PR #475 workflow; its completed recipient caused the message to be durably dead-lettered for promotion.
- Removed the isolated project worktree.

Follow-up: the first merge-spine attempt exposed a shared `FETCH_HEAD` race; retrying succeeded without rewriting the approved head.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1116s

<!-- garden-usage-end -->
