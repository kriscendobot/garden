---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-10T22:47:01Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - jobs/tada/endojs-endo-but-for-bots-pr675-review-afcfffe9.md
---

# Review-retrospective: endo-but-for-bots #675 review 4674906637 — dismissed (new direction)

Second loop of the review-retrospective double loop for the review that produced
primary job `endojs-endo-but-for-bots-pr675-review-afcfffe9` (that feedback loop is
unchanged and complete).

**Verdict: not-a-miss (new-direction).** kriskowal's empty-body CHANGES_REQUESTED
review on the DRAFT design PR #675 (`design: platform search pushdown`, docs-only)
carried five inline comments, each RESOLVING one of the five entries in the design's
own "Open Questions" section. Four confirm/adjust proposed defaults (grep whole-tree
scope, platform test fixtures, batchSize defaults pending a benchmark, glob overflow
default reversed to throw with opt-in truncation); the fifth is a genuinely new
architectural direction first stated in the review (pursue Rust parity for
isConservativeRegex via a spun-off RE2-style ReDoS-mitigating subset, potentially
`@endo/regexp`, with a designer dispatched to own it).

**Grounds:** A design's open questions are, by construction, decisions the design
routes to the maintainer; the review is the maintainer answering them. There was no
code panel to miss anything — #675 is a docs-only DRAFT design PR whose purpose is to
elicit exactly these decisions — and no juror seat, gate, or standing instruction
knows and failed to bind. Same class as the #631/#288/#604 design-PR dismissals. No
cluster minted, no improvement dispatched. Recorded durably at
`review-misses/dismissed/endojs-endo-but-for-bots-pr675-review-afcfffe9.md` so the
same review is never re-litigated.

Self-improvement: none — the discriminator applied cleanly against a settled
precedent (open-questions-answered design-PR dismissal); no friction to encode.
