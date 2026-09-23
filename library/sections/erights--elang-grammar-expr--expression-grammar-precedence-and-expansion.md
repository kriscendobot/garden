---
title: "Expression Grammar: E expressions in precedence order, with Kernel-E expansions"
source_kind: web
source_url: http://erights.org/elang/grammar/expr.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/expr.html
source_fetched_via: mirror
source_content_sha256: 1862586e33bbd115795d277bebecb7609a7ee35cde8fe1cd0bde848d22e3bf4b
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The first
  per-construct child page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`). Presents the
  expression subset of the E grammar in precedence order, each construct with its
  Grammar / Meaning / Expansion triple, where the Expansion column is either a
  rewrite toward Kernel-E or the word "kernel" linking the Kernel-E reference
  (`erights--elang-kernel--expression-forms`). Consolidated to one section
  preserving the precedence ladder inline per conventions.md § Sectioning shapes.
---

## Abstract

The **Expression Grammar** page lays out the expression subset of the E grammar
**in precedence order**: constructs presented later bind tighter than constructs
presented earlier, so `a + b * c + d` parses as `a + (b * c) + d` because `*`
appears below `+`. Each box's title states its **associativity** (left, right,
don't-care, or non-associative). Crucially, every construct carries a third
column, the **Expansion**: either a rewrite into more primitive constructs
(closer to Kernel-E, with `l` and `r` standing for the left and right operands)
or the bare word `kernel` linking the corresponding entry in the Kernel-E
reference manual (`erights--elang-kernel--expression-forms`). The page is the
concrete realization of the chapter's two-layer method: surface E is sugar whose
precise meaning is its Kernel-E expansion. This is the structural ancestor of the
way Hardened JavaScript treats a small analyzable core plus sugar defined by
translation, and of Endo's operator-as-message convention (`+` is the `add`
message, `*` is `multiply`).

## The precedence ladder (loosest to tightest)

The page presents these construct boxes in order, loosest-binding first. Each box
groups constructs of equal precedence; the parenthetical is the box's
associativity.

1. **Sequence** (don't-care associative): `expr "\n"* expr` — newline-separated
   expressions evaluated in order; value is the last value. E uses newlines, not
   semicolons, to terminate expressions. `kernel`.
2. **In-Line Sequence** (don't-care associative): `expr ";" expr` — a sequence on
   one line; a trailing `;` is harmless. Expands to `l "\n" r`.
3. **Assignment and Definition** (right associative): `varName ":=" expr` and the
   `define`/`def` forms — bind or rebind a name. Expansions toward Kernel-E
   `assign` / `def`.
4. **Conditional-Or** (don't-care associative): `expr "||" expr`.
5. **Conditional-And** (don't-care associative): `expr "&&" expr`.
6. **Comparison / sameness** (non-associative): `==`, `!=` and the pattern-match
   operators `=~` (match) and `!~` (non-match).
7. **Partial Ordering** (non-associative): `<`, `<=`, `>=`, `>` (and `<=>` for
   magnitude comparison).
8. **Interval** (non-associative): `expr ".." expr` and `expr "..!" expr` (the
   half-open interval).
9. **Bitwise / set** boxes: `|`, `^`, `&` (with their `|=`, `^=`, `&=`
   assignment forms).
10. **Shift** (left associative): `<<`, `>>` (and `<<=`, `>>=`).
11. **Additive** (left associative): `+`, `-` (and `+=`, `-=`).
12. **Multiplicative** (left associative): `*`, `/`, `//` (floor-divide), `%`,
    `%%` (modulo) with their assignment forms.
13. **Exponentiation** (non-associative): `**` (and `**=`).
14. **Unary** prefix/postfix: `!`, `~`, unary `-`.
15. **Call** (mostly left associative): the `.`-call (immediate message send),
    the `<-`-send (eventual message send), property access, indexing, and the
    method/function call syntax. The call box is the tightest-binding group.

Parentheses obtain any desired grouping and the page recommends them wherever the
default precedence might be unclear to a reader.

## Why an expression language

E is an **expression language**, not a statement language: everything that would
be a statement in C or Java (the conditional, the loop, the `try`) is defined to
yield a value and may nest freely inside other expressions. The sequence
expression is the first example: its components evaluate in order and the whole
yields the value of its last component. See
`erights--elang-blocks--block-structure-and-control-flow` for the control-flow
forms that share this property.

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `.`-call (immediate message send) | synchronous method call `obj.method(...)` |
| `<-`-send (eventual message send) | `E(obj).method(...)` (`@endo/eventual-send`) |
| `+` / `*` as sugar for `add` / `multiply` messages | operators are not message sugar in JavaScript, but the "operator is a named method" idea recurs in marshal's structural treatment |
| `=~` / `!~` pattern match | `@endo/patterns` `matches` / `mustMatch` (no operator form) |
| Kernel-E expansion | not a language feature of JavaScript; the analogous discipline is SES's small analyzable intrinsics core |

## Source

Source: [elang/grammar/expr.html](https://erights.github.io/erights-org-website/elang/grammar/expr.html) (erights.org GitHub Pages mirror), content SHA-256 `1862586e33bb`, last modified 1998-10-03. The full per-construct Grammar / Meaning / Expansion tables are at the source; this section captures the precedence ladder and the expansion method.
