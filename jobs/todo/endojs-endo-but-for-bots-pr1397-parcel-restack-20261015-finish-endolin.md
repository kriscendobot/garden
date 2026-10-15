---
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Finish the endojs/endo-but-for-bots PR #1397 Parcel restack: base move, CI, summary

Wear the shepherd role. This picks up from `endojs-endo-but-for-bots-pr1397-parcel-restack-20261015-r5527149922`,
which ran on oros-studio. The bot PAT there gets 403 on every endojs PR write, including PATCH pulls/1397.

Already done (do NOT redo):
- Froze #1396's head `609821f7118d0633132a5df973ae1f789f696066` as
  `build/sturdyref-captp-construct-609821f` (pushed to endojs/endo-but-for-bots).
- Restacked #1397's own two commits from the old base `build/parcel-captp-construct-3202ecd`
  onto 609821f (an `--onto 609821f 3202ecd` replay; it applied as cherry-picks). There were no conflicts.
- Applied the #1460 Parcel design (6973c078, rebased on the base as b757b8597). The base
  already reads OCapN coordinates with the privileged `locate` from `@endo/parcel` in
  `getParcelDetails`, and it keeps the `ocapn-sturdyref` wire tag. A new third commit,
  `refactor(ocapn): open home Parcels through the bootstrap's nonce lookup`, adds one
  `lookupSecretBytes` helper. The home-open path and the bootstrap `fetch` lookup
  (`ParcelTracker.lookup`) both use it now. Remote opens still go through the peer bootstrap `fetch`. No behavior change.
- Force-pushed with lease `build/sturdyref-ocapn-enliven` = `8f3d80100ff5354d82e4108c788a2a1c883a7552`
  (was 9fda212). `git diff --stat 609821f..8f3d801` shows only #1397's 5 files.
- Locally: `packages/ocapn` `yarn test` passes 546 tests (28 skipped). `yarn lint` has 0 errors. Prettier is clean on the touched files.
- The old head 9fda212's CI failed only outside #1397: Prettier on
  `packages/pass-style/test/parcel-gated-global.test.js` and `packages/patterns/test/rankCover.test.js`
  (the first no longer exists on the new base), plus a daemon
  `provider-listener-runtime` PID-replacement test that timed out on macOS.

Remaining:
1. `gh pr edit 1397 -R endojs/endo-but-for-bots --base build/sturdyref-captp-construct-609821f`
   (or REST PATCH pulls/1397 base=...). Confirm the PR diff is now just the three commits.
   If #1396's head has moved off 609821f by then, re-freeze and re-weave with an explicit `--onto`.
2. Drive CI green on head 8f3d801. If no runs start, re-trigger them, for example by closing and reopening the PR. Then fix any failures that belong to #1397.
3. Post the required PR completion summary comment (skills/pr-completion-summary-comment).
   Cover the new base, the restacked commits, the lookup refactor, the design-conformance
   note above, and test status. The PR body's "stacked on ... b0778fa" line is stale.
   Update it to `build/sturdyref-captp-construct-609821f`.
