---
id: deductive-rule
aliases: [deductive rule, deduce when unless, deduce, unless clause, negation as failure, disjunction as rules, rule premise, conjunction of premises, closed-world assumption, formula premise, equality constraint, rule conclusion]
topics: [datalog-query]
---

# deductive-rule

Dialog's advanced composition beyond stitching attributes into a concept: a rule derives a concept instance (`deduce`) when its body of premises (`when`, a conjunction all satisfied by the same variable bindings) holds and no exclusion pattern (`unless`) can be satisfied. It can impose constraints, compute derived values with formulas, and follow transitive paths, and is resolved at query time by the semantic layer. A **premise** pairs an `assert` (an inline concept, a formula reference, or a constraint reference) with a `where` map binding field names to terms (variables `?x`, blank wildcards `_`, or constants); the variable `this` is implicit and binds the conclusion's entity. **Conjunction** is the implied AND over `when`; **disjunction** is expressed as several rules deducing the same concept, so a rule from a different domain can extend a concept without touching the originals. `unless` is **negation as failure** under the closed-world assumption. Formula premises (math/text/logic built-ins) and the equality constraint `==` (which can filter, infer, or fail) are the computational premises. This is the notation-level view; the Rust implementation and query-planning face live under the rule-pipeline / operator-IR sections.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-notation--deductive-rules](../sections/dialog-db--notes-notation--deductive-rules.md) | The formal `deduce`/`when`/`unless` rule, premises/terms/variables, conjunction, disjunction as separate rules, negation as failure. |
| [dialog-db--notes-notation--constraints-and-formulas](../sections/dialog-db--notes-notation--constraints-and-formulas.md) | The equality `==` constraint and the math/text/logic formula built-ins as rule-body premises. |
| [dialog-db--notes-notation--abbreviated-deductive-rules](../sections/dialog-db--notes-notation--abbreviated-deductive-rules.md) | The compact abbreviated-notation rule syntax (concept matching, constraints, formulas, negation) and its expansion. |
| [dialog-db--notes-concept--schema-on-read-and-rules](../sections/dialog-db--notes-concept--schema-on-read-and-rules.md) | Concepts as the conclusion type of deductive rules; multiple rules for one concept give logical disjunction. |
| [dialog-db--notes-rules--defining-rules-and-grounding](../sections/dialog-db--notes-rules--defining-rules-and-grounding.md) | The Rust-API rule as a function from a conclusion pattern to a tuple of premises; grounding and premise-order independence. |

## See also

- [[dialog-notation]] — the notation that expresses rules (formal and abbreviated).
- [[optional-attribute-query]] — how optionality (`maybe`) interacts with rule bodies and negation.
- [[formula-scheme]] — the polymorphic-formula type story behind the built-in formulas.
- [[fact-triple]] — the claims a rule's premises match against.
