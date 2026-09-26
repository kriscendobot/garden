The receipt job is complete.

## Completion report

Ran the deterministic receipt generator for the closed PR:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1125
```

Exit 0. It performed both idempotent steps:

- **Archived** the completion receipt at:
  `receipts/endojs-endo-but-for-bots/2026/09/pr1125.md`
  (journal path: `/home/kris/garden2/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1125.md`)
- **Posted** the completion-receipt PR comment (identity-pinned `gh`) on endojs/endo-but-for-bots#1125:
  https://github.com/endojs/endo-but-for-bots/pull/1125#issuecomment-5850278960

No garden source changes were needed (this job only runs the generator), so there is nothing to commit or push. The generator is fail-open and idempotent (journal archive + comment marker `<!-- garden-receipt: endojs/endo-but-for-bots#1125 -->` guards), so a re-run is a clean no-op. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 14 tokens (289722 cached reads)
- Output: 2012 tokens
- Cost: $0.584441 (2 engagement(s) unpriced)
- Wall-clock: 284s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
