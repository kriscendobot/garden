---
gate: orchestrated
orchestrated_by: pr-readiness-arc-plan-20261007
priority: normal
arc: garden-upkeep
posted_by: producer
posted_at: 2026-10-07T15:52:49Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
handler-timeout: 7200
dispatch: automatic
---
**Role: fixer.** Child 1/3 of orchestration `pr-readiness-arc-plan-20261007`: **classify 115 open bot PRs by arc and milestone.**

**Context.** On 2026-10-06 the readiness audit (`design-pr-gauntlet-coverage-audit.sh`) filed one `watchdog-pr-gauntlet-readiness-<repo>-pr<N>-<sha>.md` maintainer notice for each of 115 bot-authored PRs that are OPEN, NOT draft, and have no gauntlet review staged. The liaison verified on 2026-10-07 that all 115 are still open and still on the head the audit saw. Maintainer directive (kriskowal, liaison muster 2026-10-07): classify each PR by the milestone/arc it serves so its review can be charged to a budget; for every PR that has not had a gauntlet, **plan** one at the foreman's discretion under that arc's budget; for every PR with CHANGES_REQUESTED, verify the requested changes were applied and bring it back to the maintainer inbox as a review request.

Arcs are the active schema-2 slices in journal `config/arc-budgets/` (minion-town-mcp-ocapn, minion-town-git-remote, minion-town-ui, endo-ocapn-background, moonshots, garden-upkeep, garden-book, endo-backlog, unallocated); their order and wording live in `config/apportionment` and `config/foreman-mandate`, which also names the current milestones (M2, M3, …). This orchestration is `pr-readiness-arc-plan-20261007`; the shared classification table is journal `projects/garden/pr-readiness-arc-classification-20261007.md`.

**Task.** For each PR below (URL, then its review decision as of 2026-10-07), read its title, body, linked issues/designs and branch, and assign:
- `arc`: exactly one active arc from `config/arc-budgets/`. Use the foreman mandate's descriptions; a PR serving none of the named threads gets `unallocated`. Note that `endo-backlog` is the "already-staged gauntlets only" sliver, so prefer the thread a PR actually advances.
- `milestone`: the mandate milestone it advances (M2, M3, …) or `-`.
- `disposition`: `gauntlet` (decision NONE or APPROVED: no gauntlet yet) or `verify-changes` (CHANGES_REQUESTED). Also flag `superseded?` with a one-line reason when the change is already on its base or overtaken by a merged PR; do NOT close anything.
- a one-line `why`.

Write the result as a markdown table (columns: repo, pr, title, review, arc, milestone, disposition, superseded?, why) to journal `projects/garden/pr-readiness-arc-classification-20261007.md` and push it to `journal2`. Put per-arc counts at the top. Do not post, plan, or archive anything else; children 2 and 3 act on the table.

**PRs (115):**
```
https://github.com/endojs/endo-but-for-bots/pull/60 NONE
https://github.com/endojs/endo-but-for-bots/pull/71 NONE
https://github.com/endojs/endo-but-for-bots/pull/79 NONE
https://github.com/endojs/endo-but-for-bots/pull/96 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/101 NONE
https://github.com/endojs/endo-but-for-bots/pull/129 NONE
https://github.com/endojs/endo-but-for-bots/pull/138 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/151 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/155 NONE
https://github.com/endojs/endo-but-for-bots/pull/166 NONE
https://github.com/endojs/endo-but-for-bots/pull/170 NONE
https://github.com/endojs/endo-but-for-bots/pull/179 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/182 NONE
https://github.com/endojs/endo-but-for-bots/pull/186 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/216 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/235 NONE
https://github.com/endojs/endo-but-for-bots/pull/237 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/238 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/241 NONE
https://github.com/endojs/endo-but-for-bots/pull/242 NONE
https://github.com/endojs/endo-but-for-bots/pull/249 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/250 NONE
https://github.com/endojs/endo-but-for-bots/pull/251 NONE
https://github.com/endojs/endo-but-for-bots/pull/253 NONE
https://github.com/endojs/endo-but-for-bots/pull/256 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/258 NONE
https://github.com/endojs/endo-but-for-bots/pull/264 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/266 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/278 NONE
https://github.com/endojs/endo-but-for-bots/pull/279 NONE
https://github.com/endojs/endo-but-for-bots/pull/281 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/283 NONE
https://github.com/endojs/endo-but-for-bots/pull/288 NONE
https://github.com/endojs/endo-but-for-bots/pull/289 NONE
https://github.com/endojs/endo-but-for-bots/pull/303 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/305 NONE
https://github.com/endojs/endo-but-for-bots/pull/306 NONE
https://github.com/endojs/endo-but-for-bots/pull/311 NONE
https://github.com/endojs/endo-but-for-bots/pull/313 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/318 NONE
https://github.com/endojs/endo-but-for-bots/pull/319 NONE
https://github.com/endojs/endo-but-for-bots/pull/320 NONE
https://github.com/endojs/endo-but-for-bots/pull/321 NONE
https://github.com/endojs/endo-but-for-bots/pull/322 NONE
https://github.com/endojs/endo-but-for-bots/pull/324 NONE
https://github.com/endojs/endo-but-for-bots/pull/329 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/334 NONE
https://github.com/endojs/endo-but-for-bots/pull/344 NONE
https://github.com/endojs/endo-but-for-bots/pull/346 NONE
https://github.com/endojs/endo-but-for-bots/pull/347 NONE
https://github.com/endojs/endo-but-for-bots/pull/348 NONE
https://github.com/endojs/endo-but-for-bots/pull/350 NONE
https://github.com/endojs/endo-but-for-bots/pull/353 NONE
https://github.com/endojs/endo-but-for-bots/pull/355 NONE
https://github.com/endojs/endo-but-for-bots/pull/356 NONE
https://github.com/endojs/endo-but-for-bots/pull/357 NONE
https://github.com/endojs/endo-but-for-bots/pull/359 NONE
https://github.com/endojs/endo-but-for-bots/pull/360 NONE
https://github.com/endojs/endo-but-for-bots/pull/389 APPROVED
https://github.com/endojs/endo-but-for-bots/pull/450 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/469 NONE
https://github.com/endojs/endo-but-for-bots/pull/472 NONE
https://github.com/endojs/endo-but-for-bots/pull/508 NONE
https://github.com/endojs/endo-but-for-bots/pull/509 NONE
https://github.com/endojs/endo-but-for-bots/pull/546 NONE
https://github.com/endojs/endo-but-for-bots/pull/554 NONE
https://github.com/endojs/endo-but-for-bots/pull/555 NONE
https://github.com/endojs/endo-but-for-bots/pull/586 NONE
https://github.com/endojs/endo-but-for-bots/pull/594 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/599 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/660 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/667 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/670 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/730 NONE
https://github.com/endojs/endo-but-for-bots/pull/741 NONE
https://github.com/endojs/endo-but-for-bots/pull/756 NONE
https://github.com/endojs/endo-but-for-bots/pull/762 NONE
https://github.com/endojs/endo-but-for-bots/pull/764 NONE
https://github.com/endojs/endo-but-for-bots/pull/779 NONE
https://github.com/endojs/endo-but-for-bots/pull/825 NONE
https://github.com/endojs/endo-but-for-bots/pull/832 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/847 NONE
https://github.com/endojs/endo-but-for-bots/pull/880 NONE
https://github.com/endojs/endo-but-for-bots/pull/883 NONE
https://github.com/endojs/endo-but-for-bots/pull/887 NONE
https://github.com/endojs/endo-but-for-bots/pull/977 NONE
https://github.com/endojs/endo-but-for-bots/pull/996 NONE
https://github.com/endojs/endo-but-for-bots/pull/1016 NONE
https://github.com/endojs/endo-but-for-bots/pull/1038 NONE
https://github.com/endojs/endo-but-for-bots/pull/1049 NONE
https://github.com/endojs/endo-but-for-bots/pull/1061 APPROVED
https://github.com/endojs/endo-but-for-bots/pull/1089 NONE
https://github.com/endojs/endo-but-for-bots/pull/1146 NONE
https://github.com/endojs/endo-but-for-bots/pull/1156 NONE
https://github.com/endojs/endo-but-for-bots/pull/1281 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/1343 APPROVED
https://github.com/endojs/endo-but-for-bots/pull/1348 CHANGES_REQUESTED
https://github.com/endojs/endo-but-for-bots/pull/1349 NONE
https://github.com/endojs/endo-but-for-bots/pull/1355 NONE
https://github.com/endojs/endo-but-for-bots/pull/1381 NONE
https://github.com/endojs/endo-but-for-bots/pull/1394 NONE
https://github.com/endojs/endo-but-for-bots/pull/1416 NONE
https://github.com/endojs/endo-but-for-bots/pull/1427 NONE
https://github.com/kriscendobot/endo-but-for-bots/pull/1 NONE
https://github.com/kriscendobot/moddable/pull/1 NONE
https://github.com/kriscendobot/vattr97/pull/1 NONE
https://github.com/kriscendobot/endo/pull/2 NONE
https://github.com/kriscendobot/moddable/pull/2 NONE
https://github.com/kriscendobot/finbot/pull/7 NONE
https://github.com/kriscendobot/minion.town/pull/32 CHANGES_REQUESTED
https://github.com/kriscendobot/minion.town/pull/37 APPROVED
https://github.com/kriscendobot/minion.town/pull/94 NONE
https://github.com/kriscendobot/minion.town/pull/130 APPROVED
https://github.com/kriscendobot/minion.town/pull/143 NONE
https://github.com/kriscendobot/minion.town/pull/153 NONE
```

**Done when** the table holds all 115 rows and is pushed. If you cannot classify all of them, emit `<<<GARDEN-ORCHESTRATION-FAILED>>>` per skills/orchestration/SKILL.md.
