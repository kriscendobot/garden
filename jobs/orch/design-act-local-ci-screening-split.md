---
child-design-act-local-ci-screening-research-reap-count: 0
order: serial
children: design-act-local-ci-screening-research design-act-local-ci-screening-doc
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-03T05:48:44Z
---

Deliberate overrun split of designer job `design-act-local-ci-screening` (one
2400s handler-wall overrun). Divisible: (1) research child establishes the
`act` feasibility facts + Linux-runnable workflow inventory and commits
`designs/act-local-ci-screening-findings.md`; (2) design child writes
`designs/act-local-ci-screening.md` from those findings. Serial, halt on
failure: the design depends on the research.
