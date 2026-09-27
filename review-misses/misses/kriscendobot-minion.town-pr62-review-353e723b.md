---
kind: review-miss
primary_job: kriscendobot-minion.town-pr62-review-353e723b
verdict: miss
category: naming
pr: 62
cluster: incomplete-rename-old-name-sweep
cluster_pattern: A rename lands the new identifiers but review does not sweep the whole PR for the old names, so stale references to the pre-rename byte API survive in code.
review_at: 2026-08-31T23:09:16Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/62#pullrequestreview-5072254610
identity: kriscendobot/minion.town#62:review:5072254610
producing_role: builder
producing_job: minion-town-rename-main-worker-to-at-main
missed_by: no panel ran (PR opened ready-for-review with no gauntlet/panel job in jobs/tada); the rename-discipline backstop (stylist) and ergonomist naming seat would have owned the old-name sweep
severity: moderate
grounds: |
  PR #62's whole purpose was a directed rename of the guest's provisioned
  worker from MAIN to @main. The producing builder job reported a src/ grep
  found no other worker-name literals, and opened the PR ready-for-review
  (not draft). journal/jobs/tada holds no gauntlet or panel job for PR #62,
  only the builder, the review primary, and conductor jobs, so no review stage
  ran before the maintainer. The maintainer's approving review pointed out that
  the guest-provisioning path, where the old MAIN name actually originates, was
  not covered and asked for the upstream work to be linked. The primary's
  fix-up (1aafcbefe6) confirms the gap: it had to add a MAIN fallback because
  the pinned Endo daemon still exposes only MAIN, so the original rename
  switched the gateway's evaluate call to a worker name the live daemon does not
  provide yet. The unit-test doubles did not model that. That is a rename that
  changed the consumer without tracing the name back to its producer. The rename
  target was already decided, so checking completeness (every site that produces
  or consumes the old name, including across the dependency seam) is the same
  whole-PR old-name sweep gap as the pr475 member. The ask to link upstream
  work is follow-up bookkeeping, not new direction. Severity is moderate, not
  major: no pre-existing rule explicitly requires a producer-side or
  cross-repo old-name sweep, so the standing-rule bypass does not apply. The
  missing gauntlet is a secondary process factor. It is not filed separately,
  because a retro records one category, and the builder-pr-gauntlet-bypass
  cluster already tracks that shape.
---

The maintainer approved the rename of the guest's provisioned worker from MAIN
to @main. They noted that the code that provisions guests with that worker also
needed renaming, possibly with upstream Endo changes to endow special names, and
asked for the latest related work to be linked. See `comment_url` to re-fetch the
untrusted review text.

The review miss: a directed rename changed the consumer call site but never
followed the old name to where it is produced (guest provisioning across the
Endo seam). The maintainer had to point out the gap. No panel ran on the PR.
