---
title: "The Four Layers of When, Layer 4: Joining Multiple Resolutions"
source_kind: web
source_url: http://erights.org/elib/concurrency/when/joiners.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/joiners.html
source_fetched_via: mirror
source_content_sha256: 73d5b78c479529f72b63692948c3ae7a608cafffd70d9591c84e4fa056b3d2c9
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Child chapter (Layer 4) of the Four Layers of When sub-hub
  (erights--elib-concurrency-when-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The upstream page is an
  unwritten stub ("*** To be written"); this section records the layer's place in
  the four-layer map and its Endo lineage, not transcribed page prose. Layer 4 is
  joining several resolutions at once (the asynchAnd-style join), the ancestor of
  `Promise.all` and the eventual-send combinators. source_date is an era
  approximation matching the sibling concurrency chapters.
---

## Abstract

The top of E's **Four Layers of When**: **joining multiple resolutions**, the
construct that waits on **several** eventual references at once and reacts when they
have all settled (the `asynchAnd`-style join), rather than reacting to one
reference as the lower layers do. It composes the when-catch shorthand (Layer 3)
across a collection: register a reaction that fires once every member of a group of
promises is fulfilled (or once any breaks). This is the direct ancestor of
JavaScript's **`Promise.all`** (and the `Promise.allSettled` / `Promise.race`
family) and of the eventual-send combinators a program uses to fan out several
sends and rejoin their answers. The upstream chapter is an **unwritten stub** ("To
be written"); the value recorded here is the layer's place atop the progression and
its Endo mapping. Joining preserves the non-blocking guarantee of the lower layers:
the joined reaction runs in a later turn once the last constituent resolves, so the
vat never blocks waiting for the group.

## Chapter status

The page carries only its title and layer label ("Layer 4: Joining Multiple
Resolutions") followed by "\*\*\* To be written"; the prose was never filled in. It
is ingested for its place in the `when/index.html` sub-hub map (the highest of the
four layers) and for the idempotency anchor (content SHA-256 below). The conceptual
framing lives in the sibling map section
[four-layers-of-when-map](erights--elib-concurrency-when-index--four-layers-of-when-map.md);
the partial-ordering guarantees that make a deterministic join meaningful are in
[partial-order-on-references](erights--elib-concurrency-partial-order--partial-order-on-references.md).

## What this layer denotes

Joining is the **combinator** layer: given several eventual references, produce one
reaction (or one new promise) that settles as a function of all of them. The
canonical join is the conjunctive "when all of these are fulfilled" (`asynchAnd`),
but the family generalizes to "when any breaks" and "when the first settles." Its
contribution over Layer 3 is plurality: it lets a program fan out concurrent
eventual sends and cleanly rejoin their outcomes without nesting when-catch blocks
by hand.

## Translation to Endo

| E (Layer 4) | Endo / Hardened JavaScript |
|---|---|
| joining multiple resolutions (`asynchAnd`) | `Promise.all([...])` |
| "when all are fulfilled" | `Promise.all` resolving once every input fulfills |
| "when any breaks" | `Promise.all` rejecting on the first rejection (or `Promise.allSettled`) |
| "when the first settles" | `Promise.race([...])` |
| the joined reaction runs later | the combinator's result is a promise resolved in a later turn |

Source: [elib/concurrency/when/joiners.html](https://erights.github.io/erights-org-website/elib/concurrency/when/joiners.html) (canonical `http://erights.org/elib/concurrency/when/joiners.html`), an unwritten stub, content SHA-256 `73d5b78c479529f72b63692948c3ae7a608cafffd70d9591c84e4fa056b3d2c9`, fetched via the erights.org GitHub Pages mirror.
