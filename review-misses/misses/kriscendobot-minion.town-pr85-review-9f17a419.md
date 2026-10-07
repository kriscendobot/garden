---
kind: review-miss
primary_job: kriscendobot-minion.town-pr85-review-9f17a419
verdict: miss
category: security-hardening
pr: 85
cluster: identity-gated-authority
cluster_pattern: A per-action authorization decides by asking WHO the caller is (an owner/identity equality check such as record.owner === caller) instead of by possession of a transferable, attenuable capability, contrary to the ocap premise.
review_at: 2026-09-30T02:41:16Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5360873327
identity: kriscendobot/minion.town#85:review:5360873327:retro
producing_role: builder
producing_job: minion-town-clip-upgrade-in-place
missed_by: builder (prevention: no builder-brief rule against identity-keyed authorization); locksmith (sensing: brief and C-locksmith probe cover attenuation/Far/guards but not identity-equality authorization checks); no panel ran on #85 before the review
severity: major
grounds: |
  The 2026-09-03 build job minion-town-clip-upgrade-in-place made clip upgrade
  "owner-gated exactly like unpublish" (record.owner === owner in publish.ts,
  owner derived from the caller's verified identity), documented it in an
  "Authorization (deliberate)" PR-body section, and tested "rejects an owner who
  does not own the clip". This violates a standing rule that already existed and
  bound the project: minion.town designs/mcp-endo-guest.md, Access-control
  directive (maintainer, 2026-07-09, on main since 2026-07-10), which says
  per-action authorization is the capabilities the guest holds, denial is the
  absence of a capability, and no grant keyed on iss+sub decides a per-action
  question. The builder copied a pre-existing sibling pattern (unpublish's owner
  gate) instead of applying the directive. In the 2026-09-30 CHANGES_REQUESTED
  review 5360873327 the maintainer flagged exactly this: asking who is acting
  violates the ocap premise, and the publish/upgrade right should be a
  transferable or attenuable capability. This was not new direction. The
  principle is foundational to the garden's Endo/ocap domain and was written into
  the project's design of record.
  Review history: journal/jobs/tada/ holds no gauntlet or panel job for #85 before
  2026-09-30. All six panel rounds (kriscendobot COMMENTED reviews) are dated
  2026-10-03, after the fix. Under the 2026-09-03 manual-gauntlet regime no panel
  was due (see the dismissal kriscendobot-minion.town-pr85-review-ca62c58f), so
  this is not avoidance/evaluator-gaming. It is still a miss on both halves. On
  prevention, the builder brief's structural-hardening directive (from
  capability-hardening-attenuation) covers guards and runtime-flag attenuation but
  not identity-keyed authorization. On sensing, neither the locksmith brief nor the
  C-locksmith probe names an owner/identity equality check as a finding, and the
  probe's pattern (attenuate|Far|Exo|grant...) need not fire on such a diff. Had a
  panel run, nothing directed a seat at this shape.
  Severity major: security-class (authority model), and the grounds cite a
  standing rule that existed and did not bind.
  Primary verified in the world: kriscendobot-minion.town-pr85-review-9f17a419
  handed off to kriscendobot-minion.town-pr85-fix-ocap-publish-authority (in
  tada/ 2026-09-30). That fixer replaced the owner gate with an unguessable,
  attenuable upgradeCapability (upgrade-capability.ts, attenuateUpgrade tool),
  replied on the PR (issuecomment-5903264374), and posted
  design-minion-town-clip-lifecycle-capabilities for unpublish/listSites, which
  still key on owner. PR #85 head commits (2026-10-03) include "add revocable,
  attenuable upgrade capabilities". The deliverable exists, so there is no no-op
  discrepancy.
---

# Miss: clip upgrade authorized by owner identity instead of a held capability

The maintainer's review on PR #85 objected that the PR let only the clip's owner
publish or upgrade it, decided by checking the caller's identity. They said this
goes against the object-capability premise and asked for the publish/upgrade right
to be a capability that can be passed on or narrowed. minion.town's own design of
record (mcp-endo-guest.md, Access-control directive, 2026-07-09) already required
per-action authority to come from held capabilities rather than identity checks.
The builder instead copied unpublish's existing owner gate. No panel had run on
the draft before the review, and no seat brief or probe targets identity-equality
authorization, so the review cycle would not have caught it either. Re-fetch the
verbatim review at comment_url.
