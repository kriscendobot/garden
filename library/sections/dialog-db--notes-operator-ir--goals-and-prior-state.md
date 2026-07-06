---
title: The operator-IR chapter — three goals and what was wrong before
source: notes/operator-ir.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The `feat/operator-ir` chapter set three properties the engine lacked at its start. (1) **Execution runs on a compiled form, not the AST** — a `Plan` operator IR gives later work (demand reification, incremental maintenance, cost redesign) a concrete structure to attach to instead of re-walking syntax. (2) **A rule that exists is valid** — analysis is the constructor: type inference, safety checks, and dependency structure all run before a rule can be obtained, so every downstream consumer holds a rule plannable by construction, and the analysis artifacts (the SIPS) are retained as data for the demand-driven incremental work. (3) **Optionality is structural** — the correctness of optional (`maybe`) fields must not depend on plan order, field names, or runtime guard interactions. The prior state failed all three: evaluation walked the syntactic AST; rule construction ran plan-then-analyze and discarded the dependency graph; a rule stored one pre-baked `Conjunction` forcing an `as_premise` round-trip on every replan; feasibility was fused into cost (`estimate -> Option<usize>`); and optionality was a term-kind property interpreted by four cooperating runtime guards whose meaning held only under plan orders they anticipated (the #348 family — an optional field sorting first leads the scan and silently drops entities).

Three properties the engine should have, none of which it had at the chapter's start:

1. **Execution runs on a compiled form, not the AST.** A `Plan` operator IR gives later work (demand reification, incremental maintenance, cost redesign) a concrete structure to attach to, instead of re-walking syntax.
2. **A rule that exists is valid.** Analysis is the constructor: type inference, the safety checks, and the dependency structure all run before a rule can be obtained, so every downstream consumer holds a rule that is *plannable by construction*. The analysis artifacts (the SIPS) are retained as data, because the demand-driven incremental work consumes them.
3. **Optionality is structural.** The correctness of optional (`maybe`) fields must not depend on plan order, field names, or runtime guard interactions; the contracts live in the shape of the constructs themselves.

## Prior state, and what was wrong with it

- Evaluation walked the syntactic AST: `Premise`/`Proposition` carried `evaluate`, so there was no compiled artifact between "parsed rule" and "running stream".
- Rule construction ran **plan-then-analyze**: the dependency graph was computed *from the already ordered steps* and then discarded. Analysis could validate but produced nothing anyone consumed; the SIPS the magic-sets literature builds everything on existed only transiently.
- A rule stored one pre-baked `Conjunction`. Plans are scope-specific, so replanning had to reconstruct premises from the stored plan (an `as_premise` round-trip) and re-run everything, including type inference, on every replan and every concept adornment.
- Feasibility was fused into cost (`estimate(env) -> Option<usize>`): a premise that could not run was merely "costless", with no account of *why* or of what would unblock it — exactly the information demand reification needs.
- Optionality was a property of a term's *kind*, interpreted by scans through four cooperating runtime guards in two files. The meaning of "optional" was therefore only correct under plan orders the guards anticipated; the #348 family (an optional field that sorts first leads the scan and silently drops entities) was the observable symptom.

Source: [notes/operator-ir.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/operator-ir.md) at commit `f777fe7c`.
