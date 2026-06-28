---
title: "Kernel-E expression forms (the special-forms BNF quick-reference card)"
source_kind: web
source_url: http://erights.org/elang/kernel/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/kernel/index.html
source_fetched_via: mirror
source_content_sha256: 2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The eExpr half of
  the Kernel-E Quick Reference Card: every kernel expression special form with its
  pseudo-BNF production, kept inline for grep. Pattern forms and helper productions
  are in the sibling pattern-forms-and-helpers section.
---

## Abstract

This is the **expression catalog** of Kernel-E: the complete set of special forms
a Kernel-E parse tree can contain, each with its pseudo-BNF production from the E
Kernel Language Quick Reference Card. A `Kernel-E-Program` is a `seqExpr`, and
every `eExpr` is one of the forms below: the literal, variable-reference, and
slot forms; assignment and sequencing; `=~` match-binding and `def` definition;
the `{ }` hiding block; the `if` / `escape` / `try`-`catch` / `try`-`finally`
control forms; the `.`-call (`callExpr`, immediate) and `<-`-send (`sendExpr`,
eventual) forms; and the `objectExpr` that defines an object (specialized to a
`methodicalExpr` with an eScript, or a `plumbingExpr` with a matcher). These
fifteen-or-so forms are the entire surface the meta-interpreter's `eval` switch
dispatches on; all of surface E is sugar expanding into combinations of them. The
notation: terminals are quoted bold strings or upper-case-initial names; non-
terminals are lower-case-initial names; `[ ]` marks an optional form; `*` is zero-
or-more; `+` is one-or-more.

## Program and the eExpr forms

```
Kernel-E-Program:  seqExpr

eExpr : any of the following

  literalExpr    :  Integer | Float64 | Char | String
  Noun           :  Identifier                              # a nounExpr: use of a variable name
  slotExpr       :  "&" Identifier                          # the slot itself, not its value
  assignExpr     :  Noun ":=" eExpr
  seqExpr        :  eExpr ("\n" eExpr)*
  matchBindExpr  :  eExpr "=~" pattern
  defineExpr     :  "def" pattern ":=" eExpr
  hideExpr       :  "{" eExpr "}"                           # a fresh nested scope
  ifExpr         :  "if" "(" eExpr ")" "{" eExpr "}" "else" "{" eExpr "}"
  escapeExpr     :  "escape" pattern "{" eExpr "}" "catch" pattern "{" eExpr "}"
  catchExpr      :  "try" "{" eExpr "}" "catch" pattern "{" eExpr "}"
  finallyExpr    :  "try" "{" eExpr "}" "finally" "{" eExpr "}"
  callExpr       :  eExpr "." Verb "(" eExpr ("," eExpr)* ")"     # immediate call
  sendExpr       :  eExpr "<-" Verb "(" eExpr ("," eExpr)* ")"    # eventual send
  objectExpr     :  "/**" docComment "*/" "def" (String | "_") auditors behavior
```

`objectExpr` is therefore `methodicalExpr | plumbingExpr`:

```
  methodicalExpr :  "/**" docComment "*/" "def" (String | "_") auditors eScript
  plumbingExpr   :  "/**" docComment "*/" "def" (String | "_") auditors matcher
```

## Notes on individual forms

- **`literalExpr`** covers the four primitive literal kinds: `Integer`,
  `Float64`, `Char`, `String`.
- **`Noun`** is a use-occurrence of a variable name (a `nounExpr`); it statically
  corresponds to exactly one defining occurrence (a `finalPattern` or
  `varPattern`). **`slotExpr`** (`&name`) yields the *slot* object backing a noun
  rather than the noun's current value, which is how the language exposes a
  variable's storage as a first-class object.
- **`assignExpr`** (`name := expr`) updates a noun's slot; **`defineExpr`**
  (`def pattern := expr`) introduces new bindings by matching `pattern` against
  the value of `expr`.
- **`seqExpr`** is the newline-separated sequence; a whole Kernel-E program is one
  `seqExpr`. **`hideExpr`** (`{ expr }`) wraps an expression in a fresh nested
  scope so its definitions do not leak outward.
- **`matchBindExpr`** (`expr =~ pattern`) tests-and-binds: it matches `pattern`
  against the value of `expr` and makes the bindings available.
- The control forms **`ifExpr`**, **`escapeExpr`**, **`catchExpr`**, and
  **`finallyExpr`** are all expressions (they yield values), consistent with E's
  "no statements, only expressions" rule. `escapeExpr` provides a named non-local
  exit (its `catch` clause receives the escaped value); `catchExpr` and
  `finallyExpr` are the exception forms.
- **`callExpr`** (`recvr.verb(args)`) is the **immediate** message call;
  **`sendExpr`** (`recvr <- verb(args)`) is the **eventual** send that returns a
  promise without blocking. These two are the only constructs that take action
  *between* objects (the `apply` functionality the meta-interpreter absorbs); the
  eventual `<-` send over a possibly-cross-machine reference is the direct
  ancestor of Endo's `E()` / HandledPromise eventual-send.
- **`objectExpr`** is the sole object-definition form. It carries an optional
  doc-comment and `auditors` clause, the object's name (a `String`, or `_` for an
  anonymous object), and a `behavior`. A `methodicalExpr` supplies an `eScript`
  (methods plus an optional matcher); a `plumbingExpr` supplies a bare `matcher`
  (an object that acts as message plumbing). The pattern, helper, and `behavior`
  productions are catalogued in the sibling pattern-forms-and-helpers section.

## Source

Source: [elang/kernel/index.html](https://erights.github.io/erights-org-website/elang/kernel/index.html) (mirror of `http://erights.org/elang/kernel/index.html`), last modified 1998-10-03, content SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`, fetched via the erights.org GitHub Pages mirror.
