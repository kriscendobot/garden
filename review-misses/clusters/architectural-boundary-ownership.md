---
slug: architectural-boundary-ownership
category: spec-violation
status: closed
count: 1
members:
  - endojs-endo-but-for-bots-pr1018-review-eccc706c
prs: [1018]
improvement_job: review-improve-architectural-boundary-ownership
improved_by: 5ba8b6f06a: skills/ownership-map/SKILL.md (prevention artifact), roles/designer/AGENT.md (ownership-map requirement), scripts/jobs/gardening/ownership-map-signal.sh + panel.sh design-panel pre-pass + roles/jurors/decomplector/AGENT.md Ownership-map reconstruction (sensing); tests ownership-map-signal-test.sh, panel-ownership-map-trigger-test.sh
---



A design assigns execution, durability, or lifecycle responsibilities to the wrong architectural layer, while repeated panel reviews check local consistency without constructing an explicit ownership map across adjacent components.

**Threshold rationale:** # Dispatch rationale: architectural-boundary-ownership

Dispatch under the single-major standing-rule bypass. The cluster has one major
miss on PR #1018. The critic's standing brief already requires checking whether
a design composes with adjacent modules. The decomplector already checks whether
policy and mechanism are braided, and the novice already checks load-bearing
mental-model gaps. Those rules existed before all six design-panel rounds.

The member is not new maintainer direction. The earlier review had already made
snapshots, transcript recovery, and embargo part of the design. At the reviewed
head, the document itself exposed the mismatch: it put `CrankOutcome` at the
Ironhorse `Machine` seam while assigning durable transcript, release/discard,
restore, and replay behavior around that result. Six panels found nearby local
defects but did not reconstruct which layer owned each responsibility. The later
fix separated Ironhorse execution classification from Slot Machine crank policy
and renamed the result `ExecutionOutcome`.

Waiting for two more PRs would allow core architectural seams to reach
implementation with persistence and lifecycle policy assigned to the wrong
layer. Dispatch one builder job to add both authoring-time prevention and a
durable panel check, with the reviewed PR #1018 head as the re-litigation case
and a coherent multi-layer design as a negative control.
