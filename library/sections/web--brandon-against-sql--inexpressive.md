---
title: "Against SQL — Inexpressive: can't-express, verbose, fragile structure"
source_kind: web-essay
source_url: https://www.scattered-thoughts.net/writing/against-sql
source_content_sha256: 79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be
source_author: Jamie Brandon
source_date: 2021-07-09
ingested: 2026-07-06
ingested_by: scholar
topics: [query-languages]
status: current
---

## Abstract

The first of the essay's three critiques: SQL is a **particularly inexpressive** language, broken down three ways. **(1) Can't be expressed at all** — SQL has no sum types, so a user can't define an arbitrary JSON value's type (the usual workaround, an id-column joined against one table per variant, doesn't work for scalar values that can't do global inserts); `WITH RECURSIVE` is limited to linear recursion with bizarre union-of-all-steps semantics, making parsing/backtracking hard; and per-database extension systems (usually C) aren't standardized, so there is no portable library. This is why JSON, XML, regexes, windows, multi-dimensional arrays, and periods each had to be **added to the spec with new syntax** rather than shipped as library code — because functions aren't values that can take tables or other functions as arguments, and without sum types you can't even express a hard-coded option (like a windowing style) as a value. **(2) Verbose** — the most common join (following a foreign key) has no special syntax, and you can't write a reusable `fk_join` helper because most databases won't let functions take tables as arguments (polymorphic table functions were added in SQL:2016 but essentially only Oracle implemented them, non-conformantly). **(3) Fragile structure** — small changes force whole-query restructuring; the marquee example is that adding a second returned column to a scalar subquery (`ERROR: subquery must return only one column`) forces rewriting it as a `LATERAL` join, which in hundred-line nested analytics queries is laborious and error-prone.

## Can't be expressed

SQL:2016 added JSON support as *language spec* because SQL can't express it as a library. There is no way to define the type of an arbitrary JSON value, because SQL has no sum type:

```rust
enum Json { Null, Bool(bool), Number(Number), String(String), Array(Vec<Value>), Object(Map<String, Value>) }
```

The usual response — an `id` column joining against one table per variant (`json_bool`, `json_number`, `json_string`, `json_array`, ...) — works for data modelling (clunkily; you must try joins against each table at every use site) but is clearly inappropriate for a value created inside a scalar expression, where inserts into a global table aren't allowed. Parsing JSON also requires iteration, and `WITH RECURSIVE` is limited to linear recursion with a bizarre choice of semantics (each step sees only the previous step's results, but the whole result is the union of all steps), making parsing and backtracking difficult. Databases' procedural sublanguages have explicit iteration but share few commonalities, so there is no cross-database pure-SQL JSON parser. Extension systems (usually C) are likewise unstandardized. So the best you can do is add JSON to the spec and hope every database implements it compatibly (they don't). The same story repeats for XML, regular expressions, windows, multi-dimensional arrays, periods, etc.

Contrast Flink's windowing, which is made of objects and function calls (first-class values, storable in variables and passable as arguments): a `WindowAssigner` takes a row and returns window ids, and common styles ship as library code. SQL instead adds substantial new syntax; the windowing style is purely syntactic (not a value), so common patterns can't be compressed, and only a few hard-coded styles exist. Even if you wanted to mimic Flink you couldn't, because functions aren't values that take tables/functions, and without sum types you can't express the hard-coded styles as a value.

## Verbose to express

By far the most common join is following a foreign key, for which SQL has no special syntax:

```sql
select foo.id, quux.value from foo, bar, quux
where foo.bar_id = bar.id and bar.quux_id = quux.id
```

Compare Alloy's dedicated syntax `foo.bar.quux`, or a pandas/Flink helper `fk_join(foo, 'bar_id', bar, 'quux_id', quux)`. You can't write such a helper in SQL: most databases don't let functions take tables as arguments and require input/output column names and types fixed at definition time. SQL:2016's polymorphic table functions might allow it, but so far only Oracle implemented them (not to spec). This verbosity for core operations has chilling downstream effects, such as developers avoiding 6NF even where it's useful because their queries would balloon.

## Fragile structure

Subqueries are the clearest cliff. "For each manager, find their highest-paid employee" works as a scalar subquery — until you also want the salary, at which point `ERROR: subquery must return only one column` forces a full rewrite into a `join lateral (...) on true`. Not terrible in a toy example, but in analytics queries hundreds of lines long with many nesting levels, this restructuring is laborious and error-prone.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
