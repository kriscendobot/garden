---
title: Output field costs and built-in formulas
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

> Abstract: Each `#[output]` field of a formula may carry a cost the planner sums to price the formula: `#[output(cost = 3)] quotient` + `#[output(cost = 2)] remainder` = total formula cost 5; an omitted cost defaults to 1. Although `#[derive(Formula)]` can define new formula types, a formula must be registered in the `define_formulas!` macro in `dialog_query::formula::query` to be usable in the query engine. The current built-in set: **Math** (`Sum` "math/sum", `Difference` "math/difference", `Product` "math/product", `Quotient` "math/quotient", `Modulo` "math/modulo"); **Strings** (`Concatenate` "text/concatenate", `Length` "text/length", `Uppercase` "text/upper-case", `Lowercase` "text/lower-case", `Like` "text/like"); **Logic** (`And` "boolean/and", `Or` "boolean/or", `Not` "boolean/not"); **Conversions** (`ToString` "text/from", `ParseUnsignedInteger` "unsigned-integer/parse", `ParseSignedInteger` "signed-integer/parse", `ParseFloat` "float/parse").

## Output field costs

You can specify a cost for each output field:

```rust
#[derive(Debug, Clone, Formula)]
pub struct QuotientRemainder {
    pub dividend: u32,
    pub divisor: u32,
    #[output(cost = 3)]
    pub quotient: u32,
    #[output(cost = 2)]
    pub remainder: u32,
}
// Total formula cost = 3 + 2 = 5
```

If cost is omitted, it defaults to 1.

## Built-in formulas

While `#[derive(Formula)]` can define new formula types, they must be registered in the `define_formulas!` macro in `dialog_query::formula::query` to be usable in the query engine. The current set of built-in formulas:

- **Math** (`dialog_query::formula::math`): `Sum` ("math/sum"), `Difference` ("math/difference"), `Product` ("math/product"), `Quotient` ("math/quotient"), `Modulo` ("math/modulo").
- **Strings** (`dialog_query::formula::string`): `Concatenate` ("text/concatenate"), `Length` ("text/length"), `Uppercase` ("text/upper-case"), `Lowercase` ("text/lower-case"), `Like` ("text/like").
- **Logic** (`dialog_query::formula::logic`): `And` ("boolean/and"), `Or` ("boolean/or"), `Not` ("boolean/not").
- **Conversions** (`dialog_query::formula::conversions`): `ToString` ("text/from"), `ParseUnsignedInteger` ("unsigned-integer/parse"), `ParseSignedInteger` ("signed-integer/parse"), `ParseFloat` ("float/parse").

Source: [notes/formula.md](https://github.com/dialog-db/dialog-db/blob/6475b4d70c682b2db3f243366eff26a9484d0e91/notes/formula.md) at commit `6475b4d7`.
