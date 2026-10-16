---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin-split
priority: normal
posted_by: orchestrator
posted_at: 2026-10-16T05:09:07Z
---

---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Post the completion summary for endojs/endo-but-for-bots PR #1398

This is the final, serial stage of orchestration
`endojs-endo-but-for-bots-pr1398-parcel-restack-20261015-finish-endolin-split`.
Its predecessors align the PR metadata/stack and drive required CI.

Read fresh PR, branch, commit, and check state for
`endojs/endo-but-for-bots` PR #1398, then follow
`skills/pr-completion-summary-comment` and post the required completion-summary
comment. The summary must accurately cover:

- the actual frozen #1397 base branch and current #1398 head SHA;
- the seven rebased #1398 commits;
- the alias conflict resolution: deprecated `makeSturdyRef` and
  `enlivenSturdyRef` remain because llm publishes them and the public `Client`
  type includes them;
- the design-conformance result: `parcelForFormula` mints a `@endo/parcel`
  Parcel whose open hook calls `provide(formulaId)`, so a dormant formula Parcel
  does not incarnate its target; `formulaIdOf` is daemon-owned and the kit is not
  exported, keeping export mapping, revocation, and provenance with the daemon;
- local verification inherited from the restack predecessor, clearly
  distinguished from any later checks: immutable install; relevant lint and
  Prettier; ocapn 546; selected daemon 285 plus formula-parcel 5; thixotrope
  103; goblin-chat 4; and ocapn-noise 78 under each configuration; and
- the current CI disposition, citing fresh observed evidence and any fixes made
  by the CI child.

Posting this one PR comment is explicitly authorized by the parent job. Avoid a
duplicate: inspect existing comments first and update/adopt an existing required
completion summary if the skill directs that behavior. Re-read the posted
comment and report its URL as completion evidence.
