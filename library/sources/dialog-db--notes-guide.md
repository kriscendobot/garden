---
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 8
status: current
---

> Abstract: "Optionality in the query engine" — the longform, user-facing companion to the `notes/optional-fields.md` design contract, written around one running example (Alice has a nickname, Bob does not) to explain how optional values work in `dialog-query`: what `Absent` means, where it appears, how the planner and type inference treat it, and why the design is layered the way it is. The through-line: **`Absent` is a positive claim about the store, not a null hole** — produced by exactly one construct (the optional lookup behind a concept's optional field, `OptionalAttributeQuery`), never persisted, and always relative to a bound entity ("absent for whom?"). The engine has two layers: the **associative** layer is scalar (`the(of, is)`, a fact matches or is filtered), and all optionality lives in the **semantic** layer as an optional lookup (a left join). From that root the guide derives the whole surface — a concept must have at least one required attribute; consuming an optional value filters by default (occurrence typing narrows the variable; the planner demotes the lookup to a scalar scan when a sibling proves presence) unless `Coalesce`/`unwrap_or` supplies an explicit default; rule heads are contracts (`RequiredHeadFromOptional`); you cannot negate an optional field (`NegatedOptional`) and negation does not narrow types; errors surface only as compile-time type meets, never at evaluation where mismatch is membership-filtering (dialog *filters* where PostgreSQL *errors* and SQLite *coerces*); and open-world inference is sound and inspectable (`TypeEnv::explain`/`narrowings`/`dead_optionality`) without any required annotation. Closes with three payoffs of the layering (one place to be correct, types that tell the truth, a future incremental-subscription hook) and the deeper principle **absence is a claim about a completely examined range**. Pairs with `notes/optional-fields.md` (the design contract), `notes/scalar-associative-layer.md` (where set-widening now lives), `notes/polarity-and-negation.md` (the negation finer points), and the `optional-attribute-query` / `set-widening-type-system` / `claim-projection` concept pages.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [running-example-and-two-layers](../sections/dialog-db--notes-guide--running-example-and-two-layers.md) | datalog-query | current |
| [absent-is-a-claim](../sections/dialog-db--notes-guide--absent-is-a-claim.md) | datalog-query | current |
| [consuming-optional-values-filter-by-default](../sections/dialog-db--notes-guide--consuming-optional-values-filter-by-default.md) | datalog-query | current |
| [producing-values-heads-are-contracts](../sections/dialog-db--notes-guide--producing-values-heads-are-contracts.md) | datalog-query | current |
| [negation-and-absence](../sections/dialog-db--notes-guide--negation-and-absence.md) | datalog-query | current |
| [where-errors-surface](../sections/dialog-db--notes-guide--where-errors-surface.md) | datalog-query | current |
| [inference-in-an-open-world](../sections/dialog-db--notes-guide--inference-in-an-open-world.md) | datalog-query | current |
| [why-it-is-layered-this-way](../sections/dialog-db--notes-guide--why-it-is-layered-this-way.md) | datalog-query | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `3cd6607a` (2026-07-01), authored by Irakli Gozalishvili.
- The user-facing companion to `notes/optional-fields.md` (the design contract, ingested in the `scholar-ingest-dialog-db-remainder-5` cycle). Where that note preserves the pre-implementation contract against what shipped, this guide teaches the shipped semantics through one running example. Pairs with `notes/scalar-associative-layer.md` (where set-widening was moved on `feat/operator-ir`), `notes/polarity-and-negation.md` (the negation finer points this guide defers to), and the `optional-attribute-query`, `set-widening-type-system`, and `claim-projection` concept pages.
- Ingested in the `scholar-ingest-dialog-db-remainder-7` follow-on cycle (2026-07-06).
