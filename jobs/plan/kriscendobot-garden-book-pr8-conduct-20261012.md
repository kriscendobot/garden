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
