---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1125-review-b58d5a3f
verdict: not-a-miss
category: new-direction
pr: 1125
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1125:review:5214461125:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5214461125
review_at: 2026-09-15T18:54:42Z
severity: minor
grounds: |
  Not a review-miss: kriskowal's CHANGES_REQUESTED review 5214461125 on PR #1125
  (guest-owned invitation / agent-options primitive) is two maintainer DESIGN
  DIRECTIVES on his own project, each first stated in the review, not a bug,
  spec violation, missed edge, or breached convention the panel demonstrably
  knew. Enumerated from the world (the review body was the bare "@kriscendobot"
  mention; substance is two inline comments, both paraphrased from untrusted
  text):

  (1) Inline host.js:85 (comment 4019101570) — the host/guest options asymmetry
  is "not an intentional asymmetry"; hosts and guests should both carry host and
  guest pins, networks, introduced names, and introduced special names; and "it
  may be possible to fully converge the guest and host options into a single
  MakeAgentOptions" with parallel nets/guests implementations and host<->guest
  parity-parameterized tests. This is forward architectural convergence intent,
  not an accidental forgotten-sibling regression: the PR did NOT drop host
  options — its diff renames MakeHostOrGuestOptions -> MakeAgentOptions and adds
  the pins/networks options to BOTH provideHost and provideGuest. The maintainer
  is asking for MORE convergence (full option parity across introduced/special
  names, one unified type, parity tests) than the PR delivered, phrased as an
  aspiration ("may be possible to fully converge"). It also continues the SAME
  evolving pins/networks/options design thread the prior sibling retro on this
  PR dismissed as new-direction (review 5185263180, dismissed 4e1469ed: add a
  `pins` option, `nets` policies). No seat brief, skill, or COMMON norm encodes
  "host and guest agent-options must have parity," so there is nothing the
  gauntlet/panel could have anticipated. Not incomplete-sibling-transformation
  (no accidental one-sided change) and not evaluator-gaming (the gauntlet ran —
  panel-1..6 in tada — and the asks are design refinements, not a moved
  measurement).

  (2) Inline mail.js:138 (comment 4019140456) — stop relying on `listIdentifiers`
  in reincarnateMailboxPins "in anticipation of removal of that method"; guests
  must not see identifiers/locators (cryptographic info an AI agent could
  exfiltrate) though hosts may; obtain the values by pet-name lookup instead,
  done as a transaction so directory contents cannot shift between listing keys
  and resolving values; and, "in the fullness of time," move toward sturdy refs.
  This is maintainer roadmap knowledge and forward design guidance: the
  listIdentifiers deprecation and the sturdy-ref direction are project-owner
  plans encoded in no seat brief or skill, and the primary itself notes the full
  sturdy-ref redesign is explicitly future work. The framing is anticipatory
  ("going forward," "in the fullness of time"), steering the enumeration approach
  toward the roadmap rather than red-flagging a live guest-exfiltration
  vulnerability in the shipped path (reincarnateMailboxPins runs in daemon-core,
  not as a capability the guest holds). The transaction/TOCTOU note refines the
  newly-requested pet-name approach; it is not a defect in the existing code the
  panel let through. It resembles the capability-hardening-attenuation cluster
  only superficially: that cluster is exported exo/client capabilities reaching
  review structurally unhardened (interface guards, runtime-flag attenuation,
  ambient authority), a different shape from forward guidance to stop using a
  to-be-removed enumeration method.

  Both asks are the owner's evolving architecture for guest/host agent options
  and pin enumeration, phrased as convergence goals and roadmap direction. Mints
  no cluster.

  Grounded in the world, not the primary's claims: the primary did NOT close as a
  hollow no-op — its routing deliverable genuinely EXISTS and completed. The
  successor fixer job endojs-endo-but-for-bots-pr1125-fix-agent-option-parity-20260915
  is in jobs/tada/ and reports both asks implemented (unified host/guest agent
  options with parity for pins, networks, introduced names, and special names,
  plus parameterized tests; listIdentifiers replaced with atomic pet-name-based
  listValues preserving best-effort reincarnation), at head 97891bb30f, with
  root+daemon tsc, eslint, prettier, targeted regressions and the full 259-test
  daemon suite green (CI run 35012567060), inline replies on both threads, and a
  re-request-review to kriskowal. So there is no false-resolution / hollow-no-op
  discrepancy to report; the directive was addressed for real.
---

Retrospective on endojs/endo-but-for-bots PR #1125 review 5214461125 (kriskowal,
CHANGES_REQUESTED). Dismissed as not-a-miss / new-direction: two maintainer
design directives on his own project — converge the host/guest options into a
single MakeAgentOptions with full pins/networks/introduced-name parity and
parity tests (the PR already added the options to both host and guest; the ask is
for more convergence than shipped), and stop using the to-be-removed
`listIdentifiers` in the mailbox pin-reincarnation path in favour of a
transactional pet-name lookup, keeping identifiers/locators off guests and moving
toward sturdy refs. Both are evolving architecture and roadmap direction first
stated in the review, encoded by no standing rule, seat, or skill; the second
inline comment continues the same design thread the prior sibling retro (4e1469ed)
dismissed. The primary's successor fix job (fix-agent-option-parity-20260915) was
verified to exist and to have implemented both asks with green CI (259 tests), so
there is no false-resolution discrepancy.
