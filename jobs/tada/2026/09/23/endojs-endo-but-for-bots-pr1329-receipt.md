The job is complete.

## Completion report

Ran the deterministic completion-receipt generator for the merged PR:

```
scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1329
```

It computed the per-engagement rows and maintainer-review heuristic, then idempotently archived the receipt and posted the PR comment (identity-pinned gh). Exit code 0.

**Results:**
- **Archive path:** `receipts/endojs-endo-but-for-bots/2026/09/pr1329.md` (in the journal at `/home/kris/garden2/.garden-state/receipts/journal/...`, pushed to `journal2`)
- **Posted comment:** https://github.com/endojs/endo-but-for-bots/pull/1329#issuecomment-5789274582

**Notes / benign transients (both handled by the script's fail-open, idempotent design):**
- The receipts journal clone's first fetch hit the 45s cap (attempt 1) but recovered on retry — the clone is ~265M, consistent with the known state-clone bloat pattern; not blocking here but a candidate for a gc/re-clone if it keeps timing out.
- The archive push lost a CAS race on attempt 1 and re-synced cleanly.

No garden-repo (main2) changes were needed and no follow-up jobs are required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1329-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (900976 cached reads)
- Output: 5224 tokens
- Cost: $1.0871009999999997
- Wall-clock: 242s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
