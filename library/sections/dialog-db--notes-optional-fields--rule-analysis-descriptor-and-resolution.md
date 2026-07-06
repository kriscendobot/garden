---
title: Rule analysis, the descriptor layer, and the Resolution policy
source: notes/optional-fields.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The inference pipeline's three layers, as proposed versus shipped. **Rule analysis**: the proposed `RuleAnalysis { types, producers, refinements }` shipped as `rule::analyzer::AnalyzedRule` carrying `types: Arc<TypeEnv>` (shared across analyzed premises) plus a `DependencyGraph` (per-premise `binds`/`needs` with precomputed `requires[]` edges) instead of the `producers`/`refinements` maps — broader, but currently built and not yet consumed by the planner; range-predicate scan hints (`refinements`) are deferred with the predicates. The entry point `RuleAnalysis::build` shipped as `analyze(conclusion, &steps) -> Result<AnalyzedRule, AnalysisError>` with matching phases (inference → required-head check → Coalesce-contract validation), minus the formula-scheme instantiation step (schemes don't ship). **Descriptor layer**: `TypeDescriptor::kind` shipped returning `Option<Type>` (`None` = "no static info, leave to the unifier"), with `OptionalOf<D>` as described. **Attribute-query `Resolution` policy**: `Resolution { Required, Optional }` shipped, but *derived* from `self.is.is_optional()` rather than stored — `AttributeQueryAll::resolution()` returns `Optional` iff the `is` term's kind admits `Nothing`, so once the planner narrows the term's kind the resolution flips with it automatically. **Macro layer**: `#[derive(Concept)]` emits `Term<Option<T::Type>>` for `Option<T>` fields, dispatching through `ConceptField` with blanket impls for `N` and `Option<N>` via `Option`'s `#[fundamental]` annotation — no syntactic detection of the `Option` ident.

## Rule analysis

```rust
pub struct RuleAnalysis {
    types: HashMap<String, Type>,
    producers: HashMap<String, Vec<ProducerEntry>>,
    refinements: HashMap<String, ScanHint>,
}
```

✅ **Shipped as** `rule::analyzer::AnalyzedRule` with `types: Arc<TypeEnv>` plus a `DependencyGraph` instead of `producers`/`refinements`. The shipped form:

- Carries the inferred environment via `Arc<TypeEnv>` (shared across the analyzed premises).
- Builds a `DependencyGraph` (per-premise `binds`/`needs` plus precomputed `requires[]` edges): broader than the proposed `producers` map. Currently built but not yet consumed by the planner (left for a follow-up).
- Doesn't carry `refinements`: range-predicate scan hints are deferred along with the predicates themselves.

`RuleAnalysis::build(conclusion, premises) -> Result<Self, TypeError>` ✅ **shipped as** `rule::analyzer::analyze(conclusion, &steps) -> Result<AnalyzedRule, AnalysisError>`. The phases match the doc: inference, then required-head check, then Coalesce contract validation. The formula-scheme-instantiation step isn't done because schemes don't ship. The Slice-7 checks ship via `AnalysisError::RequiredHeadFromOptional` and the unifier's constraint-conflict errors.

## Descriptor layer

```rust
pub trait TypeDescriptor: ... {
    const KIND: Option<Type>;
    fn kind(&self) -> Type;
}
```

✅ **Shipped.** `TypeDescriptor::kind` returns `Option<Type>` (slightly different signature than `Type`: `None` means "no static info, leave to the unifier"). `OptionalOf<D>` ships as described.

## Attribute query layer: `Resolution` policy

```rust
pub enum Resolution { Required, Optional }
```

✅ **Shipped.** With one refinement: `Resolution` is *derived* from `self.is.is_optional()` rather than stored as a field. The shipped `AttributeQueryAll::resolution()` returns `Resolution::Optional` iff the `is` term's kind admits `Nothing`. This makes the rule-level narrowing automatic: once the planner narrows the term's kind, the resolution flips with it, without needing a separate path.

## Macro layer

✅ **Shipped.** The `#[derive(Concept)]` macro emits `Term<Option<<T as Attribute>::Type>>` for `Option<T>` fields. Dispatch happens through the `ConceptField` trait with two blanket impls (`for N` and `for Option<N>`) leveraging `Option`'s `#[fundamental]` annotation: no syntactic detection of the `Option` ident.

Source: [notes/optional-fields.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/notes/optional-fields.md) at commit `ebd8f739`.
