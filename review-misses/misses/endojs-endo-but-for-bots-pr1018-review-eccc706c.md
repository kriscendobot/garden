---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1018-review-eccc706c
verdict: miss
category: spec-violation
pr: 1018
cluster: architectural-boundary-ownership
cluster_pattern: A design assigns execution, durability, or lifecycle responsibilities to the wrong architectural layer, while repeated panel reviews check local consistency without constructing an explicit ownership map across adjacent components.
review_at: 2026-08-31T18:05:01Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1018#pullrequestreview-5069628663
identity: endojs/endo-but-for-bots#1018:review:5069628663:retro
producing_role: designer
producing_job: design-ironhorse-panic
missed_by: critic composition check, decomplector concern-separation check, and novice architectural clarity check across six design-panel rounds
severity: major
grounds: |
  This was a review-process miss rather than architectural direction first
  introduced by the maintainer. The first maintainer review had already made
  the worker transcript, snapshot recovery, and message embargo part of the
  design before the gauntlet began. The head reviewed after panel round 6 still
  put a CrankOutcome constructor at the Ironhorse Machine seam and described
  Endor workers as owning transcript state, while supervisor-side prose handled
  durable release, discard, restore, and replay. The design therefore exposed
  enough evidence to derive the component boundary without predicting a new
  feature or preference.

  Six design-panel rounds reviewed successive versions before this review. The
  panel caught nearby symptoms, including contradictory MeterAbort embargo
  treatment, unclear CrankOutcome semantics, and vat/worker vocabulary, but no
  seat assembled the ownership map that would have shown the engine layer
  classifying execution termination while Slot Machine owns snapshots,
  transcript durability, embargo, and crank commit policy. The critic's
  standing brief explicitly requires checking composition with adjacent modules.
  The decomplector must detect policy braided with mechanism, and the novice
  must catch a load-bearing mental-model break. Those rules existed and did not
  bind.

  Severity is major because the ambiguity sat at the design's central execution
  and durability seam after six panel/fix rounds. Implementing that seam as
  written could have placed persistence and crank policy in the engine layer.
  The later correction made the ownership boundary explicit and renamed the
  engine result from CrankOutcome to ExecutionOutcome, confirming this was a
  substantive architectural correction rather than prose taste. PR 1018 is
  merged with that deliverable present, but the primary review job remains
  parked as doomed instead of recording its real resolution.
---

The maintainer required the design to separate engine termination
classification from Slot Machine's snapshot, transcript, embargo, and crank
policy. The merged design now states that boundary and names the engine-side
result for execution rather than for a crank. This record is a bot-authored
paraphrase; re-fetch `comment_url` for the untrusted review text.

## Threshold call

Dispatch under the single-major standing-rule bypass. The critic's adjacent-
module composition check, the decomplector's concern-separation check, and the
novice's architectural mental-model check all existed before six design-panel
rounds but did not bind. The improvement must make component ownership explicit
while authoring designs and require the panel to reconstruct and challenge that
ownership before approval.

Self-improvement: nothing this time.
