---
title: Semantic — Formulas
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

Abstract: **Formulas** are pure computations integrated into the query planner: given bound input fields, a formula computes output fields. A formula is a struct deriving `#[derive(Formula)]` whose output field(s) are marked `#[output]`, with a `compute(input: Input<Self>) -> Vec<Self>` method (returning a vector, so a formula may produce zero or many rows). Formulas are used as **premises** in rules, computing derived values from bound variables (e.g. a `TotalComp` rule joins `Salary` and `Bonus` through a `Sum` formula premise). The built-in formulas are `Sum`, `Difference`, `Product`, `Quotient`, `Modulo`, `Concatenate`, `Length`, `Uppercase`, `Lowercase`, `Like`, `ToString`, `ParseUnsignedInteger`, `ParseSignedInteger`, `ParseFloat`, `And`, `Or`, `Not`. This is the crate-doc Rust surface for formulas; the polymorphic-scheme rationale lives under `formula-scheme`.

## Formulas

Pure computations integrated into the query planner. Given bound input fields, a formula computes output fields.

```rs
#[derive(Debug, Clone, Formula)]
pub struct Sum {
    pub of: u32,
    pub with: u32,
    #[output]
    pub is: u32,
}

impl Sum {
    pub fn compute(input: Input<Self>) -> Vec<Self> {
        vec![Sum {
          of: input.of,
          with: input.with,
          is: input.of + input.with
        }]
    }
}
```

Formulas are used as premises in rules, computing derived values from bound variables:

```rs
fn total_compensation(result: Query<TotalComp>) -> impl When {
    (
        Query::<Salary> {
            of: result.this.clone(),
            is: Term::var("salary"),
        },
        Query::<Bonus> {
            of: result.this.clone(),
            is: Term::var("bonus"),
        },
        Query::<Sum> {
            of: Term::var("salary"),
            with: Term::var("bonus"),
            is: result.total.clone(),
        },
    )
}
```

Built-in formulas: `Sum`, `Difference`, `Product`, `Quotient`, `Modulo`, `Concatenate`, `Length`, `Uppercase`, `Lowercase`, `Like`, `ToString`, `ParseUnsignedInteger`, `ParseSignedInteger`, `ParseFloat`, `And`, `Or`, `Not`.

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
