---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-10-12T19:22:48Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finalize (curate -> merge) kriscendobot/garden-book PR #8

PR: https://github.com/kriscendobot/garden-book/pull/8 ("Copy-edit for reader exposure").
Parked behind a maintainer go-ahead. The maintainer (kriskowal, 2026-10-12) put the
`garden-book` arc's 5M-token budget behind this sequence: gauntlet (#8) -> merge (#8) ->
`book-hyperlink-references-after-copyedit-20261004`. Promote this job only when the
gauntlet `kriscendobot-garden-book-pr8-gauntlet` has completed and the maintainer says go.

Guards (re-verify before merging):
- Bot repo only (kriscendobot/garden-book). Never merge agoric-sdk or the endojs upstream.
- The PR must be OPEN, mergeable, checks green (or no checks attached), un-drafted by the
  gauntlet, and carry an effective maintainer approval. If it regressed, dispatch the
  shepherd/fixer instead. Idempotent: if already merged or closed, do nothing.
- Do not name a merge method; the conductor owns that (roles/conductor/AGENT.md).
After merging, confirm the parked hyperlink job
`book-hyperlink-references-after-copyedit-20261004` is promoted by the unblock watcher.

<!-- garden-annotation: key=book-supervisor-delegation-20261012 by=orchestrator at=2026-10-12T20:22:06Z -->

Maintainer delegation carried by garden-book-review-supervisor-20261012 (manual mentat dispatch, 2026-10-12): the supervisor is granted the maintainer's go-ahead for kriscendobot/garden-book PRs only, provided the PR is open, mergeable, un-drafted, green/no checks, and the supervisor's own posted review is clean. This supersedes this job's older request for a separate maintainer go-ahead/signature for this repo only; do not switch identities or change fleet configuration. The current supervisor review is NOT clean yet: https://github.com/kriscendobot/garden-book/pull/8#pullrequestreview-5495588201 requires correcting the new Endo branch explanation. Keep parked until the adopted gauntlet completes and a supervisor verifies that correction and posts a clean review. The next supervisor owns promotion. Merge must land on the book's live main, not the frozen main-e6f2790 snapshot, and must preserve already-merged illumination/data work.
