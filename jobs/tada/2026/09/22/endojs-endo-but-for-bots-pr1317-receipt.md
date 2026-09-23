The receipt job is complete.

## Completion report

Ran the deterministic completion-receipt generator for the merged PR:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1317
```

**What happened:**
- The generator built the per-engagement rows and maintainer-review heuristic, archived the receipt in the journal (lost one push race on attempt 1, re-synced, then succeeded — expected idempotent behavior), and posted the identity-pinned PR comment.
- No double-posting; the archive-file and comment-marker guards held.

**Results:**
- **Archive path:** `receipts/endojs-endo-but-for-bots/2026/09/pr1317.md` (journal), full path `/home/kris/garden/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1317.md`
- **Posted comment URL:** https://github.com/endojs/endo-but-for-bots/pull/1317#issuecomment-5771790302

**Receipt summary (PR #1317 — "chore: bump the all-minor-patch group with 19 updates", merged):** 18 engagements across 3 bases, 1,024,941 billable tokens, notional $15.86 / calibrated $0.04, maintainer review 4 sittings / 46 min / ~$115, dominance ratio 2792, 0 panel rounds.

No follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1317-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (539289 cached reads)
- Output: 3087 tokens
- Cost: $0.7456614999999999
- Wall-clock: 328s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
