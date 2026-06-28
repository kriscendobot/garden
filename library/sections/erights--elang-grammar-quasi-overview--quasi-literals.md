---
title: "Quasi-Literals: the pluggable-parser interpolation and pattern-matching framework"
source_kind: web
source_url: http://erights.org/elang/grammar/quasi-overview.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/quasi-overview.html
source_fetched_via: mirror
source_content_sha256: 682d72f245492974757cc2bcc5ff510ce983d2fcb101d7d65eed4c26524c6dc7
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, patterns]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Quasi-Literals
  child page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`). E's pluggable
  quasi-parser framework: the unifying mechanism behind both the quasi-literal
  *expressions* (`erights--elang-grammar-prim-expr--primitive-expressions`) and the
  quasi-literal *patterns* (`erights--elang-grammar-patterns--pattern-grammar`).
  Direct ancestor of JavaScript tagged template literals and of `@endo/patterns`
  quasi-parsers.
---

## Abstract

The **Quasi-Literals** page explains E's pluggable quasi-parser framework, the
mechanism that unifies the quasi-literal expression and quasi-literal pattern
forms the grammar pages reference. The motivation: a notation can be optimized to
make either the **value's nature** visible (a literal, like `printf`'s format
string) or the **computation's nature** visible (a normal expression, like string
concatenation). Quasi-literals give the first while still allowing runtime
substitution, generalizing Lisp's quasi-quote and the interpolation/regular-
expression facilities of scripting languages to *arbitrary* data types by letting
each **quasi-parser** define its own embedded grammar. A quasi-literal is an
optional parser name, a backquote, a string in that parser's grammar with embedded
`$`-substitution holes (expressions) and, in pattern context, `@`-extraction holes
(patterns), and a closing backquote. The expansion routes through the named
parser's `valueMaker(...).substitute([...])` for expressions and
`matchMaker(...).matchBind([...], specimen)` for patterns. Two parsers ship: the
**`simple`** parser (text interpolation and anti-greedy text match) and the
**`e`** parser (E's own parser, producing and matching Kernel-E parse trees, so
algebra can be written in infix and manipulated structurally). This match-bind-
substitute framework is the direct ancestor of JavaScript tagged template
literals and of the quasi-parsers in `@endo/patterns`.

## The framework

A **quasi-literal expression** is `parserName` (defaulting to `simple`) plus a
backquoted string with embedded `$<identifier>` or `${<E expression>}` holes. The
parser sees the string with the expression source removed, replaced by numbered
substitution holes:

```
foo`some text${bar() + 3}more text$baz`
```

expands to

```
foo__quasiParser.valueMaker("some text${0}more text${1}").substitute([bar() + 3, baz])
```

The named `foo__quasiParser` builds a **ValueMaker** from the transformed string;
the ValueMaker is then invoked with the list of hole values, which it plugs into
the holes to make whatever value the parser takes the quasi-string to describe.
Because the same quasi-expression evaluates the same `valueMaker(..)` argument each
time (only the `substitute(..)` argument varies), parsers should cache compiled
ValueMakers by transformed string.

A **quasi-literal pattern** uses the same surface, but the embedded stuff may also
be `@<identifier>` or `@{<E pattern>}` extraction holes. E's grammar has two
parsing contexts (expression and pattern); a quasi-literal is transformed as one
or the other by its context. The pattern expansion introduces a generated
temporary and routes through `matchMaker(...).matchBind(args, specimen)`, which
returns `null` on failure (failing the enclosing list match) or a list of
extracted bindings on success:

```
"abcde" =~ `a@{x}d@y`   # binds x = "bc", y = "e", value true
```

## The two shipped quasi-parsers

- **`simple`** — text. Outside holes, the text describes itself; substitution is
  stringify-and-concatenate (the familiar interpolation of Perl/Tcl/shells), and
  matching is the simplest anti-greedy match-and-extract without backtracking.
- **`e`** — parse trees. E's own parser used as a quasi-parser: it accepts E
  source and produces post-expansion Kernel-E ASTs (which print back as
  `` e`...` `` quasi-expressions). Since substitution is structural, not textual,
  precedence differences cause no confusion. The `deriv.e` symbolic-differentiation
  package uses `e`-patterns to match algebraic trees (for example `match e`@a +
  @b`) and rebuild them, showing the match-bind-substitute style applied to trees
  the way scripting languages apply it to text.

The page notes a then-current proposal to use XML/DOM trees as a universal
parse-tree structure; that proposal is the obsolete companion page
`erights--elang-grammar-quasi-xml--obsolete-quasi-literals-and-xml`.

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| quasi-parser | a tag function for a tagged template literal; a `@endo/patterns` quasi-parser |
| `valueMaker(...).substitute([...])` | the tag function's `(strings, ...values)` invocation |
| `${expr}` substitution hole | template-literal `${expr}` interpolation |
| `@id` / `@{patt}` extraction hole | a binding hole in a `@endo/patterns` quasi-pattern |
| `e` quasi-parser (parse trees) | structural template tags that build/match ASTs |
| `simple` quasi-parser (text) | the default string-interpolation tag |

## Source

Source: [elang/grammar/quasi-overview.html](https://erights.github.io/erights-org-website/elang/grammar/quasi-overview.html) (erights.org GitHub Pages mirror), content SHA-256 `682d72f24549`, last modified 1998-10-03.
