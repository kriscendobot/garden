---
title: "Lexical Grammar: E's tokens (keywords, reserved words, operators, punctuation)"
source_kind: web
source_url: http://erights.org/elang/grammar/lexical.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/lexical.html
source_fetched_via: mirror
source_content_sha256: 10c898985f2f19a94bb73bc6c3e9fd9483a1cb976d69e7ff0552a774cd55e35e
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Lexical Grammar
  child page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`): the tokenizer-level
  grammar (identifiers, keywords-in-use, reserved keywords, operators, and other
  punctuation). Aggressively consolidated to one section preserving the token lists
  inline per conventions.md § Sectioning shapes (token catalog).
---

## Abstract

The **Lexical Grammar** page is E's tokenizer-level grammar: the catalog of
identifiers, keywords, operators, and punctuation from which the surface grammar is
built. It distinguishes **keywords in use** (the words E actually reserves and
uses) from a larger set of **reserved keywords** held back for possible future use
(so that programs written today would not break if those features were added), and
it lists the operator tokens (which the expression grammar
`erights--elang-grammar-expr--expression-grammar-precedence-and-expansion` orders
by precedence) and the **other punctuation** with its roles. The notable
punctuation entries record E's distinctive surface choices: `<-` is the eventually
operator (the eventual message send, ancestor of Endo's `E()`), `=>` makes maps
and enumerates collections, `::` is "audited by", `:` is "holds" for variable
declaration and for calculated URI expressions, `[ ]` makes and matches lists and
indexes collections, `( )` groups and carries arguments, `{ }` introduces a scope,
and `?` is "such-that". This is the lexical floor under the rest of the grammar
chapter.

## Identifiers and keywords

Identifier syntax follows Java (minus `$`; leading `_` reserved for generated
temporaries).

**Keywords in use:** `begin`, `catch`, `class`, `def`/`define`, `delegate`,
`else`, `end`, `escape`, `finally`, `for`, `if`, `in`, `match`, `meta`, `switch`,
`to`, `try`, `while`.

**Reserved keywords** (held back for the future, not currently used): `abstract`,
`an`, `as`, `behalf`, `belief`/`believe`/`believes`, `bind`, `case`, `const`,
`constructor`, `default`, `defmacro`, `deprecated`, `dispatch`, `do`,
`encapsulate`/`encapsulated`/`encapsulates`, `ensure`, `enum`, `eventual`/
`eventually`, `export`, `extends`, `forall`, `function`, `given`, `hidden`/`hides`,
`implements`, `interface`, `is`, `know`/`knows`, `let`, `method`/`methods`,
`native`, `obeys`, `on`, `package`, `private`, `protected`, `public`, `require`,
`sake`, `static`, `struct`, `suchthat`, `synchronized`, `this`, `throws`,
`transient`, `typedef`, `unum`, `uses`, `virtual`, `void`, `volatile`.

## Operators

The page lists the operator tokens that the expression grammar orders by
precedence, including: sequencing `\n` and `;`, assignment `:=` and `define patt
:=`, the logical `||` and `&&`, the sameness `==` / `!=`, the match operators `=~`
/ `!~`, the bitwise/set `|` `^` `&` (with `|=` `^=` `&=`), the slot reference `&
varName`, the partial-ordering `<` `<=` `>=` `>`, the interval `..` and `..!`, the
shifts `<<` `>>` (with `<<=` `>>=`), additive `+` `-` (with `+=` `-=`),
multiplicative `*` `/` `//` `%` `%%` (with their assignment forms),
exponentiation `**` (with `**=`), and the unary `!` and `~`.

## Other punctuation

- `<-` — eventually (the eventual message send). Ancestor of `E()` /
  `@endo/eventual-send`.
- `=>` — maps-to; used to make maps and to enumerate collections.
- `::` — audited by.
- `:` — holds; used to declare variables and for calculated URI expressions.
- `[` `]` — list-of / map-of; make and match lists and maps, and index into
  collections.
- `(` `)` — grouping, arguments, parameters.
- `{` `}` — scoped block.
- `?` — such-that (the guard in patterns).

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `<-` eventually operator | `E(obj).method(...)` eventual send |
| `=>` maps-to | object-literal `key: value` (no operator form) |
| `:` holds (declaration / URI) | type/guard annotation; capability locator |
| `=~` / `!~` match operators | `@endo/patterns` `matches` (no operator form) |
| reserved-keyword discipline | reserving words against future syntax (a forward-compatibility practice) |

## Source

Source: [elang/grammar/lexical.html](https://erights.github.io/erights-org-website/elang/grammar/lexical.html) (erights.org GitHub Pages mirror), content SHA-256 `10c898985f2f`, last modified 1998-10-03.
