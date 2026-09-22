The receipt was generated successfully and idempotently.

## Completion report

Ran the deterministic receipt generator `scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1309` for the merged PR #1309. It completed with exit 0 (the `cost-by-pr.sh --base-map` scan over the receipt journal is the slow step; the run took ~10 min but succeeded cleanly).

**Outcome:**
- **Archived receipt:** `/home/kris/garden/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr1309.md`
- **Posted PR comment:** https://github.com/endojs/endo-but-for-bots/pull/1309#issuecomment-5769994804

Both the journal archive (via file guard) and the PR comment (via marker guard) are idempotent, so a re-run would be a clean no-op. No garden-repo changes were needed; this job only emits the receipt. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1309-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (364361 cached reads)
- Output: 2052 tokens
- Cost: $0.9572475
- Wall-clock: 1026s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
