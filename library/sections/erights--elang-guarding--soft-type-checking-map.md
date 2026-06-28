---
title: "Soft Type Checking: E guards (chapter map)"
source_kind: web
source_url: http://erights.org/elang/guarding/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/guarding/index.html
source_fetched_via: mirror
source_content_sha256: 74a0c3241c12796e66013238ae027f6d5baaddb95ef2ab4559d57cc90acf2c2b
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, pass-style]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. A thin navigation
  HUB ("Soft Type Checking"): its own body is only a reading map to two child
  chapters (Guarding Asynchrony, Guard Expression Style), not prose. Captured as
  a map section so the named guards entry point resolves; the child chapters are
  queued in scholar-ingest-erights-3. E guards are the direct ancestor of Endo /
  `@endo/patterns` guards and the marshal `M.interface` method guards.
---

## Abstract

The **Soft Type Checking** chapter is E's guards entry point — the hub for E's
**guard** mechanism, a runtime coercion-and-validation discipline that is the
direct ancestor of Endo's `@endo/patterns` guards and the `M.interface(...)`
method guards used by exo classes. The hub page carries no prose body; it is a
reading map to two child chapters (Guarding Asynchrony, Guard Expression Style).
This section captures that map and the Endo lineage; the child chapters are
queued. "Soft" type checking means guards are values applied at runtime to coerce
or reject, not a static type system — the same stance Endo takes.

## What an E guard is (the one-paragraph model)

A **guard** in E is an object that sits between a value and its use and either
**coerces** the value into a guaranteed shape or **rejects** it. Guards appear in
two surface positions familiar from the quick-reference card and the block
chapter: on a definition pattern (`def x :Guard := expr`) and on a function /
method's return position (`def name(patterns) :Guard { … }`). Because a guard is
itself an ordinary object, guards compose and are first-class — the property Endo
inherits when it makes patterns/guards values that `M.interface` consumes. This
is *soft* type checking: enforcement happens at runtime at the guard's coercion
point, giving the defensive-programming guarantee an object needs to validate the
messages it receives from mutually-suspicious callers without a static type
checker.

## The chapter map

- **Guarding Asynchrony** (`guarding/async.html`) — how guards interact with
  eventual references and promises (a guard cannot synchronously coerce a value
  that has not yet resolved). (queued)
- **Guard Expression Style** (`guarding/style.html`) — idioms and conventions
  for writing and composing guard expressions. (queued)

## Lineage to Endo

| E guard concept | Endo / Hardened JavaScript descendant |
|---|---|
| guard (coerce-or-reject object) | a *pattern* / *guard* in `@endo/patterns` |
| `:Guard` on a pattern / return | `M.xxx(...)` shape in an interface guard |
| soft (runtime) type checking | `mustMatch` / `matches` runtime validation |
| method guard on object behavior | `M.interface(label, { method: M.call(...).returns(...) })` |

The Endo-side practice is documented in the marshal / patterns library topics;
this chapter is the historical root, where the coerce-or-reject guard object
first appears as a language feature.

## Source

Source: [elang/guarding/index.html](https://erights.github.io/erights-org-website/elang/guarding/index.html) (mirror of `http://erights.org/elang/guarding/index.html`), last modified 1998-10-03, content SHA-256 `74a0c3241c12796e66013238ae027f6d5baaddb95ef2ab4559d57cc90acf2c2b`, fetched via the erights.org GitHub Pages mirror.
