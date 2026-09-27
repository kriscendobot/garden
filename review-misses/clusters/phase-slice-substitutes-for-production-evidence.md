---
slug: phase-slice-substitutes-for-production-evidence
category: evaluator-gaming
status: closed
count: 1
members:
  - kriscendobot-minion.town-pr87-review-1456cb95
prs: [87]
improvement_job: review-improve-phase-slice-substitutes-for-production-evidence
improved_by: b9a0411e52f roles/builder/AGENT.md, roles/jurors/integrator/AGENT.md, skills/pr-formation/SKILL.md, skills/panel-hints/SKILL.md, scripts/jobs/gardening/phase-evidence-gate.sh, scripts/jobs/gardening/ensure-pr.sh, scripts/jobs/gardening/panel.sh, scripts/jobs/test/phase-evidence-*
---



A feature PR narrows an ordered production-validation design to a later wiring phase with fail-closed doubles, and review accepts unit-tested seams instead of enforcing prerequisite order and the design's production acceptance evidence.

**Threshold rationale:** The severity bypass applies even at count 1. The governing design on the reviewed
head already required ordered stop gates and said unit tests were not production
evidence, yet the producer and three panel rounds accepted a later fail-closed
wiring slice as the reviewable feature result. This is a standing-rule failure,
not a preference first introduced by the maintainer. Dispatch one improvement
that adds both producer prevention and a durable panel sensor, using PR 87 at
`b6280ed36d` as the re-litigation case.
