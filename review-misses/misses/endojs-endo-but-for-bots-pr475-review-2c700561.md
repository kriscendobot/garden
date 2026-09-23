---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-2c700561
verdict: miss
category: docs-drift
pr: 475
cluster: stale-identifier-reference-sweep
cluster_pattern: A broad identifier or file removal leaves old names and paths in comments, designs, or changesets because review samples individual prose defects but does not sweep all changed prose against the PR's rename and deletion map.
review_at: 2026-08-19T21:32:26Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4976935353
identity: endojs/endo-but-for-bots#475:review:4976935353
producing_role: builder/fixer campaign
producing_job: endojs-endo-but-for-bots-pr475 campaign
missed_by: archivist docs-and-comment-accuracy seat and stylist rename-discipline backstop
severity: moderate
grounds: |
  PR #475 renamed and re-homed byte utility APIs and removed their former source
  files, but the reviewed head still referred to removed identifiers and paths in
  an implementation comment, an added design, and two changesets. This was
  reviewable from the diff without maintainer-only knowledge: the old-to-new API
  map and deleted paths were explicit in the consolidation changeset, and the
  archivist seat's standing brief requires comments and JSDoc to keep describing
  the code after a change. The stylist also cites rename-discipline as its rename
  backstop. More directly, the 2026-08-19 gauntlet ran a types/style/docs lens over
  the 119-file incremental diff and found three related stale prose defects, but
  it did not finish a repository-wide old-name/path sweep: it missed the stale
  compareUint8Arrays reference and other occurrences that the subsequent review
  directive caused the fixer to find. The defect is therefore in review
  completeness rather than new direction. It is moderate because stale
  comments, design prose, and publishable changesets misdescribe the shipped API
  but do not change runtime behavior. No existing seat brief or deterministic
  gate explicitly requires constructing a rename/deletion map and sweeping all
  changed prose, so this is not eligible for the single-major standing-rule
  severity bypass.
---

The maintainer asked for a PR-head-wide search for additional stale references
after observing that a comment still named a replaced byte-comparison function.
The resulting sweep corrected that comment plus an added design and two
changesets that still described removed utility names or deleted file paths as
current. See `comment_url` to re-fetch the untrusted review text.

The review miss is that the gauntlet's own docs lens found several examples of
the same rename drift but stopped at sampled findings instead of reconciling all
changed prose against the rename and deletion map.
