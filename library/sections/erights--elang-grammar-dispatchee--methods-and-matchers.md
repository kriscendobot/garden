---
title: "Methods and Matchers: the non-first-class dispatchees of object and class definitions"
source_kind: web
source_url: http://erights.org/elang/grammar/dispatchee.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/dispatchee.html
source_fetched_via: mirror
source_content_sha256: 56341a00677acea44758e6bde32b8dc5ba7b2a83d1184376f9e19960497daf30
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, patterns]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Methods and
  Matchers child page of the grammar chapter
  (`erights--elang-grammar--grammar-and-kernel-e-expansion`). A thin page: it
  defines what methods and matchers are (head patterns plus a body expression, not
  first class, appearing only in dispatching contexts) and points at the per-form
  grammar. The kernel-level forms are in
  `erights--elang-kernel--pattern-forms-and-helpers`.
---

## Abstract

The **Methods and Matchers** page defines the two kinds of **dispatchee** in E:
the elements that an object or class definition's dispatching context dispatches
to. Like functions, a method or matcher is a block of code with a **head** of
patterns and a **body** of one expression: the head patterns are matched against
the supplied data (the **specimen**), and if the match succeeds the body is
evaluated in the resulting scope. Unlike functions, methods and matchers are **not
first class**: they do not evaluate to a separately invocable object, they appear
only inside a dispatching context, and they are the things that context dispatches
to. A **method** has a name and a fixed parameter list and handles a specific
message verb; a **matcher** is the catch-all, matching any message (its head
pattern can bind the verb and the argument list). Methods appear in object or class
definitions; matchers appear there too and also inside `switch` expressions. This
head-pattern-plus-body shape is why parameter binding in E *is* pattern matching
(see `erights--elang-grammar-patterns--pattern-grammar`), and it is the ancestor of
the method definitions and the catch-all forwarding pattern in Endo's exo / Far
objects.

## Methods and matchers

- A **method** is a named dispatchee with a parameter pattern list and a body. It
  handles a particular message (verb plus arity). Methods appear in object and
  class definitions.
- A **matcher** is the unnamed catch-all dispatchee. Its head pattern can bind the
  incoming message's verb and argument list, so it handles any message the
  explicit methods did not. Matchers appear in object and class definitions and
  inside `switch` expressions.
- Both are non-first-class: a method or matcher is not a value that can be passed
  around and invoked on its own; it exists only within the dispatching context that
  dispatches to it.

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| method (named dispatchee) | a method on an exo / `Far` object |
| matcher (catch-all dispatchee) | the catch-all in a proxy / a forwarding handler |
| dispatching context | the object literal / exo behavior record |
| head patterns matched against the specimen | parameter destructuring as pattern match |
| `switch` matcher | a `match`-style dispatch over a pattern set |

## Source

Source: [elang/grammar/dispatchee.html](https://erights.github.io/erights-org-website/elang/grammar/dispatchee.html) (erights.org GitHub Pages mirror), content SHA-256 `56341a00677a`, last modified 1998-10-03.
