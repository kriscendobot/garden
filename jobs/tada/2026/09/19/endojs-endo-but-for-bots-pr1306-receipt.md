The receipt generator ran cleanly and idempotently.

Completion report:

**Job:** Emit the completion receipt for endojs/endo-but-for-bots PR #1306 (merged).

**What I did:** Ran `scripts/jobs/pr-receipt.sh endojs/endo-but-for-bots 1306`. It built the per-engagement rows + maintainer-review heuristic, posted the identity-pinned PR comment, and archived the receipt in the journal — all in one idempotent pass.

**Results:**
- **Journal archive:** `receipts/endojs-endo-but-for-bots/2026/09/pr1306.md` (written under `.garden-state/receipts/journal/`)
- **Posted comment:** completion receipt comment posted on `endojs/endo-but-for-bots#1306` — https://github.com/endojs/endo-but-for-bots/pull/1306

**Follow-ups:** None. The generator is fail-open and guarded by the archive file + comment marker, so a re-run is a clean no-op. No garden-repo changes were needed (nothing to commit/push).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1306-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (50183 cached reads)
- Output: 575 tokens
- Cost: $0.36284949999999994
- Wall-clock: 98s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
