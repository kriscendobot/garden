---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split
priority: normal
posted_by: orchestrator
posted_at: 2026-10-16T05:05:59Z
---

---
role: shepherd
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the completion summary on endojs/endo-but-for-bots PR #1396

This is the final serial child of
`endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split`.
It runs only after the CI child completes successfully.

Read the live PR and the predecessor reports from a freshly fetched
`origin/journal2`. Verify that PR #1396 is based on
`build/sturdyref-captp-wire-6f3185b`, that its required checks are green, and note
the final head SHA. Then follow `skills/pr-completion-summary-comment` and post the
required completion summary comment. Before posting, inspect existing comments so
a retry does not duplicate an already-posted equivalent summary.

The summary must cover:

- the new frozen base and the one rebased #1396 commit;
- resolution of `packages/ocapn/test/parcel.test.js`, retaining both #1394's
  “OCapN carries a Parcel it did not mint” test and #1396's cross-instance
  forwarding test;
- the strengthened forwarding test, which reads the Parcel back through the
  second instance and verifies a distinct Parcel with intact details;
- the design-conformance finding: #1394's head already implements the layer-6
  portion of the #1460 Parcel design (`6973c078` and `designs/parcel.md`), received
  Parcels use the receiving client's open hook
  (`makeParcelTracker(locator, openDetails)`), and forwarding uses the initial
  `locate`, so no minting-client restriction or further #1396 source change was
  needed;
- the local checks already observed (`packages/ocapn` `yarn test` and `yarn lint`)
  plus the live CI evidence from the predecessor.

Report the durable comment URL. If the required comment cannot be posted, finish
with the orchestrated-failure signal. If every fleet-available check is complete
and the sole remaining barrier is interactive maintainer login/MFA, use the
orchestrated-auth-unavailable signal instead.
