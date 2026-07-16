---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr676-b3edafc8
verdict: not-a-miss
category: new-direction
pr: 676
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/676#issuecomment-4982086674
identity: endojs/endo-but-for-bots#676:comment:4982086674:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr676-b3edafc8
missed_by: none
severity: minor
grounds: >
  PR #676 is itself a design-stage draft (it adds
  designs/conservative-regexp-subset.md and changes no application code). The
  maintainer's comment redirects the design toward an external specification —
  RFC 9485 (the I-Regexp safe subset) and Endo issue #3079 — and states an
  architectural preference: a full parse of the regex to verify safe-subset
  membership, delegation to the underlying JS regex engine, that JS
  implementation as the ground truth for tests held constant against a future
  native Rust engine, and a ponyfill package whose JS implementation can be
  omitted from the import graph under a condition like `-C endor`. These are
  first-stated design requirements and directional taste on which spec to align
  to, not a defect any review surface could have anticipated. A design draft PR
  exists precisely to elicit exactly this kind of steering; that the maintainer
  supplied a target spec and a package shape is the design loop working. No seat
  brief, skill, or COMMON.md norm names RFC 9485 / I-Regexp or prescribes a
  ponyfill `-C endor` structure, so nothing standing failed to bind. The primary
  job correctly routed this to fresh design work (design-rfc9485), which pivoted
  #676's design accordingly — confirming this was a new direction to adopt, not an
  error to correct.
---

# Dismissal: design pivot to RFC 9485 / Endo #3079 on #676

The maintainer asked the design on #676 to pivot to a specific external design
direction (an Endo issue and an RFC-defined safe regex subset) and expressed a
preferred implementation architecture (parse-and-validate, engine delegation, a
shared held-constant test corpus, and a ponyfill omittable under a build
condition). The primary job routed this to a new designer job that amended the
existing design branch. This record holds only a paraphrase; the verbatim comment
remains at `comment_url`.

## Grounds

The review history shows #676 is a design-stage draft that adds a single design
document and touches no code. The comment names a target specification (RFC 9485 /
I-Regexp) and a desired package structure that appear nowhere in the garden's seat
briefs, skills, or standing norms. Nobody in a code panel or gauntlet could have
anticipated the maintainer's choice of external spec or preferred ponyfill /
`-C endor` shape — these are first-stated requirements and architectural taste on
a draft whose purpose is to gather exactly this steering. The design loop responded
by pivoting the design, not by fixing a defect. This is new direction, not a review
surface failing to enforce an existing check.

Self-improvement: nothing this time.
