# FIX round 6 report: endojs/endo-but-for-bots#1574

I applied both must-fix items from the latest panel verdict (review 5663489260 on head `f5eb7688`) and pushed them. CI is green: 30 of 30 checks passed, `ci-wait-merge` returned 0.

The job carried no pre-pass block, so the input was that panel review.

**Must-fix items applied** (in `designs/api-key-agent-workbench.md`):
- **Archivist:** the reference "§ Budget, *Serialization mechanism*" pointed at a heading that doesn't exist. It now points to *Serialization and the broker lease*.
- **Copyeditor 1:** the workbench now reads as one bundle. A write-tier `grant-workbench` also writes the read-only companion `endowments/workbench-read`, and the three places that describe this agree that `remove: ['workbench']` deletes both names.

**Small should-fix items also applied:**
- The broker is now "one per provider", not "one per key, or 'provider'" (copyeditor 2).
- The abort/overrun sentence now says plainly that the charge stays at the reservation and any later usage is recorded as an overrun (copyeditor 3).
- The `pause` row now says "per-period bound" instead of "in absolute terms" (copyeditor 4).
- In `designs/README.md`, I removed the per-phase day counts, which no design doc supports, and kept the total of about 3-3.5 weeks (archivist 2, pruner 8). The archivist could still flag that total as unsourced, since the design has no estimates at all.

Prettier passes on both files. The fix is one follow-up commit, `e63abd611a`, pushed with `safe-push-pr-head.sh` as a fast-forward from `f5eb768836`.

**Not addressed, for panel-7 or the maintainer:**
- The remaining ergonomist naming and semantics suggestions (none were must-fix).
- Copyeditor items 5 to 10.
- The pruner's padding cuts and PR-body trims.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (785080 cached reads)
- Output: 4492 tokens
- Cost: $0.72036
- Wall-clock: 570s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
