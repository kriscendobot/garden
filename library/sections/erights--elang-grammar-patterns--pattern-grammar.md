---
title: "Pattern Grammar: E's pattern forms (such-that, list, exact-match, quasi, namer, ignore)"
source_kind: web
source_url: http://erights.org/elang/grammar/patterns.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/patterns.html
source_fetched_via: mirror
source_content_sha256: cfdd6df405365b4592f1626ed05300350a98e696a30c41045dc2deababbce663
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, patterns]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Patterns child
  page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`). E's pattern
  sub-language: the forms that match a specimen and bind names in the resulting
  scope. Direct ancestor of `@endo/patterns`; the kernel-level forms are in
  `erights--elang-kernel--pattern-forms-and-helpers`.
---

## Abstract

The **Pattern Grammar** page is E's pattern sub-language: the forms that, given a
specimen, either fail or succeed while binding names in the resulting scope.
Patterns appear on the right of the `=~` match operator, in `switch` matchers, and
as method/function parameters (so parameter binding *is* pattern matching). The
page lists each pattern form with the chapter's Grammar / Meaning / Expansion
shape, where `t` denotes the specimen. The forms are the **such-that** pattern
(`pattern "?" prefixExpr` — match the sub-pattern, then require the guard
expression to be true), the **list** patterns (`"[" patt0,... "]"` matches a list
of exactly that length element-wise; `"[" patt0,... "]" + pattn` matches the
respective head elements and binds the rest), the **exact-match** pattern (`"=="
primExpr` succeeds when the specimen is `==` to the value, expanding to a such-that
`t ? (t == primExpr)`), the **quasi-literal** patterns (the `@`-hole extracting
form, treated in `erights--elang-grammar-quasi-overview--quasi-literals`), and the
**namer** patterns. The namer family is the only form of variable definition in E:
`varName : primExpr` binds the name to a constructed slot guarded by the
expression (the `:Guard` hook), bare `varName` binds with no explicit SlotMaker,
`& varName` binds the slot itself rather than the value, and `_` matches anything
and binds nothing. This is the direct ancestor of `@endo/patterns` and of exo
method-guard parameter shapes.

## The pattern forms

- **Such-That** (non-associative): `pattern "?" prefixExpr` — match the sub-pattern
  against the specimen; if it succeeds, evaluate the guard expression in the
  resulting scope and require it to be true. `kernel`.
- **List patterns** (right associative): `"[" patt0,... "]" + pattn` matches the
  respective leading elements and binds the rest to `pattn`; `"[" patt0,... "]"`
  matches a list of exactly that length, expanding to `[patt0,...] + ==[]` (the
  tail must exactly match the empty list).
- **Exact-Match** (non-associative): `"==" primExpr` — succeeds when the specimen
  is `==` to the value of `primExpr`; expands to the such-that `t ? (t ==
  primExpr)`.
- **Quasi-Literal patterns** (non-associative): `parserName\`quasi\`` — an almost
  literal pattern in an embedded grammar; `\`quasi\`` defaults to the `simple`
  quasi-parser. Expands through `quasiParsers[...].matchMaker(...).matchBind(...)`;
  see `erights--elang-grammar-quasi-overview--quasi-literals`.
- **Namer patterns** (non-associative) — the variable-definition family:
  - `varName : primExpr` binds the name to a constructed slot, with `primExpr` as
    the guard / SlotMaker. `kernel`.
  - `varName` binds with no explicit SlotMaker, defaulting to `varName :final` or
    `varName :settable`.
  - `& varName` binds the slot rather than the value (`varName : defineSlot`).
  - `_` matches everything and binds nothing. `kernel`.

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| pattern / specimen / bind | `@endo/patterns` pattern / specimen; `matches(specimen, pattern)` |
| such-that `patt ? guard` | a predicate-refined pattern; `M.and(...)` plus a custom check |
| list pattern `[a, b] + rest` | array destructuring with a rest element |
| namer `varName : Guard` | a guarded binding; exo method-guard parameter shape |
| `_` ignore pattern | `M.any()` (matches anything); the throwaway `_` binding |
| `==` exact-match pattern | `M.kind`/literal equality in a pattern |

## Source

Source: [elang/grammar/patterns.html](https://erights.github.io/erights-org-website/elang/grammar/patterns.html) (erights.org GitHub Pages mirror), content SHA-256 `cfdd6df40536`, last modified 1998-10-03.
