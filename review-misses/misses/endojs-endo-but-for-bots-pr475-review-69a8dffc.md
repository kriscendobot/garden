---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-69a8dffc
verdict: miss
category: correctness-bug
pr: 475
cluster: incomplete-sibling-transformation
review_at: 2026-08-19T20:02:58Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976249125
identity: endojs/endo-but-for-bots#475:review:4976249125:retro
producing_role: builder/fixer (byteArray narrowing campaign)
producing_job: endojs-endo-but-for-bots-pr475-feedback-20260819
missed_by: typist and spec-keeper; the gauntlet types/API lens and changeset-wide sibling enumeration
severity: moderate
grounds: |
  PR #475 centrally narrows passable byte arrays to Uint8Array. Before this
  review, the campaign's pending-feedback pass had already identified that some
  public byte helpers had been re-widened to accept a union of buffers and
  views, and its PR summary explicitly left that API-shape question for human
  review. The immediately following garden gauntlet reviewed the same roughly
  119-file increment through types/API and byteArray-correctness lenses, declared
  that it had found no production must-fix, and affirmatively said the widened
  declaration types matched runtime. It did not enumerate the remaining union
  signatures against the PR's narrowing invariant.

  The maintainer's review then required a complete, separately reviewable sweep
  with no buffer-or-view union signatures left. This was anticipatable rather
  than new direction: eliminating those unions follows directly from the PR's
  type-narrowing goal, the exact re-widening had already been surfaced in the
  garden's own feedback summary, and the panel carried both a types/API lens and
  the full incremental diff. The failure is another instance of the existing
  incomplete-sibling-transformation pattern: a family-wide narrowing converted
  some helpers and declarations while silently leaving siblings with the old
  broader shape, and review sampled the converted sites instead of proving the
  family complete. It is not evaluator gaming because the change did not move or
  bypass a measurement; the ordinary review lens simply stopped short of a
  complete sibling sweep.

  Grounded independently of the primary report: review 4976249125 has one inline
  reply on the concat helper thread and no top-level body; the parent thread asks
  why any API should retain the union at all. The primary later removed every
  exact ArrayBufferView-or-ArrayBufferLike spelling but explicitly carved out
  three semantically equivalent ArrayBufferLike-or-Uint8Array unions in hub and
  relay-server as out of scope, despite the review's all-remaining language.
  Those exceptions were subsequently narrowed by later work; current PR head
  affe74453 contains Uint8Array-only declarations at those boundaries. Thus the
  final world now contains the deliverable, but the primary's claimed completion
  was partial at its own head and required follow-on correction.

  Severity is moderate: this was a broad public-contract inconsistency in a
  pre-merge integration PR, not a demonstrated shipped runtime failure. After
  joining this record the cluster remains below the dispatch floor because both
  members are on PR #475.
---

The maintainer required the byteArray narrowing to be completed across the whole
family of helper and boundary signatures, in discrete reviewable commits, instead
of leaving some APIs accepting either a buffer or a view. The garden's types/API
panel had already seen both the narrowing goal and the remaining widened sibling
signatures but did not require a complete enumeration. See comment_url for the
verbatim untrusted review text.
