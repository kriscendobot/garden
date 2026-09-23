---
title: "The Four Layers of When, Layer 3: The when-catch Syntactic Shorthand"
source_kind: web
source_url: http://erights.org/elib/concurrency/when/when-catch.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/when-catch.html
source_fetched_via: mirror
source_content_sha256: 6f664b3f644a170182fb237e326e8aa5593ba95504a9857e00f4e2cc86ea8cf0
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Child chapter (Layer 3) of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The upstream page is an
  unwritten stub ("*** To be written"); this section records the layer's place in
  the four-layer map and its Endo lineage, not transcribed page prose. Layer 3 is
  the when-catch surface syntax — the DIRECT ANCESTOR of Endo's `E.when` and the
  promise-reaction combinators (and of JavaScript's `Promise.prototype.then`).
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The third of E's **Four Layers of When**, and the one programmers actually write:
the **when-catch syntactic shorthand**, E's `when (promiseExpr) -> reactor(value)
{ ... } catch problem { ... }` surface syntax. It sugars the registration of a
When\* reactor (Layer 2, itself built on the reference-as-observable primitive of
Layer 1) into a control-flow construct that reads like a try/catch over an eventual
value: the `when` arm runs in a later turn once the reference is **fulfilled**; the
`catch` arm runs if it **breaks**. This is the **direct ancestor of
`@endo/eventual-send`'s `E.when(target, onFulfilled, onRejected)` and the
promise-reaction combinators**, and more broadly of JavaScript's
`Promise.prototype.then(onFulfilled, onRejected)`: a fulfilled-or-broken reference
maps to a resolved-or-rejected promise, and the two arms map to the two reaction
callbacks. The upstream chapter is an **unwritten stub** ("To be written"); the
value recorded here is the layer's pivotal place in the lineage and its Endo
mapping. Because the reactions run as later turns, when-catch never blocks the vat:
it converts data-flow waiting back into ordinary control flow without giving up the
event loop's non-blocking guarantee.

## Chapter status

The page carries only its title and layer label ("Layer 3: The when-catch
Syntactic Shorthand") followed by "\*\*\* To be written"; the prose was never
filled in. It is ingested for its pivotal place in the `when/index.html` sub-hub
map (this is the layer Endo's whole promise-reaction surface descends from) and for
the idempotency anchor (content SHA-256 below). The conceptual framing lives in the
sibling map section
[four-layers-of-when-map](erights--elib-concurrency-when-index--four-layers-of-when-map.md);
the message-passing primitives the construct reacts to are in
[six-primitives-call-send-outcome](erights--elib-concurrency-msg-passing--six-primitives-call-send-outcome.md).

## What this layer denotes

The when-catch construct is the readable form of "react to this eventual reference":
a `when` block that binds the fulfilled value and a `catch` block that binds the
breaking problem. It is shorthand, expanding to a Layer 2 reactor registration; its
contribution is ergonomic, turning a verbose reactor object into a syntax that
mirrors synchronous try/catch while preserving the later-turn, non-blocking
semantics. This ergonomic move is exactly the one JavaScript later made with
`.then`/`.catch` and that Endo exposes as `E.when`.

## Translation to Endo

| E (Layer 3) | Endo / Hardened JavaScript |
|---|---|
| `when (p) -> ok(v) { ... } catch e { ... }` | `E.when(p, v => { ... }, e => { ... })` |
| the `when` (fulfilled) arm | the `onFulfilled` reaction / `.then(onFulfilled)` |
| the `catch` (broken) arm | the `onRejected` reaction / `.catch(onRejected)` |
| shorthand over a When\* reactor | `E.when` / `.then` as sugar over the resolution callback |
| never blocks the vat | the reaction runs as a microtask, the agent keeps turning |

Source: [elib/concurrency/when/when-catch.html](https://erights.github.io/erights-org-website/elib/concurrency/when/when-catch.html) (canonical `http://erights.org/elib/concurrency/when/when-catch.html`), an unwritten stub, content SHA-256 `6f664b3f644a170182fb237e326e8aa5593ba95504a9857e00f4e2cc86ea8cf0`, fetched via the erights.org GitHub Pages mirror.
