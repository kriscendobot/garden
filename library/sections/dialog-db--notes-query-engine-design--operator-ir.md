---
title: The operator IR (Plan enum, Maybe, Coalesce)
source: notes/query-engine-design.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The planned `Conjunction` is a sequence of compiled `Plan` operators, not the syntactic AST. `Plan` is an enum — `Scan` (scalar attribute lookup), `Maybe` (the optional lookup: a left-join over a scalar lookup, realizing `maybe` concept fields), `Formula`, `Constraint`, `Concept`, `Negate` — each carrying the lowered query plus a small `Header` (cost / binds / env). `evaluate` dispatches on the variant; the AST is reconstructable from the payload (`Plan::as_premise`) for analysis but not stored separately, keeping execution off the AST and giving incremental-maintenance work a concrete structure to attach to. **Optionality contracts are schema-borne, not cost accidents:** `Maybe` hard-requires the entity slot ("absent for whom?") and set-widens its value/cause content types (so feasibility and inference need no special cases; narrowing demotes it to a plain `Scan` when a sibling proves the value present), and `Coalesce` declares its source a hard requirement so ordering correctness is guaranteed structurally.

The planned `Conjunction` is a sequence of compiled `Plan` operators, not the syntactic AST. `Plan` is an enum: `Scan` (scalar attribute lookup), `Maybe` (the optional lookup: a left-join over a scalar lookup, realizing `maybe` concept fields), `Formula`, `Constraint`, `Concept`, `Negate`, each carrying the lowered query plus a small `Header` (cost / binds / env). `evaluate` dispatches on the variant; the AST is reconstructable from the payload (`Plan::as_premise`) for analysis but is not stored separately. This keeps execution off the AST and gives later work (incremental maintenance) a concrete structure to attach to.

`Maybe` is also where the optionality contracts live structurally: its schema hard-requires the entity slot ("absent for whom?") and set-widens its value/cause content types, so feasibility and inference need no special cases; type narrowing demotes it to a plain `Scan` when a sibling premise proves the value present. `Coalesce` declares its source as a hard requirement for the same reason: ordering correctness is schema-borne, never a cost accident.

Source: [notes/query-engine-design.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/query-engine-design.md) at commit `ebd8f739`.
