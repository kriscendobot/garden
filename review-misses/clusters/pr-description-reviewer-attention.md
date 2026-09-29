---
slug: pr-description-reviewer-attention
category: docs-drift
status: closed
count: 3
members:
  - kriscendobot-agoric-sdk-pr16-a45a180a
  - kriscendobot-agoric-sdk-pr16-review-416988d1
  - endojs-endo-but-for-bots-pr1281-b2a4cb13
prs: [16, 1281]
improvement_job: review-improve-pr-description-reviewer-attention
improved_by: 8ebbdb344a0: scripts/jobs/gardening/pr-body-template-check.sh (ensure-pr.sh refusal + panel.sh pre-pass binding must-fix), skills/panel-hints/probes/C-pruner-pr-body.sh, pr-formation/pr-review-thread-replies concision rules, integrator/pruner/fixer brief lines; test scripts/jobs/test/pr-body-template-check-test.sh
---





A garden-authored PR description carries more prose than the reviewer needs (per-package change lists, contrast paragraphs, an inline verification breakdown) so the maintainer asks it be cut for concision / reviewer attention; the pr-formation skill governs *authoring* the body but no gauntlet stage or juror seat *reviews* the produced body against it, so an over-long description reaches the maintainer unpruned.

**Threshold rationale:** Floor met at the #1281 miss: 3 members across 2 distinct PRs (agoric-sdk#16, endo-but-for-bots#1281). Dispatching rather than holding: the members are not coincidental (all are garden-authored PR prose violating its authoring skill with no review stage checking the produced artifact), no fix is in flight, and the template half is mechanizable as a deterministic gate at ensure-pr.sh and at the panel stage — the #1281 miss shows a seat-brief line alone did not bind across six rounds.
