The receipt job is complete.

## Completion report

Ran the deterministic generator `scripts/jobs/pr-receipt.sh kriscendobot/garden 80` (exit 0). It built the per-engagement rows, computed the maintainer-review heuristic, posted the identity-pinned PR comment, and archived the receipt in the journal — all idempotently with its comment-marker and archive-file guards.

**Outputs:**
- **Archive path:** `receipts/kriscendobot-garden/2026/09/pr80.md` (absolute: `/home/kris/garden2/.garden-state/receipts/journal/receipts/kriscendobot-garden/2026/09/pr80.md`)
- **Posted comment URL:** https://github.com/kriscendobot/garden/pull/80#issuecomment-5557410999

**Receipt summary (PR #80, merged — "Design: ground rate-limiting cybernetics in the manual quota-checkpoint log"):** 4 engagements across 3 bases; 207,088 billable tokens; notional $4.57 / calibrated $0.29; maintainer review heuristic ~23 min ≈ $57.50 (≈201× the machine calibrated cost).

No code changes were needed (deterministic generator run only); nothing to commit or push. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr80-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (325458 cached reads)
- Output: 2196 tokens
- Cost: $0.539855
- Wall-clock: 230s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
