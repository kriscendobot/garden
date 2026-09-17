Done. Completion report:

## Press tick 2026-09-17 ~20:3xZ — #1125 re-review landed as a split directive

**Material arc state change this tick** (first since the 17:35Z tick's "no change"): kriskowal re-reviewed `endojs/endo-but-for-bots#1125` (item 7's sole artifact-level blocker) repeatedly 19:34–19:55Z, culminating in review `5240765072` (CHANGES_REQUESTED) **directing a split into a stack of smaller PRs** — "the scroll-back for review has gotten too deep for effective review" — suggesting three slices (read-only directory attenuation / guests inviting further guests / special+pet naming). This *answers* the standing "re-review #1125 at `42bad923`" ask from the 11:23Z press comment. Head advanced `42bad923` → `9fad002b`.

**State verified (assessed via REST, not trusted):**
- `endojs/endo-but-for-bots#1125` — draft, CHANGES_REQUESTED, split directive now governs; a stray `test (24.x, macos-15)` CI leg is red (the known floating-Node-24/better-sqlite3 infra flake), not a regression.
- `kriscendobot/minion.town#99` (item 1) — un-drafted, CLEAN/MERGEABLE, CI green, **still no review**. Unchanged.
- `endo#1015`, `minion.town#87` — still draft/untouched (08-31 / 09-03). Design PRs `mt#96/#97/#98`, `endo#1226/#1227/#1228` — all still draft, none merged (#1226 CHANGES_REQUESTED, in gauntlet). Nothing newly unblocked.

**Checklist updated:** appended the split directive to item 7's evidence line and to the Known-blockers `#1125` paragraph (CapTP half now resolves through the split stack, not further monolith review). Architecture/item specs untouched. Body pushed. Respected the cross-repo autolink rule (qualified/full links throughout).

**Comment posted** (state changed → warranted): [issue#89 comment 5720933828](https://github.com/kriscendobot/garden/issues/89#issuecomment-5720933828) — review ask `mt#99` (completes item 1, the only review that moves the arc this tick); state change = the #1125 re-review became a split directive, monolith self-driving.

**Jobs:** none posted. The split work is already on the board — `split-pr1125-into-stack` (builder, TODO) and a review-response fixer `endojs-endo-but-for-bots-pr1125-review-af33f29e` (DOIN). No design merged → no floor build newly unblocked. `build-minion-town-invitation-onboarding` correctly stays parked behind #1125's CapTP work. Did not flood.

**Follow-up / observation (fleet, not blocking):** the in-flight review-response fixer `pr1125-review-af33f29e` pushes to the monolithic #1125 head that the split will retire — some of its effort may be superseded once `split-pr1125-into-stack` runs. Both are already claimed; I did not interfere. Worth the orchestrator's awareness if the two race.

**Inbox:** empty. No garden-repo file changes → nothing to commit to main2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20260917-203511.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (918940 cached reads)
- Output: 12293 tokens
- Cost: $1.4746799999999998
- Wall-clock: 218s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
