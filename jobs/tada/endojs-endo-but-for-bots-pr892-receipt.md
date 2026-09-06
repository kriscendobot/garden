The receipt was generated, archived, and posted successfully.

## Completion report

Ran the deterministic receipt generator `scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 892`. It completed exit 0, idempotently building the per-engagement rows, the maintainer-review heuristic, posting the identity-pinned PR comment, and archiving the receipt in the journal.

**Results for PR #892** (merged — *docs(endor): complete npm-via-CAS registry proxy design*):
- **Archive path:** `receipts/endojs-endo-but-for-bots/2026/09/pr892.md` (full: `/home/kris/garden2/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr892.md`)
- **Posted comment URL:** https://github.com/endojs/endo-but-for-bots/pull/892#issuecomment-5557399071
- **Summary:** 14 engagements across 6 bases; 592,251 billable tokens; notional $50.60 / calibrated $1.59; maintainer review heuristic ~52 min ≈ $130.00 (≈82× machine cost).

Both idempotency guards (journal archive file + comment marker `<!-- garden-receipt: endojs/endo-but-for-bots#892 -->`) are in place, so re-runs won't double-post. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr892-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (246532 cached reads)
- Output: 1856 tokens
- Cost: $0.49540300000000004
- Wall-clock: 224s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
