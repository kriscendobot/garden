---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr56-review-5867a29b
verdict: not-a-miss
category: new-direction
pr: 56
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/56#pullrequestreview-5083234893
identity: kriscendobot/minion.town#56:review:5083234893:retro
producing_role: designer
producing_job: unknown
missed_by: none-design-direction
severity: minor
review_at: 2026-09-01T21:22:59Z
grounds: >
  PR #56 is a design PR ("Design: invitation-only guest onboarding, superseding
  open self-signup"). Review 5083234893 (COMMENTED, kriskowal) carries a one-line
  body flagging substantial refinement and one inline comment on
  designs/invitation-only-guest-onboarding.md. Paraphrased, the inline comment
  re-architects the authentication model: names are user-assigned on each side of
  an invitation (host names guest on invite, guest names host on accept); the
  invitation is a minion.town URL whose formula identifiers ride in the fragment
  and are presented over CapTP, not HTTP GET; OAuth becomes entirely optional,
  with possession of the guest formula identifier sufficient to authenticate for
  now (formula rotation and an Ed25519 handshake later); OAuth is repurposed as an
  account-recovery bond that restores the guest identifier into local storage; and
  the history API rewrites the URL fragment to carry the guest identifier so it
  can be moved out-of-band. Every element is first-stated product/architecture
  direction from the maintainer - a design fork on the credential model, not a
  defect, spec violation, missed edge case, or convention that any seat brief,
  skill, or standing instruction already binds. No design-panel seat is charged
  with preferring bearer-capability authentication over OAuth or with choosing a
  recovery model; a design panel judges internal quality, not whether the design
  pre-picks the maintainer's not-yet-stated architecture. Not evaluator-gaming:
  #56 ran a full design gauntlet (clean, panel 1-4, fix 1-3, undraft, conduct in
  journal/jobs/tada/), so no evaluator was skipped. This is consistent with the
  four sibling #56 retros (ebea2826, review-7d4dc95d, review-7fde9428,
  review-6f509bbb), all dismissed as new direction. Grounded in the world, not the
  primary report: PR #56 is merged, and the design on minion.town main now states
  OAuth is an optional recovery bond (§ 5), the formula identifier is the guest
  credential with rotation and Ed25519 deferred, user-assigned pet names flow
  through invite(inviterPetName)/accept(locator, inviteePetName), and
  history.replaceState normalizes the guest fragment - the directive's
  deliverable exists. No cluster or improvement job is warranted.
---

# Dismissal: minion.town #56 review 5083234893 (retro)

New direction: the maintainer re-architected guest authentication (formula-id
bearer credential, OAuth demoted to optional recovery, history-API fragment
carry, user-assigned names). First stated in this review; adopted in the merged
design.
