---
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Finish the endojs/endo-but-for-bots PR #1396 Parcel restack: base move, CI, summary

Wear the shepherd role. Successor of `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-r5527149922`,
which ran on oros-studio, where the bot PAT gets 403 on every endojs PR write.

Already done (do NOT redo):
- Froze #1394's head `6f3185b487c9ac92974533e9f50054d544db0f26` as
  `build/sturdyref-captp-wire-6f3185b` (pushed).
- Rebased #1396's only commit with `git rebase --onto 6f3185b build/parcel-captp-wire-6d089a6`.
  The conflict in `packages/ocapn/test/parcel.test.js` kept both #1394's "OCapN carries a
  Parcel it did not mint" test and #1396's cross-instance forwarding test. The
  cross-instance test now also reads the parcel back through the second instance and
  checks that it gets back a distinct Parcel whose details are intact.
- Force-pushed with lease `build/sturdyref-captp-construct` = `609821f7118d0633132a5df973ae1f789f696066`.
- Locally: `packages/ocapn` `yarn test` passes (parcel + bytewise suites clean) and
  `yarn lint` (tsc + eslint) has 0 errors.
- Design check: #1394's head already does the layer-6 part of the #1460 Parcel design
  (commit 6973c078 + designs/parcel.md). Received Parcels are built with the receiving
  client's open hook (`makeParcelTracker(locator, openDetails)`). Forwarding goes
  through the initial `locate`, so there is no minting-client restriction. No source
  change was needed in #1396.

Remaining:
1. `gh pr edit 1396 -R endojs/endo-but-for-bots --base build/sturdyref-captp-wire-6f3185b`
   (or REST PATCH pulls/1396 base=...). Confirm the PR diff is now just the one commit.
2. Drive CI green on head 609821f. As of 2026-10-15T18:50Z the repo had started NO
   Actions runs since 16:12Z, including none for this push. If runs are still missing,
   close and reopen the PR or push an empty commit to re-trigger, then fix any failures.
3. Post the required PR completion summary comment (skills/pr-completion-summary-comment).
   Cover the new base, the one rebased commit, the conflict resolution, the test
   strengthening, and the design-conformance note above.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T04:18:00Z
