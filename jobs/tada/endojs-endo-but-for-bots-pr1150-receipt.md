The receipt posted successfully.

## Completion report

Ran the deterministic receipt generator for the merged PR #1150:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1150
```

**Results:**
- **Archived** receipt to journal: `receipts/endojs-endo-but-for-bots/2026/09/pr1150.md` (worktree path `/home/kris/garden2/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1150.md`)
- **Posted** completion-receipt PR comment: https://github.com/endojs/endo-but-for-bots/pull/1150#issuecomment-5567404614 ("🧾 Garden completion receipt — endojs/endo-but-for-bots#1150")

Both the journal-archive file and the comment marker guards mean the run was idempotent and fail-open — a re-run will not double-post. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1150-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (125357 cached reads)
- Output: 962 tokens
- Cost: $0.3825515000000001
- Wall-clock: 95s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
