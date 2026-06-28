---
title: "The Four Layers of When, Layer 2: The When* Reactors"
source_kind: web
source_url: http://erights.org/elib/concurrency/when/when-reactors.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/when-reactors.html
source_fetched_via: mirror
source_content_sha256: b39e64ddb55a2d08b3db8a3cb20875c0988283d216e654de4e01397c9d400766
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Child chapter (Layer 2) of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The upstream page is an
  unwritten stub ("*** To be written"); this section records the layer's place in
  the four-layer map and its Endo lineage, not transcribed page prose. Layer 2 is
  the reactor objects that fire on the observed settlement Layer 1 exposes.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The second of E's **Four Layers of When**: the **When\* reactors**, the objects
that fire a reaction when an eventual reference (Layer 1's observable) settles.
Where Layer 1 is the bare ability to observe a settlement, Layer 2 packages the
reaction into reactor objects (the `whenResolved` / `whenBroken` family in E) that
the runtime notifies once the reference becomes fulfilled or broken. Layer 3's
when-catch syntax is sugar over registering these reactors, and Layer 4 composes
them across several references. The upstream chapter is an **unwritten stub** ("To
be written"); the value recorded here is the layer's position and its lineage to
`@endo/eventual-send`, where the reactor role is played by the resolved-callback
jobs a `HandledPromise` schedules on its resolution. In a vat, a reactor fires in a
**later turn** (never synchronously inside the turn that registered it), which is
the same micro-transaction discipline Endo's promise reactions inherit.

## Chapter status

The page carries only its title and layer label ("Layer 2: The When\* Reactors")
followed by "\*\*\* To be written"; the prose was never filled in. It is ingested
for its place in the `when/index.html` sub-hub map and for the idempotency anchor
(content SHA-256 below). The conceptual framing lives in the sibling map section
[four-layers-of-when-map](erights--elib-concurrency-when-index--four-layers-of-when-map.md);
the turn discipline the reactors obey is in
[turns-as-micro-transactions](erights--elib-concurrency-turns--turns-as-micro-transactions.md).

## What this layer denotes

A When\* reactor is the **callback object** a program registers to run when a
reference resolves. The name pattern (`whenResolved`, `whenBroken`, ...) selects
*which* settlement the reactor fires on. The reactor is the mechanism layer:
explicit, object-shaped, and composable, but more verbose than the when-catch
shorthand built on top of it. Crucially, the reaction is scheduled as its own turn,
so registering a reactor never blocks and never runs the reaction before the
current turn completes.

## Translation to Endo

| E (Layer 2) | Endo / Hardened JavaScript |
|---|---|
| When\* reactor | the resolved-callback the runtime notifies on a `HandledPromise`'s resolution |
| `whenResolved` / `whenBroken` | the fulfill / reject reactions registered on a promise |
| reactor fires in a later turn | the reaction runs as a microtask job, never synchronously |

Source: [elib/concurrency/when/when-reactors.html](https://erights.github.io/erights-org-website/elib/concurrency/when/when-reactors.html) (canonical `http://erights.org/elib/concurrency/when/when-reactors.html`), an unwritten stub, content SHA-256 `b39e64ddb55a2d08b3db8a3cb20875c0988283d216e654de4e01397c9d400766`, fetched via the erights.org GitHub Pages mirror.
