---
title: "Kernel-E pattern forms, helper productions, and terminals"
source_kind: web
source_url: http://erights.org/elang/kernel/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/kernel/index.html
source_fetched_via: mirror
source_content_sha256: 2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The pattern half of
  the Kernel-E Quick Reference Card plus the helper productions (auditors, eMethod,
  matcher, eScript, behavior, docComment) and terminals (Verb, Identifier, Text,
  DocTag). The expression forms are in the sibling expression-forms section.
---

## Abstract

Kernel-E's **pattern forms** are the defining-occurrence half of the language:
where classical languages put a parameter name or a variable declaration, E puts a
**pattern** that is matched against a value, binding nouns as a side effect (a
plain `Identifier` parameter is just the degenerate, common case). This section
catalogs the pattern productions with their pseudo-BNF: the `simplePattern` family
(`finalPattern` for an immutable binding, `varPattern` for a reassignable one,
`ignorePattern` `_`), the `suchThatPattern` (`pattern ? guard`), and the list-
destructuring `listPattern` and `cdrPattern` (`[head] + tail`). It also catalogs
the **helper productions** that the expression forms reference: `auditors` (the
`implements` clause), `eMethod` (a named method), `matcher` (the catch-all
`match`), `eScript` (methods plus optional matcher), `behavior` (eScript or
matcher), and `docComment`; and the **terminals** beyond the quoted literals
(`Verb`, `Identifier`, `Text`, `DocTag`). Each `finalPattern` / `varPattern`
carries a `: eExpr` **guard** expression, which is the coerce-or-reject hook that
makes E's pattern positions the ancestor of Endo `@endo/patterns` guards.

## Pattern forms

```
pattern : any of the following

  simplePattern   :  finalPattern | varPattern | ignorePattern
  finalPattern    :  Noun ":" eExpr            # immutable binding; the eExpr is the guard
  varPattern      :  "var" Noun ":" eExpr      # reassignable binding; the eExpr is the guard
  ignorePattern   :  "_"                       # match anything, bind nothing
  suchThatPattern :  pattern "?" eExpr         # match pattern AND require eExpr (a guard predicate) true
  listPattern     :  "[" [pattern ("," pattern)*] "]"   # exact-length list destructuring
  cdrPattern      :  listPattern "+" pattern   # head-list "+" rest-pattern (cons/cdr destructuring)
```

The `: eExpr` on a `finalPattern` / `varPattern` is the **guard**: the value being
matched is coerced through (or rejected by) the guard object that `eExpr`
evaluates to before the binding is made. This is the kernel-level root of E's Soft
Type Checking and of Endo's later `@endo/patterns` / `M.interface` method guards.

## Helper productions

```
  auditors    :  ["implements" eExpr ("," eExpr)*]                # the object's auditor list
  eMethod     :  "/**" docComment "*/" "method" Verb
                 "(" pattern ("," pattern)* ")" ":" eExpr "{" eExpr "}"
  matcher     :  "match" pattern "{" eExpr "}"                    # catch-all message handler
  eScript     :  "{" eMethod* matcher? "}"                        # zero+ methods, optional matcher
  behavior    :  eScript | matcher
  docComment  :  (Text | DocTag)*
```

- **`auditors`** is the optional `implements ...` clause on an object expression;
  auditors inspect an object's source at definition time (the mechanism behind E's
  later auditor / verified-properties work).
- **`eMethod`** is one named method: a doc-comment, the `method` keyword, a `Verb`
  name, a parenthesized list of *patterns* (not bare names) for the parameters, a
  `: eExpr` result guard, and a `{ eExpr }` body.
- **`matcher`** (`match pattern { eExpr }`) is the catch-all: it handles any
  message not matched by a named method, binding the message to `pattern`. An
  object defined by a bare `matcher` is a `plumbingExpr` (message plumbing).
- **`eScript`** is the methodical-object body: zero or more `eMethod`s and an
  optional trailing `matcher`. **`behavior`** is either an `eScript` or a
  `matcher`, which is exactly the `methodicalExpr`-versus-`plumbingExpr` split.

## Terminals (beyond the literals and quoted terminals above)

```
  Verb        :  Identifier
  Identifier  :  (IdentStart)(IdentPart)*  |  "_"(IdentPart)+     # "_" alone is a keyword
  Text        :  arbitrary text within a docComment other than DocTags
  DocTag      :  "@" Identifier Text
```

`Verb` (a method/selector name) and `Identifier` are both terminal token types.
Note the rule that `_` by itself is a keyword (the `ignorePattern`), so an
identifier that is only underscores is not a legal `Identifier`; it must contain
at least one `IdentPart`. `Text` and `DocTag` are the doc-comment terminals (a
`DocTag` is `@name text`, the structured-documentation form).

## Source

Source: [elang/kernel/index.html](https://erights.github.io/erights-org-website/elang/kernel/index.html) (mirror of `http://erights.org/elang/kernel/index.html`), last modified 1998-10-03, content SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`, fetched via the erights.org GitHub Pages mirror.
