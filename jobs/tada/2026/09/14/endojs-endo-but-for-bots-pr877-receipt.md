The receipt generator ran successfully and idempotently.

## Completion report

Ran `scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 877` for the merged PR #877.

**Results:**
- **Archived receipt:** `receipts/endojs-endo-but-for-bots/2026/09/pr877.md` (in the journal, at `/home/kris/garden/.garden-state/receipts/journal/receipts/endojs-endo-but-for-bots/2026/09/pr877.md`)
- **Posted comment:** https://github.com/endojs/endo-but-for-bots/pull/877#issuecomment-5665766230

The generator built the per-engagement rows + maintainer-review heuristic, posted the completion-receipt comment via identity-pinned `gh` (kriscendobot), and archived the receipt to the journal — all guarded by the `<!-- garden-receipt: endojs/endo-but-for-bots#877 -->` comment marker and the journal archive file, so a re-run is a clean no-op.

No garden-repo changes and no follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr877-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (179895 cached reads)
- Output: 1109 tokens
- Cost: $0.4304184999999999
- Wall-clock: 92s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
