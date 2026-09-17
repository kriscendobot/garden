---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-b9fa19b7
verdict: not-a-miss
category: new-direction
review_at: 2026-08-31T05:10:37Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5474013110
identity: endojs/endo-but-for-bots#1059:comment:5474013110
---

The maintainer's iterative expert review found that the checkpoint rejection logic
covered several named holders but did not reject every reachable serialized slot
that referred to a runtime-native function restore could not rebuild. The reported
examples involved a direct retained callback and a callback retained through a
bound argument; the requested remedy was an exhaustive walk of persisted
slot-bearing state plus focused regressions. This is a paraphrase of the untrusted
comment; the linked comment remains the verbatim source.

**Grounds for not-a-miss.** This is another round in the same maintainer-driven
Ironhorse snapshot-store arc already calibrated by the dismissed retrospectives
for comments 5452184664 and 5486686006, and the independently fetched review
history supports the same disposition:

1. No gauntlet or panel reviewed PR #1059. The board contains direct review,
   fixer, rebase, and shepherd work, but no panel/gauntlet job for this PR. The
   direct garden review immediately before this comment found and verified a
   different boot-native callability defect; it was an ad hoc domain review, not
   evidence that a standing juror or gate owned exhaustive Rust snapshot graph
   traversal. No existing seat brief, skill, or deterministic review gate covers
   the Ironhorse VM's persisted holder inventory.
2. The exhaustive all-slot traversal requirement was first made concrete in this
   feedback. Earlier review rounds had established the broad fail-closed goal and
   fixed named holder classes, but neither the garden's review machinery nor a
   standing producer instruction specified the complete set of raw and value-slot
   carriers that this round enumerated. The maintainer was acting as the engaged
   domain evaluator and refining that implementation requirement.
3. Nothing routed around or altered an evaluator. The sequence is iterative expert
   review finding progressively narrower completeness gaps in a large, hand-written
   Rust persistence boundary, not evaluator gaming.

The issue is a serious product defect, but severity alone does not make it a miss
by a review surface that did not own this subsystem. Recording it as new direction
preserves the established jurisdiction boundary instead of inventing a general
panel obligation from one domain-specific review round.

**World check.** The directive's deliverable exists independently of the primary
report. GitHub shows commits `866592cda6b2`, `d8b771bf60bb`, and `58317ed07bfe`
on the merged PR: they add exhaustive persisted-state traversal, close the proxy
raw-index gaps, and add the direct-reference, bound-argument, wider-holder, and
resume-oracle regressions. The final merged tree contains
`rust/engine/ironhorse-snapshot/tests/persist_gates.rs`, and the correlated
completion comment records the focused suite passing 13 tests. No discrepancy was
found.
