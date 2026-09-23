---
title: Defining and using a formula
source: notes/formula.md
source_repo: dialog-db/dialog-db
source_commit: 6475b4d70c682b2db3f243366eff26a9484d0e91
source_date: 2026-03-09
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Formulas are pure computations integrated into the query planner: given bound input fields, they compute output fields. A formula is a struct with `#[derive(Formula)]` and one or more `#[output]`-marked fields (e.g. `Sum { of: u32, with: u32, #[output] is: u32 }`); the derive macro generates the query/rule boilerplate and an `Input` struct (`SumInput`) holding only the non-output fields, which `Input<Sum>` resolves to. The author manually implements `fn compute(input: Input<Self>) -> Vec<Self>`, returning the output fields. `compute` returns a `Vec`, so one input can produce **zero** outputs (an empty vec filters the match, acting as a guard), **one** (the common case), or **many** (expanding one input into several, e.g. splitting a string). A formula is used in a query by binding its fields to `Term::var(...)` — `Query::<Sum> { of: Term::var("x"), with: Term::var("y"), is: Term::var("z") }`.

Formulas are pure computations integrated into the query planner. Given bound input fields, they compute output fields.

## Defining a formula

```rust
#[derive(Debug, Clone, Formula)]
pub struct Sum {
    pub of: u32,
    pub with: u32,
    #[output]
    pub is: u32,
}

impl Sum {
    pub fn compute(input: Input<Self>) -> Vec<Self> {
        vec![Sum { of: input.of, with: input.with, is: input.of + input.with }]
    }
}
```

The `#[derive(Formula)]` macro generates all the boilerplate needed to use the formula in queries and rules. It also generates an `Input` struct (e.g. `SumInput`) containing only the non-output fields; the type alias `Input<Sum>` resolves to this struct, which is what the `compute` function receives.

You must manually implement the `compute` function that produces output fields from the input. Note that `compute` returns a `Vec`, so a single input can produce zero, one, or many outputs. Returning an empty vec filters out the match (acting as a guard), while returning multiple results expands a single input into many (e.g. splitting a string into parts). Most formulas return exactly one result.

## Using in queries

```rust
Query::<Sum> {
    of: Term::var("x"),
    with: Term::var("y"),
    is: Term::var("z"),
}
```

Source: [notes/formula.md](https://github.com/dialog-db/dialog-db/blob/6475b4d70c682b2db3f243366eff26a9484d0e91/notes/formula.md) at commit `6475b4d7`.
