---
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Finish the endojs/endo-but-for-bots PR #1398 Parcel restack: base move, PR body, CI, summary

Wear the shepherd role. This continues `endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-r5527149922`,
which ran on oros-studio. The bot PAT there gets 403 on every endojs PR write, including PATCH pulls/1398.

Already done (do NOT redo):
- Froze #1397's head `8f3d80100ff5354d82e4108c788a2a1c883a7552` as
  `build/sturdyref-ocapn-enliven-8f3d801` and pushed it to endojs/endo-but-for-bots.
- Rebased #1398's own 7 commits from the old frozen base `build/parcel-ocapn-open-9fda212` (9fda212)
  onto 8f3d801 with `git rebase --onto 8f3d801 9fda212`.
- Force-pushed with lease: `build/sturdyref-daemon-formula` 35ccea8 → `628a578ddba6179ed47931693f1474e7e496bce4`.
  `git diff --stat 8f3d801..628a578` shows 30 files, all #1398's.
- One conflict. #1398's `chore(ocapn): finish Parcel consumer migration` deleted the
  `makeSturdyRef`/`enlivenSturdyRef` aliases. The new base's `fix(captp,ocapn): satisfy Parcel carriage gates`
  (3fb727fc8) turned them into deliberate deprecated aliases: llm publishes those names, and the public
  `Client` type in `parcel.types.d.ts` includes both spellings. Both histories are kept. The base's
  aliases stay, and the commit is now `docs(ocapn): mark the SturdyRef client aliases deprecated` (3fcb4b57f),
  which adds `@deprecated` JSDoc to the two client methods in place of the stale "updated later in this
  stacked series" comment.
- Design check against #1460 (b757b8597, the rebased 6973c078, which is in the base): `parcelForFormula`
  mints a `@endo/parcel` Parcel whose open hook calls `provide(formulaId)`, so a dormant formula Parcel does not
  incarnate its target. `formulaIdOf` is a daemon-owned WeakMap, and the kit is not exported from the package.
  Export mapping, revocation and provenance stay with the daemon.
- Local checks on 628a578: `yarn install --immutable` passes. `yarn lint` has 0 errors in ocapn and daemon.
  Prettier is clean on the changed files. Tests: ocapn 546 passed; daemon `endo.test.js` +
  `invite-retention-ocapn.test.js` 285 passed; daemon `formula-parcel.test.js` 5 passed; thixotrope 103 passed;
  goblin-chat 4 passed; ocapn-noise 78 passed under each ava config. The first ocapn-noise/thixotrope runs
  failed only on an ava cache ENOENT race from running packages in parallel.

Remaining:
1. `gh pr edit 1398 -R endojs/endo-but-for-bots --base build/sturdyref-ocapn-enliven-8f3d801`
   (or REST PATCH pulls/1398 base=...). Confirm the PR shows exactly the 7 commits.
   If #1397's head has moved off 8f3d801 by then (its own finisher,
   `endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-finish-endolin`, may push CI fixes), re-freeze that head
   and re-weave #1398 with an explicit `--onto <new> 8f3d801`.
2. Update the PR body. It still says SturdyRef, `formula-sturdyref.js`, `makeFormulaSturdyRefKit`,
   `sturdyRefForFormula`, `formula-sturdyref.test.js`, "enlivening", and base `build/sturdyref-ocapn-enliven-0e0b333`.
   The code now says `formula-parcel.js`, `makeFormulaParcelKit({ provide })`, `parcelForFormula`,
   `formulaIdOf`, `formula-parcel.test.js`, and "opening". The base should read `build/sturdyref-ocapn-enliven-8f3d801`.
   Add one line on why the deprecated `makeSturdyRef`/`enlivenSturdyRef` aliases are kept.
3. Drive CI green on head 628a578 and fix any failures that belong to #1398. If no runs start,
   re-trigger them. Failures already seen on the predecessor (#1397) that are not this PR's: Prettier in
   `packages/patterns/test/rankCover.test.js`, and a macOS timeout in the daemon `provider-listener-runtime` test.
4. Post the required PR completion summary comment (skills/pr-completion-summary-comment). Cover the new base,
   the rebased commits, the alias conflict resolution, the design-conformance note, and test status.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T04:16:36Z
