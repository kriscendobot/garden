---
source: notes/polarity-and-negation.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The polarity discipline for rule-level type narrowing, and where inference and negation may exchange type information. Rule-level inference computes per-variable the meet of every slot's kind, read as occurrence typing over the rows that survive the positive premises. Two directions of flow are decided: **Direction 1 (settled, semantics-bearing)** — negated premises do not contribute to inference, because a negation constrains rejected rows while inference describes surviving rows, so `TypeEnv::infer` skips `Premise::Unless`; **Direction 2 (a judgment call, currently implemented)** — positive narrowing does not flow into negated subqueries, kept self-typed so a future checked-execution mode does not make an inert rewrite load-bearing. Plus settled points on `Absent` matching nothing in both polarities, `unless` over a `maybe` being rejected (`NegatedOptional`), and negation placement being structural.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [negated-premises-do-not-infer](../sections/dialog-db--notes-polarity-and-negation--negated-premises-do-not-infer.md) | datalog-query | current |
| [positive-narrowing-not-into-negation](../sections/dialog-db--notes-polarity-and-negation--positive-narrowing-not-into-negation.md) | datalog-query | current |
| [settled-points-absent-and-negated-optional](../sections/dialog-db--notes-polarity-and-negation--settled-points-absent-and-negated-optional.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `ebd8f739` (2026-07-01), authored by Irakli Gozalishvili. The rationale-and-uncertainty companion to the type-narrowing behavior summarized in `notes/guide.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-3` follow-on cycle (2026-07-06), part of the rules/scope cluster.
