---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr56-ebea2826
verdict: not-a-miss
category: new-direction
pr: 56
repo: kriscendobot/minion.town
surface: pr-comment
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/56#issuecomment-5501487759
identity: kriscendobot/minion.town#56:comment:5501487759:retro
producing_role: designer
producing_job: unknown
missed_by: none-design-direction
severity: minor
review_at: 2026-09-01T22:51:28Z
grounds: >
  PR #56 is a design PR ("Design: invitation-only guest onboarding, superseding
  open self-signup"), and the maintainer's comment is a forward design directive
  under the rsvp verb. Paraphrased, it adds new product requirements to the
  invitation-acceptance workflow: an invitation does not immediately provision a
  guest; the recipient may already be authenticated as a guest and then only names
  their host handle, otherwise they first create a guest account; a guest may then
  bond to one or more OAuth providers, which the database must track. These are
  first-stated design requirements expressing the maintainer's desired UX fork —
  product taste and direction, not a defect, spec violation, missed edge case, or
  violated convention that any panel seat, gate, or standing instruction already
  knows. The board history confirms this is design elaboration, not an omitted
  review finding: #56 did run a full gauntlet (panel jobs 1-4, fix jobs 1-3,
  clean, undraft, conduct all in journal/jobs/tada/), and that panel reviews the
  design's internal quality, never whether the design anticipates unstated future
  product intentions the maintainer had not yet expressed. The primary directive's
  deliverable also exists independently of its report: design commit 946f92b
  ("design(onboarding): bind invitations to selected guests (#56)", 2026-09-01)
  is on the PR head, adding the existing-guest vs create-guest acceptance paths
  and the zero-to-many OAuth recovery-provider database modeling the comment
  asked for. This is new direction; no cluster or improvement job is warranted.
---

# Dismissal: minion.town #56 comment 5501487759 (retro)

The maintainer contributed new requirements to the invitation-only onboarding
design: an invitation should not immediately provision a guest, the recipient
may already be authenticated (and then only names a host handle) or must first
create a guest, and a guest may bond to one or more OAuth providers that the
database tracks. This is paraphrased here; the linked comment remains the source
for the untrusted verbatim text.

The request is forward design direction on a design PR, not criticism of a work
product a review should have caught. A design gauntlet did run on #56, but the
panel judges the design's internal quality, not whether it matches product
intentions the maintainer had not yet stated. Direct inspection confirms the
primary loop materially delivered against the directive (design commit 946f92b
adds the two acceptance paths and the OAuth-provider database modeling).
Dismissed as new direction; no cluster or improvement job was created.
