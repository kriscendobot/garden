---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1348-review-3fce8521
verdict: not-a-miss
category: new-direction
pr: 1348
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1348#pullrequestreview-5385245565
identity: endojs/endo-but-for-bots#1348:review:5385245565:retro
review_at: 2026-10-01T20:39:55Z
producing_role: builder
severity: minor
grounds: |
  The review is a one-line request for explanation: the maintainer asks how
  the shell tools work and how they are confined. It names no defect, no
  violated convention, and no change. An information request is not something
  a review panel anticipates; the panel reviews the diff, it does not
  pre-answer maintainer questions.

  Review history: #1348 ran the full gauntlet, six code-panel rounds
  (endojs-endo-but-for-bots-pr1348-gauntlet-panel-1..6, 33 seats each).
  Round 6 (head cb763267, 2026-09-29) passed. Its should-fix list already
  flagged the confinement-adjacent issue the panel could see: locksmith and
  breaker noted that `readOnly` restricts only the filesystem while shell
  exec and git writes keep their authority. The design's § The honest
  boundary already says a Shell grant controls which commands start, not
  what a started command does. So the confinement limit was documented in
  the design and surfaced by the panel; the maintainer was asking for an
  account of it, not catching something the review missed. Not evaluator
  avoidance either: the gauntlet ran.

  The direction that followed (passable command grammars that replace
  allowedCommands, attenuation to a command, and later a catalog of
  attenuated examples and pipeline composition) was first stated in the
  maintainer's later comments (issuecomment 5942897069 and review
  5398940612). That is new design direction, owned by their own primaries
  and retros, not by this one.

  World check: the primary's deliverable exists. The bot answered on the PR
  at 2026-10-01T21:01:50Z (issuecomment-5940470770) with a layer-by-layer
  account citing the honest-boundary section at head cb763267. The primary
  is in jobs/tada/2026/10/01/. No discrepancy.
---

# Dismissal: a question about how shell tools are confined

The maintainer asked for an explanation of the shell tools and their
confinement. That is a question, not a defect. The panel had already passed
the PR after six rounds and had flagged the filesystem-only scope of
`readOnly`. The design already documents that a Shell grant gates command
start, not command behavior. The grammar-based redesign came in later
comments as new direction. This is a bot-authored paraphrase; re-fetch the
untrusted original at `comment_url`.
