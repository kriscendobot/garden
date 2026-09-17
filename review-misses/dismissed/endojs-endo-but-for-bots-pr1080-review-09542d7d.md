---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1080-review-09542d7d
verdict: not-a-miss
category: new-direction
pr: 1080
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1080:review:5063171490
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1080#pullrequestreview-5063171490
review_at: 2026-08-31T04:47:08Z
severity: minor
grounds: |
  Maintainer review 5063171490 (CHANGES_REQUESTED, MEMBER kriskowal, empty body)
  on PR #1080 (feat(exo-git): follow published root advancement) carried two
  inline suggestions, both subjective polish that no seat could have caught as a
  demonstrable convention violation:

  (1) On the GENERATED file
  packages/agent-tools/generated/code-mode-globals/git-declarations.js:74 —
  "I think we can be more specific than `unknown`." A soft precision suggestion
  on machine-generated declarations. The `unknown` was an artifact of the
  authored surface importing ERef namespace-style, which the declaration
  generator cannot resolve; the fix switched to a named ERef import so the
  generator preserves ERef<PassableReader<...>>. No seat brief, skill, or
  standing instruction says generated declarations must not collapse to `unknown`
  when a concrete type exists, so this is not a demonstrable typist/surfacer miss
  — it is a maintainer-owned precision preference on a regenerable artifact.

  (2) On packages/exo-git/test/root-follow.test.js:75 — "`watch` or `follow`?" A
  terminology decision between two defensible words. The design (#889) and PR
  title say "follow" for the high-level async-iterable API, while "watch" was
  legitimately retained for the native FS-polling mechanism; kriskowal picked
  "follow" for the seam method, and the author standardized on followRoot while
  keeping "watch" for the native watcher. Both words were defensible and no
  written naming rule encodes which to choose for this seam, so this is taste, not
  an ergonomist/rename-discipline violation — new direction first crystallized in
  the comment.

  Grounded in review history, not the comment text: a gauntlet DID run on this PR
  (journal/jobs/tada/ holds build-exo-git-follow-root-advancement-gauntlet-clean
  and -gauntlet-panel-1), so this is NOT evaluator-gaming/avoidance — the
  evaluator was not routed around. Critically, gauntlet-panel-1 is
  orchestration-failed: true — the single-round panel aborted at seat `assessor`
  after three empty-verdict attempts on WEEKLY-QUOTA exhaustion, posted no review,
  and left the draft unchanged. So no seat ever rendered a verdict on this diff:
  there is no seat-looked-and-missed to indict. That quota abort is a
  machinery/reliability failure (the mentor loop's domain, "the machinery
  misbehaved"), not a review-lens miss (the prosecutor's domain); recording it as
  a `process` miss would miscategorize a reliability incident as a seat-lens gap.
  Even had the panel completed, the two comments are subjective type-precision and
  terminology decisions the maintainer legitimately owns.

  The primary job (09542d7d) genuinely delivered and did NOT close as a no-op:
  commits 089f9a8da (fix(agent-tools): retain git follower reader types, with a
  generator regression test pinning both concrete signatures), 031f15d0a
  (fix(exo-git): call backend root stream a follower), and 75e1589b7
  (chore(exo-git): hoist test type import) all exist upstream; inline replies
  3892021628/3892021732 were posted; and PR #1080 is now MERGED. The directive
  deliverable exists in the world — no no-op discrepancy to report. Re-fetch the
  verbatim review/comments at comment_url.
---

Maintainer review 5063171490 (CHANGES_REQUESTED, empty body) on PR #1080 carried
two inline polish suggestions: use a more specific type than `unknown` in the
generated code-mode git declarations, and choose between "watch" and "follow" for
the backend root-stream seam. Both are subjective precision/terminology decisions
the maintainer owns — no seat brief, skill, or standing rule encodes either, so
neither is a review-process miss; this is a dismissal (new-direction/taste). The
gauntlet ran (clean + panel-1 in tada) but panel-1 aborted on weekly-quota
exhaustion and rendered no verdict, so there is additionally no seat-looked-and-
missed to indict; that quota abort is a mentor-loop machinery concern, not a
review-lens gap. The primary genuinely delivered (commits 089f9a8da, 031f15d0a,
75e1589b7; PR merged). Re-fetch the verbatim review body at comment_url.
