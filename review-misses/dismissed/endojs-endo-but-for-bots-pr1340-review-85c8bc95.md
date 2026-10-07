---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1340-review-85c8bc95
verdict: not-a-miss
category: new-direction
pr: 1340
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1340:review:5371782104:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1340#pullrequestreview-5371782104
review_at: 2026-09-30T20:49:51Z
severity: minor
grounds: |
  Maintainer decisions on questions the design itself posed to the maintainer.
  PR #1340 is a draft design (designs/agent-confined-application-makers.md)
  whose "Open Questions" section asked four maintainer-facing questions: follow
  pnpm symlinked stores vs require hoisted layout, re-capture vs accept
  precompiled inputs, live tree reference vs capture, and whether guests should
  hold makers at all. Review 5371782104 (CHANGES_REQUESTED, kriskowal, body is a
  bare "rsvp" request) carries five inline comments anchored on exactly those
  four questions: it chooses hoisted layout for mounts (and asks for a follow-up
  design of a multi-root mount attenuation with a controller facet), keeps all
  archive/bundle options reachable with a stated stance against precompiled
  artifacts, keeps live tree references, lets guests make guests under shared
  metering, and suggests re-checking llm for progress on guests inviting guests.
  Choosing among explicitly posed alternatives is maintainer-owned direction; no
  seat brief, skill, or standing rule encodes these answers, so no panel could
  have anticipated them. No gauntlet had run before the review (the designer
  deferred it pending the maintainer's answers; viability ran after the review),
  but a panel cannot answer open questions addressed to the maintainer, so the
  missing panel did not cause this feedback. Calibration note (near-miss, not
  recorded as a miss): the fifth comment's pointer was grounded — guest-owned
  invitation/accept primitives (ebfb #1305, #1310) merged 2026-09-19/21, before
  the design was authored 2026-09-24 — so the design's open question 4 was framed
  without that landed adjacent work. The maintainer phrased it as a soft
  "consider" with no error asserted, and the primary resolved it by scoping guest
  invitation out. If later retros see designs overlooking already-landed related
  code, join the related-design-contract-cross-check or
  stale-related-design-direction family. Primary deliverable verified in the
  world: design commit f871ea6737 turned the four questions into decisions, the
  rsvp landed on llm (341d74cd0), all five inline comments got replies, PR merged,
  and the requested follow-up design-mount-root-attenuation-controller exists
  (completed, opened as ebfb PR #1402).
---

Dismissed: the review answered the design's own maintainer-facing open
questions (mount layout, precompiled inputs, live trees, guest makers). This is
direction, not a review-process miss.
