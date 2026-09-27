The receipt job is complete.

## Completion report

Ran the deterministic receipt generator for the merged PR:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1227
```

It succeeded (exit 0), idempotently, after one journal-fetch retry (first attempt timed out at 45s, second succeeded).

**Outputs:**
- **Archive path:** `receipts/endojs-endo-but-for-bots/2026/09/pr1227.md` (journal), materialized at `/home/kris/garden/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1227.md`
- **Posted comment URL:** https://github.com/endojs/endo-but-for-bots/pull/1227#issuecomment-5854942307

**Receipt summary (PR #1227 — "docs: design guest bot incarnation on mailbox delivery", merged):**
- 33 engagements across 20 bases
- Billable tokens: 2,065,123 — calibrated $0.60 / notional $47.69
- Maintainer review: 7 sittings, 20 comments, ~328 min → dominance ratio 1362× (human review vastly dominates machine cost, consistent with the known ~50–190× median)

No garden source changes were needed — this is a receipt-emission job; the generator posts the PR comment via the identity-pinned gh and archives to `journal2`, both guarded against double-posting. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (366270 cached reads)
- Output: 2610 tokens
- Cost: $0.6738449999999999
- Wall-clock: 225s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
