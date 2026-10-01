I applied the round-3 must-fix items and pushed them to PR #1392 (head `2e92bd7790..6571479f91`). CI hit the 3600s deadline still pending: 32 of 33 checks finished with no failures, but the `test (24.x, macos-15)` leg was still running. `ci-wait-merge` returned rc 4, so this stage reports still-pending.

**What I changed, by juror:**
- **saboteur:** `packages/pass-style/src/sturdyref.js` now reads `isSturdyRef` and `prototype` without invoking accessors. A frozen global with a throwing accessor is now just untrusted, instead of crashing `passStyleOf` for every remotable.
- **purist:** the prototype's `constructor` and `Symbol.toStringTag` must now be non-enumerable, as in the remotable family's tag records.
- **prover:** the fixtures in `sturdyref-throwing-global.test.js` and `sturdyref-unfrozen-global.test.js` now have a correctly shaped prototype. The unfrozen one also needed a frozen `isSturdyRef`, which the panel didn't mention, so that only the unfrozen constructor can cause the rejection.
  - I checked that the tests now catch the bugs they name: with the `try`/`=== true` guard removed, the throwing test fails. With the `isFrozen(SturdyRef)` check removed, the unfrozen test fails.
- **wire-watcher:** three new `sturdyref-gated-global` cases cover an enumerable tag, a throwing accessor, and a rejected global not blocking a later valid one. I also added a doc comment pointing to `sturdyref-lying-global.test.js`.
- **stylist:** renamed `proto` to `prototype`.
- **corner-prober and breaker:** marshalling a SturdyRef with `toCapData` (capdata or smallcaps), or comparing two SturdyRefs with `compareRank`, now gives an error naming `'sturdyRef'` instead of "internal: Unrecognized passStyle". New tests cover both.
- **corner-prober (patterns):** a new test shows `M.lte`/`gte`/`lt`/`gt` given a SturdyRef throw a clean "cannot be a key" error.
- **changeset-auditor:** added `.changeset/sturdyref-passable.md` (patch for `@endo/sturdyref`) and updated the pass-style and marshal changesets.
- **pruner:** the PR body's stack list is cut to the immediate next step.
- **coverage-auditor and engine-realist:** the PR body now explains why there is no XS test run. No package in this stack has a working `test:xs` script, and that predates this PR.

All four packages' tests pass locally (pass-style, marshal, patterns, sturdyref), as do the per-package and repo-root `tsc` checks. ESLint reports no errors on the touched files. I posted a summary comment on the PR (issuecomment-5923129820).

**Not done:** the curator's comment-only suggestion to tie the `SturdyRef` and `SturdyRefObject` types together with a type-only import, and turning on `test:xs` across the repo.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3694146 cached reads)
- Output: 18564 tokens
- Cost: $1.9656611999999998
- Wall-clock: 3948s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
