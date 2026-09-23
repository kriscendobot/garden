---
title: The query model and the incremental-vs-initial exploration
source: notes/dbsp.md
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
---

> Abstract: The DBSP note's query-model half and its worked exploration. Dialog queries are typed TypeScript structures: a `Term<T>` is a scalar or a `Variable<T>` (`{"?": string}`); a `Select` matches a `{the, of, is}` triple; `Conjunct = Constraint | Negation`, `Constraint = Select | Predicate`; a `DeductiveRule` has a `claim` head mapping conclusion keys to terms and a `when` of `Disjuncts` (named `Conjuncts` arrays); `RuleApplication`, `FormulaApplication` (a `Formula.derive(input) => output`), and `Predicate` compose these; a top-level `Query` is a `RuleApplication`. The exploration validates whether the selective-replication mechanism can serve **both** IVM and initial evaluation over an example person/name/address join. For incremental maintenance: when the root pointer changes, use planner analysis to determine which subtrees could hold facts affecting materialized views, use the EAV/AEV/VAE index structure to identify relevant subtree ranges, replicate only those through partial replication, run the changes through DBSP operators, and lean on the cache hierarchy. For initial evaluation: apply the same selective replication — conjunct analysis picks required index ranges, only matching subtrees replicate, conjunct reordering and cycle detection give optimal access, and variable bindings from evaluated conjuncts further constrain subsequent subtree replication. The open question is whether this yields a *unified* evaluation strategy that preserves current performance through selective subtree replication rather than selective fact loading.

## Query syntax

Datalog queries are represented as `Query`:

```ts
type Term<T extends Scalar = Scalar> = T | Variable<T>
interface Variable<T extends Scalar = Scalar> { "?": string; valueOf(): Variable<T> }

type Select = {
  match: { the: Term<Attribute>; of: Term<Entity>; is: Term<Scalar> }
  fact: {}
}
type Conjunct = Constraint | Negation
type Constraint = Select | Predicate
type Disjuncts = Record<string, Conjuncts>
type Conjuncts = Conjunct[]
type Negation = { not: Constraint }

interface DeductiveRule<Conclusion> {
  claim: { [Key in keyof Conclusion]: Term<Conclusion[Key]> }
  when: Disjuncts
}
type RuleApplication<Conclusion> = { match: {...}; rule: DeductiveRule<Conclusion> }
interface Formula<Input, Output> { derive(input: Input) => Output }
type FormulaApplication<Input, Output> = { match: {...}; formula: Formula<Input, Output> }
type Predicate<Conclusion> = FormulaApplication<...> | RuleApplication<Conclusion>
type Query<Conclusion> = RuleApplication<Conclusion>
```

## Exploration

Using an example `{ person, name, address }` join (two `person/name` and `person/address` selects), the exploration should validate that the selective-replication mechanism can serve both scenarios:

1. **For incremental maintenance**: when the store root pointer changes, use the planner's analysis to determine which prolly-tree subtrees could contain facts affecting existing materialized views; use the EAV/AEV/VAE index structure to identify relevant subtree ranges; replicate only those subtrees; process the replicated changes through DBSP operators; benefit from the caching hierarchy.

2. **For initial evaluation**: apply the same selective-replication mechanism — use conjunct analysis to determine required index ranges (EAV/AEV/VAE patterns), replicate only subtrees containing matching facts, leverage conjunct reordering and cycle detection for optimal access, and after evaluating conjuncts use variable bindings to further constrain subsequent subtree replication.

The key question is whether this provides a **unified evaluation strategy** for both initial queries and incremental maintenance while preserving current performance characteristics through selective subtree replication, leveraging prolly-tree properties for efficient change detection, and minimizing blob-store access through intelligent caching and replication.

Source: [notes/dbsp.md](https://github.com/dialog-db/dialog-db/blob/ff9f03bf29edebb429a37de62eac9bcf99312131/notes/dbsp.md) at commit `ff9f03bf`.
