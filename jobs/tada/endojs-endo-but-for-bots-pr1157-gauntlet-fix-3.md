CI is green (rc 0). The fix stage is done.

## Completion report

**Job:** gauntlet FIX round 3 for endojs/endo-but-for-bots PR #1157 (design doc: indelible npm registry in every guest inventory).

**Panel verdict addressed:** The round-3 design panel returned **must-fix**; two seats requested changes (critic, skeptic). I applied their must-fix items plus a few zero-risk should-fixes from comment-only seats, in a single review-feedback commit (`c30031a43`) pushed to the PR head.

**Must-fixes applied:**
- **critic** — Parity section wrongly asserted Node/Endor "already share" the registry *tree contract* ("Now (both backends)"), contradicting the design's own Dependencies table (that tree design is Not Started). Reworded the Summary, Goal 4, the parity opener, and the staged list to state the shared tree contract as a *prerequisite this design builds on*, not a present-day fact.
- **critic** — Corrected the `leastAuthority`/`@none` precedent from "every agent's special names" to **host-only** (the guest overlay has no `@none` entry), noting a guest-side projection is adjacent to, not demonstrated by, that pattern.
- **skeptic** — The claim that per-caller rate/resource limits are "owned by npm-registry-as-directory-tree" is false (that design specifies no such bound). Rewrote to state no landed design owns the aggregate shared-root traffic bound, and made bounding it a **required property of the backend the operator seats**.
- **skeptic** — Acknowledged the per-guest distinct-root case where the `thisDiesIfThatDies` cascade would fit; stated the uniform GC-reachability choice deliberately leaves such a guest **alive-but-registry-dead**.
- **skeptic** — Added a **per-guest distinct-root isolation test** to the catalog.

**Folded-in should-fixes:** root-rotation non-goal (write-once field, decomplector); title-case H1 (pedant); "tree-node interfaces" and "behind a string" rewording (copyeditor).

**Result:** Pushed `9fa67bca1..c30031a43`; CI ran to terminal **GREEN** (5/5 checks, 0 failed) within the 3600s deadline. Panel not re-run (driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 56 tokens (1839775 cached reads)
- Output: 17595 tokens
- Cost: $2.0728044999999997
- Wall-clock: 776s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
