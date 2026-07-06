---
title: Constraints and formulas (formal notation)
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The computational premises a rule body can carry beyond concept matching. A **constraint** restricts variable bindings; the built-in **equality** constraint (`"assert": "=="`, with `where: { this, is }`) asserts two terms hold equal values and can *filter* (both bound), *infer* (one bound, one free), or *fail* (neither bound). A **formula** is a pure computation — like a spreadsheet cell — that, given bound input fields, derives output fields; formulas run inside rules and queries to compute, filter, or transform without leaving the query engine. The built-in set: **math** (`math/sum` `of+with`, `math/difference` `of-subtract` saturating at 0, `math/product` `of*times`, `math/quotient` `of/by`, `math/modulo` — quotient/modulo yield no result on divisor 0); **text** (`text/concatenate` `first++second`, `text/length` byte length, `text/upper-case`, `text/lower-case`, `text/like` glob `*`/`?`/`\` — result only on match); **logic** (`boolean/and`, `boolean/or`, `boolean/not`). Each names its parameters and an `is` output term.

### Constraints

Constraints restrict variable bindings within a rule body.

**Equality (`==`).** An equality constraint asserts that two terms must hold equal values. It can filter (both bound), infer (one bound, one free), or fail (neither bound). It appears as a premise `{ "assert": "==", "where": { "this": <term>, "is": <term> } }` — for example, constraining a bound `name` variable to equal the constant `"Alice"`.

### Formulas

A pure computation, similar to formulas in a spreadsheet. Given bound input fields, a formula derives output fields. Formulas can be used within rules and queries to compute values, filter matches, or transform data without leaving the query engine. A formula premise is `{ "assert": "<domain>/<name>", "where": { <params>, "is": <output> } }`.

**Math formulas** (arithmetic over integer values):

- `math/sum` — adds two integers: `is = of + with`.
- `math/difference` — subtracts second from first, saturating at 0: `is = of - subtract`.
- `math/product` — multiplies: `is = of * times`.
- `math/quotient` — divides: `is = of / by`; produces no result when the divisor is zero.
- `math/modulo` — remainder: `is = of % by`; produces no result when the divisor is zero.

**Text formulas** (string operations):

- `text/concatenate` — joins two strings: `is = first ++ second`.
- `text/length` — byte length of a string.
- `text/upper-case` / `text/lower-case` — case conversion.
- `text/like` — glob pattern match; produces a result only when the pattern matches. `*` matches any sequence, `?` matches a single character, `\` escapes special characters.

**Logic formulas** (boolean logic):

- `boolean/and` — logical AND of `left` and `right`.
- `boolean/or` — logical OR of `left` and `right`.
- `boolean/not` — logical NOT of `value`.

Each formula's schema names its input parameters and a required derived `is` output term. `FormulaRef` in the schema enumerates the full set of built-in formula names; `ConstraintRef` enumerates the constraint names (`==`).

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
