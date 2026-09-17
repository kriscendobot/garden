---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1125-review-4e1469ed
verdict: not-a-miss
category: new-direction
pr: 1125
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1125:review:5185263180:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#pullrequestreview-5185263180
review_at: 2026-09-12T05:00:46Z
severity: minor
grounds: |
  Not a review-miss: kriskowal's CHANGES_REQUESTED review 5185263180 on PR #1125
  (guest invitation / pins-retention primitive) is three maintainer DESIGN
  DIRECTIVES on his own project, each first stated in the review, not a bug,
  spec violation, missed edge, or breached convention the panel demonstrably
  knew. Enumerated from the world (review body + the two inline comments,
  paraphrased from untrusted text):

  (1) Body ask — "reincarnate both host and guest pins after receiving a message
  and before dispatching the message-received notification." The PR had
  DELIBERATELY DEFERRED incarnation-on-delivery to follow-up #1227; the
  maintainer is pulling that deferred behavior into this PR's scope. A stated,
  openly-documented scoping boundary that the project owner later chose to move
  forward is scope negotiation, not a shipped-code bug the gauntlet let through.
  Not evaluator-gaming either: the deferral dodged no evaluator (it was an
  announced design boundary, not tests hidden behind an unlanded dep).

  (2) Inline guest.js — rename the pins dirs to `guestPins` / `hostPins` and add
  a `pins` directory OPTION to `makeGuest` so a parent can elect retention
  without the formula inspector. The rename encodes the maintainer's preferred
  capability-boundary naming (guest-visible/mutable vs host-only); `heldPins`
  was not contradicting its type or violating a standing naming rule — no seat
  brief or rename-discipline line binds "held" as wrong. The new `pins` option
  is fresh API surface he is requesting.

  (3) Inline manager.js — add a `nets` option (or a read-only view) to
  `makeGuest` supporting four network-attenuation policies A–D. This is a net-new
  capability API with a policy taxonomy authored in the comment itself; nobody on
  the panel could anticipate this specific shape.

  All three are the owner's evolving architecture for guest network/pin
  attenuation, phrased as "let's instead…" / "I am looking for a change that…".
  No standing rule, seat, skill, or COMMON norm encodes any of them, so there is
  nothing the review process could have caught. Mints no cluster.

  Grounded in the world, not the primary's claims: the primary's routing
  deliverable genuinely EXISTS and completed — the successor fix job
  endojs-endo-but-for-bots-pr1125-fix-pins-nets-mailbox-20260912 is in
  jobs/tada/ and reports all three asks implemented (mailbox reincarnation before
  notify at head 99ebbbe1e; guestPins/hostPins rename + `pins` option; `nets`
  option with policies A–D via a new read-only-directory formula), gates and CI
  green (244 ava tests), with inline thread replies and a re-review request to
  kriskowal. So there is no false-resolution / hollow-no-op discrepancy to
  report; the directive was addressed for real.
---

Retrospective on endojs/endo-but-for-bots PR #1125 review 5185263180
(kriskowal, CHANGES_REQUESTED). Dismissed as not-a-miss / new-direction: three
maintainer design directives on his own project — pull the #1227-deferred
mailbox pin-reincarnation into scope; rename to guestPins/hostPins and add a
`pins` option to makeGuest; add a `nets` option with attenuation policies A–D —
each first stated in the review and encoded by no standing rule, seat, or skill.
The primary's successor fix job (fix-pins-nets-mailbox-20260912) was verified to
exist and to have implemented all three with green CI, so there is no
false-resolution discrepancy.
