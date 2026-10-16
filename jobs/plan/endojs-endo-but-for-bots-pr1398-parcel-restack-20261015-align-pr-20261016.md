---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin-split
priority: normal
posted_by: orchestrator
posted_at: 2026-10-16T05:08:45Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Align endojs/endo-but-for-bots PR #1398 with its frozen base and current Parcel description

Finish the base/ref and PR-description portion of the Parcel restack for
`endojs/endo-but-for-bots` PR #1398. This is the first stage of orchestration
`endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin-split`.

Known state from the predecessor:

- #1397's head `8f3d80100ff5354d82e4108c788a2a1c883a7552` was frozen as
  `build/sturdyref-ocapn-enliven-8f3d801`.
- #1398's seven commits were rebased from `build/parcel-ocapn-open-9fda212`
  onto that SHA and force-pushed with lease as head
  `628a578ddba6179ed47931693f1474e7e496bce4` on
  `build/sturdyref-daemon-formula`.
- The conflict resolution intentionally retained deprecated
  `makeSturdyRef`/`enlivenSturdyRef` client aliases because llm publishes them
  and the public `Client` type includes them. The rewritten conflict commit is
  `docs(ocapn): mark the SturdyRef client aliases deprecated` (`3fcb4b57f`).
- Prior local verification passed: immutable install; relevant lint and
  Prettier; ocapn (546), selected daemon (285 + 5 formula-parcel), thixotrope
  (103), goblin-chat (4), and both ocapn-noise configurations (78 each).

Required work:

1. Read current GitHub state first. If #1397's current head is no longer
   `8f3d801`, freeze its new head under the normal frozen-base naming scheme and
   re-weave #1398 explicitly from `8f3d801` onto that new SHA, preserving the
   seven-commit series and conflict intent. Use an isolated project checkout
   keyed by this child job and force-push only with an appropriate lease.
2. Move PR #1398's base to the frozen #1397 head branch. Confirm GitHub presents
   exactly the seven #1398 commits.
3. Update the PR body from stale SturdyRef terminology to the code's Parcel
   terminology: `formula-parcel.js`, `makeFormulaParcelKit({ provide })`,
   `parcelForFormula`, `formulaIdOf`, `formula-parcel.test.js`, and “opening”.
   Name the actual frozen base branch. Add one line explaining why deprecated
   `makeSturdyRef`/`enlivenSturdyRef` aliases remain.
4. Preserve useful existing body structure and links. Re-read the resulting PR
   base, head, commit list, and body as evidence before completion.

PR writes and any necessary branch push are explicitly authorized by the parent
job. Do not drive the full CI matrix or post the final completion-summary
comment; later orchestration children own those stages.
