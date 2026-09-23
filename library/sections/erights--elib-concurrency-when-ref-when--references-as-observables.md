---
title: "The Four Layers of When, Layer 1: References as Observables"
source_kind: web
source_url: http://erights.org/elib/concurrency/when/ref-when.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/ref-when.html
source_fetched_via: mirror
source_content_sha256: d943520d393636d27eb00518f8509ef1277fcd6562f17376f2a92dfabe96915f
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Child chapter (Layer 1) of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The upstream page is an
  unwritten stub ("*** To be written"); this section records the layer's place in
  the four-layer map and its Endo lineage, not transcribed page prose. Layer 1 is
  the lowest primitive: observing whether and how an eventual reference settles.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The lowest of E's **Four Layers of When** (the layering that turns
semi-data-flow back into control flow): treating an eventual reference as an
**observable** whose eventual settlement (it becomes fulfilled to a near or far
target, or breaks) can be watched. This is the primitive on which the higher
layers build: the When\* reactors (Layer 2) register on this observability, the
when-catch shorthand (Layer 3) sugars that registration, and joining (Layer 4)
composes several such observations. The upstream chapter is an **unwritten stub**
("To be written"); the value recorded here is the layer's position in the
four-layer progression and its lineage to `@endo/eventual-send`'s promise-settlement
observation. In Endo terms, this layer is the bare ability to observe that a
`HandledPromise` has resolved (or rejected) before deciding what reaction to run.

## Chapter status

The page carries only its title and layer label ("Layer 1: References as
Observables") followed by "\*\*\* To be written"; Mark Miller's authoritative ELib
draft never filled in the prose. It is ingested for its place in the map (the
`when/index.html` sub-hub lists it as the first of four layers) and for the
idempotency anchor (content SHA-256 below), so a later cycle can detect if the
chapter is ever written. The conceptual content lives in the sibling map section
[four-layers-of-when-map](erights--elib-concurrency-when-index--four-layers-of-when-map.md)
and, for the underlying reference-settlement model, in
[reference-kinds-near-eventual-broken-promise-far-sturdyref](erights--elib-concurrency-refmech--reference-kinds-near-eventual-broken-promise-far-sturdyref.md).

## What this layer denotes

"References as observables" is the idea that an eventual reference is not just a
thing you send messages to but a thing whose **resolution you can observe**. The
reference mechanics chapter establishes that a Promise is Unsettled (not yet known
to designate an object) and may become Fulfilled (Near or Far) or Broken; this
layer is the act of registering interest in *which* of those outcomes occurs and
*when*. Everything above it (reactors, when-catch, joiners) is a more convenient
way to express a reaction to that observed settlement.

## Translation to Endo

| E (Layer 1) | Endo / Hardened JavaScript |
|---|---|
| reference as observable | a `HandledPromise` whose settlement can be observed |
| observing settlement (fulfilled / broken) | a promise resolving (fulfilled) or rejecting |
| the primitive under When\* reactors | the resolution hook a promise reaction is registered against |

Source: [elib/concurrency/when/ref-when.html](https://erights.github.io/erights-org-website/elib/concurrency/when/ref-when.html) (canonical `http://erights.org/elib/concurrency/when/ref-when.html`), an unwritten stub, content SHA-256 `d943520d393636d27eb00518f8509ef1277fcd6562f17376f2a92dfabe96915f`, fetched via the erights.org GitHub Pages mirror.
