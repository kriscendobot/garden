Receipt emitted successfully. Both idempotency guards are now satisfied (journal archive + comment marker), so any re-run is a clean no-op.

## Completion report

Ran the deterministic receipt generator for the merged PR:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1310
```

It built the per-engagement rows + maintainer-review heuristic, archived the receipt in the journal (winning the push CAS after two lost races), and posted the identity-pinned PR comment — all in plain code (no `claude -p`).

**Results:**
- **Archive path:** `receipts/endojs-endo-but-for-bots/2026/09/pr1310.md` (journal `journal2`; local clone at `/home/kris/garden/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1310.md`)
- **Posted comment:** https://github.com/endojs/endo-but-for-bots/pull/1310#issuecomment-5768356659

No garden-repo (`main2`) changes were needed — this job only generates/posts/archives a receipt. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1151471 cached reads)
- Output: 6331 tokens
- Cost: $1.2927425000000001
- Wall-clock: 1264s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
