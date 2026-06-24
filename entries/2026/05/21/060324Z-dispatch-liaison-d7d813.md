---
ts: 2026-05-21T06:03:24Z
kind: dispatch
role: builder
project: endo-but-for-bots
to: builder
---

# Dispatch: builder d7d813 — mirror endojs/endo#2887 onto endo-but-for-bots@master (autonomous-loop pickup; bot-pushable redo)

Dispatch root: `dispatches/builder--d7d813/`. Project worktree on `endojs/endo-but-for-bots@master` (head `9213d2c566dc013da8454af92147c8154c178f80`).

Autonomous-loop pickup (2026-05-21T06:03Z): continuing the pattern the maintainer authorized via *"For recent engagements where we were unable to push to endojs/endo, recall that we need to create a mirror PR in endo-but-for-bots."* PR #2901 already cycled through this pattern (gauntlet terminated round 1, PR #332). This dispatch applies the same shape to **PR #2887**.

## Prior #2887 mirror state

Builder `d7878e` (journal `entries/2026/05/20/215539Z-dispatch-liaison-d7878e.md`, result `220146Z-result-liaison-d7878e.md`) rebased PR #2887 onto **`kriscendobot/endo@master`** with branch `mirror/2887-naming-module-location-specifier` at head `06248a4915` (README rename clean, node-modules.js hunk moot+dropped). That mirror got the cross-fork PR-create block. This dispatch is the bot-pushable redo.

## The source PR (#2887)

- Title: *fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes*
- Author: kriskowal, head `09874b70932001981ba938f6fdd996c33cf57f48`, base `master`
- Substance: naming-correction refactor in `@endo/compartment-mapper`. From the prior builder's report: README rename was clean; one `node-modules.js` hunk was moot and dropped (already aligned on master). Likely 0-1 conflicts on endo-but-for-bots@master too, since endo-but-for-bots tracks endo's master closely.

## Task

### Phase 1: rebase onto current endo-but-for-bots@master

`gh pr diff 2887 --repo endojs/endo --patch > /tmp/2887-ebfb.patch`. Branch from `master` (head `9213d2c5`) and apply via `git apply --3way /tmp/2887-ebfb.patch`. Survey first: on endo-but-for-bots@master, has the README rename already happened? Has the `node-modules.js` hunk already been incorporated? Drop hunks that are moot, exactly as builder d7878e did on the kriscendobot side.

Preserve kriskowal authorship; bot identity is the committer. Commit subject: `fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes`.

### Phase 2: push + open DRAFT PR

Push branch `mirror/2887-naming-module-location-specifier` to `endojs/endo-but-for-bots`. **The bot has direct push permission here.**

Open DRAFT PR via `gh pr create --repo endojs/endo-but-for-bots --base master --head mirror/2887-naming-module-location-specifier --draft --title "fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes" --body "<body>"`. Body cites original endojs/endo#2887, rebase base, and notes the prior kriscendobot mirror at `mirror/2887-naming-module-location-specifier @ 06248a4915` got cross-fork-block; this is the bot-pushable redo so the gauntlet can run.

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `mirror/2887-naming-module-location-specifier`, create draft PR against `master`.
- READ-ONLY on `endojs/endo`. No comments.

## Out of scope

- Don't touch files outside #2887's diff (modulo conflict-resolution against current tree).
- Don't open un-draft. Don't merge.
- Don't run the gamut's downstream stages — the liaison's autonomous-loop tick continues them on your return.

## Report

≤ 300 words:
1. Conflict count from `git apply --3way` + dropped-hunk audit (which hunks were moot and skipped).
2. Branch + head SHA pushed.
3. PR URL.
4. `yarn lint` and `yarn test` for `@endo/compartment-mapper` (the touched package).
5. One-line `Self-improvement: ...`.

Write into `journal/entries/2026/05/21/<HHMMSS>Z-result-builder-d7d813.md`, commit+push to origin journal before returning.
