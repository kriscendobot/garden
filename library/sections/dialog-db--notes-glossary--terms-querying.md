---
title: Glossary — querying (Datalog, terms, predicates, planner)
source: notes/glossary.md
source_repo: dialog-db/dialog-db
source_commit: 054a7982ae47c06693c5ce6372a0844d1549a8d1
source_date: 2025-07-08
source_authors: [Argonaut Nautilus, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The glossary's Querying terms, consolidated for grep. **Datalog** is DialogDB's declarative query language, well-suited to graph-structured facts (traversals and pattern matching via logical rules, no explicit joins). **Variable** — a `?`-prefixed query placeholder bound during evaluation. **Term** — a concrete scalar or a variable. **Selector** — the simplest query, a pattern over `the`/`of`/`is`. **Predicate** — a formula application, rule application, or negation. **Formula** — a computational predicate deriving outputs from inputs. **Negation** — matches when a pattern is absent ("people without email"). **Query Planner** — reorders conjuncts to minimize search space (most-selective-first) and detect cycles.

Consolidated glossary entries (Querying), anchors preserved inline for lookup.

- **Datalog:** the declarative query language used by DialogDB, well-suited for graph-structured facts — expressing complex graph traversals and pattern matching through logical rules, querying interconnected data without explicit joins.
- **Variable:** a query placeholder bound to values during evaluation, denoted with a `?` prefix (`?person`, `?name`); an unknown the engine fills by pattern matching against facts.
- **Term:** either a concrete scalar value or a variable. Concrete terms match exact values; variable terms match any value and bind it for use elsewhere.
- **Selector:** the simplest query — a pattern over the `the`, `of`, and/or `is` components, matching facts directly without complex logic.
- **Predicate:** a query component that is a formula application, rule application, or negation; extends basic pattern matching with computational logic.
- **Formula:** a computational predicate deriving output values from inputs (string manipulation, arithmetic, transformation).
- **Negation:** a constraint matching when a pattern is NOT present ("find all people without email addresses").
- **Query Planner:** reorders query conjuncts to minimize search space and detect cycles — choosing the most selective patterns first and identifying infinite loops.

Source: [notes/glossary.md](https://github.com/dialog-db/dialog-db/blob/054a7982ae47c06693c5ce6372a0844d1549a8d1/notes/glossary.md) at commit `054a7982`.
