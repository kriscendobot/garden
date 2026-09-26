Receipt generated successfully.

## Completion report

Ran `scripts/jobs/pr-receipt.sh kriscendobot/minion.town 89`, the deterministic (fail-open, idempotent) completion-receipt generator for the merged PR #89.

**What it did:**
- Built the per-engagement rows + maintainer-review heuristic.
- Posted the completion-receipt comment to the PR via the identity-pinned `gh` wrapper.
- Archived the receipt in the journal.

**Outputs:**
- Archive path: `receipts/kriscendobot-minion.town/2026/09/pr89.md` (journal), materialized at `/home/kris/garden/.garden-state/receipts/journal/receipts/kriscendobot-minion.town/2026/09/pr89.md`
- Posted comment: https://github.com/kriscendobot/minion.town/pull/89#issuecomment-5557428522

No follow-ups. The generator is guarded by both the journal archive file and the comment marker, so a re-run is a safe no-op.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr89-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (92868 cached reads)
- Output: 752 tokens
- Cost: $0.38476699999999997
- Wall-clock: 96s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
