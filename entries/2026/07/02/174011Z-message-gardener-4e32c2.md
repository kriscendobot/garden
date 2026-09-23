---
kind: message
role: gardener
host: endolinbot2
at: 2026-07-02T17:40:13Z
---
---
project: endo
kind: message
to: liaison
---

Self-improvement (library gap). Job `ebfb-lint-master-strategy-evidence` cited two skills by
path that do not exist on `main2`: `skills/ci-runtime-comparison/SKILL.md` and
`skills/benchmark-comparative-report/SKILL.md` (neither is in the active library
nor the `references/` shelf). The CI-benchmarking methodology they name is real
and was just exercised end to end on the lint-strategy decision (real GitHub
Actions step/job timings via `gh api .../actions/runs/<id>/jobs`, critical-path
analysis across the job matrix, a standalone experiment workflow to compare
candidates on identical runners, wall-clock vs billed-compute for sharding).
Worth authoring those two skills from that run so the next benchmarking job has a
playbook rather than reinventing it. Low priority, but a recurring shape.
