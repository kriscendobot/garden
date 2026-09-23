---
title: "Primitive Expressions: the atomic E expressions (literals, variables, quasi-literals, URIs, lists, maps)"
source_kind: web
source_url: http://erights.org/elang/grammar/prim-expr.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/prim-expr.html
source_fetched_via: mirror
source_content_sha256: 875d380808da3cdc0e1d1da0ae25f1365119aa7f5fa24275c7df35486e38f058
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Primitive
  Expressions child page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`): the atomic
  expressions that have no parsing ambiguity and so need no precedence, the base
  on which the precedence-ordered expression grammar
  (`erights--elang-grammar-expr--expression-grammar-precedence-and-expansion`)
  builds. One consolidated section.
---

## Abstract

**Primitive Expressions** are the atomic expressions of E: they have no parsing
ambiguity to resolve by precedence or associativity, so they form the base on
which the rest of the expression grammar builds. The page catalogs them with the
chapter's Grammar / Meaning / Expansion shape. The notable members are the
**variable-name expression** (yields the value of the in-scope variable of that
name; the underscore `_` is sugar for the meta-variable `ForAllX`, the "blank to
be filled in" used to make regions and twisters), the **literal expression**
(precision-unlimited integers in base 10/8/16 with ignorable embedded `_`
separators, `float64`, character, and string literals, all `kernel`), the
**quasi-literal expression** (the pluggable-parser interpolation form, expanded in
`erights--elang-grammar-quasi-overview--quasi-literals`), the **URI-literal
expression** (capability-mediated dereference through a scope-supplied
`uriGetters` collection rather than ambient file access), and the **list / map
constructors**. The URI-literal is the E-language root of Endo's no-ambient-IO
discipline: a URI is resolved by a protocol handler looked up in the current
scope, not by an ambient open-by-path.

## The primitive expressions

- **Parenthesized expression** `"(" expr ")"` — disambiguates grouping; does not
  introduce a new scope. No Kernel-E expansion needed.
- **Variable-name expression** — an identifier yields the value of the same-named
  variable whose definition is in scope (Java identifier syntax minus `$`; names
  beginning with `_` are reserved for compiler-generated temporaries). `kernel`.
  The keyword `_` used as an expression is shorthand for the variable `ForAllX`,
  best read as "a blank to be filled in": `def r := _ >= 3` produces a region
  (usable as a one-argument predicate) of all integers at least three, so `r(5)`
  yields `true`.
- **Literal expression** — `LiteralInteger` (arbitrary precision, base 10/8/16 by
  leading digit/`0`/`0x`, embedded `_` ignored so `31_536_000` reads cleanly),
  `LiteralFloat64`, `LiteralCharacter`, `LiteralString`. All `kernel`.
- **Quasi-literal expression** — `parserName` followed by a backquoted quasi-string
  with embedded `$`-holes; defaults to the `simple` parser when the name is
  omitted. Expands to `quasiParsers["parserName"].valueMaker("...").substitute([args])`.
  Full treatment in `erights--elang-grammar-quasi-overview--quasi-literals`.
- **URI-literal expression** — `<file:/autoexec.bat>` form; looks up the named
  protocol handler (the identifier left of the colon) in the scope's `uriGetters`
  collection and asks it to dereference the URI body. A bare single drive-letter
  protocol gets an implicit `file:`. The handler, not the language, decides how to
  treat a `#` fragment. This is capability-mediated retrieval, the ancestor of
  Endo's no-ambient-authority IO.
- **List and map expressions** — the `[...]` list constructor and the `[k => v,
  ...]` map constructor (see `erights--elang-collect--collections-tables-spaces-and-the-for-loop`).

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `_` meta-variable / region | no direct equivalent; the predicate-as-region idea recurs in `@endo/patterns` matchers |
| quasi-literal `parserName\`...\`` | JavaScript tagged template literal `` tag`...` `` |
| URI-literal via scope `uriGetters` | capability-passed locator / no ambient `fetch`; `@endo/...` capability IO |
| arbitrary-precision integer literal | `bigint` literal (`123n`) |

## Source

Source: [elang/grammar/prim-expr.html](https://erights.github.io/erights-org-website/elang/grammar/prim-expr.html) (erights.org GitHub Pages mirror), content SHA-256 `875d380808da`, last modified 1998-10-03.
