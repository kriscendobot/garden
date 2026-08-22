---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr475-review-e560d700
verdict: miss
category: process
pr: 475
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.
review_at: 2026-08-22T00:39:47Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4998388584
identity: endojs/endo-but-for-bots#475:review:4998388584
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr475-fix-dataview-20260821
missed_by: post-fix review process; breaker and saboteur correctness lenses never ran on the introducing head
severity: minor
grounds: |
  The review identified an asymmetric lifecycle for two inverse WeakMaps in
  immutable-arraybuffer's emulation. Immutable-buffer creation installed only
  the wrapper-to-genuine entry, while the TypedArray and DataView constructors
  separately installed the reverse entry. That made the constructor writes
  necessary only because the paired-map invariant had not been established at
  the object-creation boundary. Commit 4dbe5ffff corrected the ownership by
  installing both directions together and removed both downstream writes.
  This follows from the code and fix, not from the primary report.

  The garden's only recorded gauntlet for PR #475 reviewed head b28bb1fc3 on
  2026-08-19 and explicitly applied a byteArray correctness/adversarial lens.
  The map lifecycle was introduced later by fixer commit a4767d542b on
  2026-08-21. The fixer job's durable report records tests and gates but no
  subsequent panel pass, so the panel could not inspect the new invariant
  before the maintainer did. A correctness pass tracing every read and write of
  the inverse maps should have challenged why their entries were created at
  different lifecycle points and found the duplicated TypedArray and DataView
  updates. This is a review-process miss on newly introduced code, not a new
  requirement or taste preference. It is minor because the asymmetry was
  corrected before merge and no externally observable failure was established.
---

The maintainer's review (paraphrased) questioned whether the DataView reverse-map
update duplicated state that should already exist, and asked whether the
TypedArray emulation repeated the same pattern. Inspection showed that both
constructors were compensating for an inverse-map entry omitted at immutable
buffer creation. The correction centralized the paired writes and removed both
constructor-level updates.

The review miss is that the substantive post-gauntlet fixer commit reached human
review without a fresh correctness pass over its map lifecycle. See `comment_url`
to re-fetch the original review.
