Gauntlet fix round 2 for endojs/endo-but-for-bots PR #1433 is pushed and CI is green (28 checks, 0 failed).

I worked from the panel's latest review on head `4d7141de`. That review only shows each item cut short, so I worked out the archivist and assessor items from the cited lines and the daemon source. The full seat text was not available, so panel-3 should check that each item is actually covered.

All changes are in one commit, `22ed601bf`, to `designs/daemon-formula-identifier-indirection.md`. It went to `kriscendobot:design/formula-identifier-indirection` through `safe-push-pr-head.sh`.

**Archivist must-fix:**
- **Made-up function names (`:190`, `:205`):** the doc named `resolvePetName` and `resolveReference`, which don't exist in the daemon. It now names the real calls: the internal parts of `identify`, `lookup`, `lookupById` and `reverseLocate`.
- **The `from` parameter (`:107`):** the doc called it a formula number. In `locator.js` it is a handle number, alongside a second parameter, `fromNode`; the doc now says that.
- **SturdyRef swiss number (`:31-34`):** the doc said current SturdyRef sketches already use a formula number as the swiss number. Nothing in the tree backs that up, so it now describes this as a risk for future SturdyRef work instead.

**Archivist should-fix (`:408`):** "writers emit only `r1`" now reads "from stage 3 onward", which matches the rollout.

**Assessor must-fix 1 (shares that could never be revoked):**
- `locate()` used to issue a fresh share every time and throw away the control facet (the handle for revoking it).
- It now returns one reusable default share per pet-name binding. That share is listed and can be rotated or revoked through the owner's interface, and a later `locate` after revocation issues a new one.
- Migration step 4 now reuses those default shares too, so no issuance path leaves a share that can't be revoked.

**Assessor must-fix 2 (staging contradicted the v4 migration):**
- The v4 schema, migration and pet-store switch to `binding` references now land together in stage 1.
- Moving the inspector to session-scoped references becomes stage 2.
- I added a rollback policy. There is no in-place downgrade, so the migration copies the v3 database file aside before upgrading. Rolling back stage 1 means reinstalling the prior release and restoring that copy, which loses writes made after the upgrade. Stages 2–5 change no schema and roll back by reinstalling the prior release.

**Not addressed:** the assessor's should-fix about `rotate` possibly returning a dead locator. It was not a must-fix, and its text was cut off before the details.

Next is the driver's panel-3 stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (728237 cached reads)
- Output: 6881 tokens
- Cost: $0.7157234000000001
- Wall-clock: 697s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
