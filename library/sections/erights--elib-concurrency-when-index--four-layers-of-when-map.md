---
title: "The Four Layers of When (chapter map)"
source_kind: web
source_url: http://erights.org/elib/concurrency/when/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/index.html
source_fetched_via: mirror
source_content_sha256: dcf52b12f6348edc08580427e9fa46e2f9607fd8efee7778fcad2a28d5ff487c
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Sub-hub map child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The chapter prose is a stub ("*** To be
  written"); this section captures the four-layer child map and the verified child
  hrefs. The four layers build up from references-as-observables to the when-catch
  syntactic shorthand (the direct ancestor of Endo's `E.when` / promise-reaction
  combinators) to joining multiple resolutions. The four child chapters are queued
  for ingest under scholar-ingest-erights-10. source_date is an era approximation
  matching the sibling concurrency chapters.
---

## Abstract

The sub-hub that organizes E's mechanism for turning semi-data-flow back into control
flow — **The Four Layers of When**, which arrange immediate reactions when an
eventual reference becomes fulfilled or broken. The chapter body is a stub ("To be
written"; it points readers, in the meantime, to a 2001 e-lang discussion of
when-layering). Its value is the **four-layer map**, building from the lowest-level
primitive up to the syntactic shorthand programmers actually use: (1) references as
observables, (2) the When* reactors, (3) the when-catch syntactic shorthand, and
(4) joining multiple resolutions. The when-catch layer is the **direct ancestor of
`@endo/eventual-send`'s `E.when` and the promise-reaction combinators** (and, more
broadly, of the JavaScript Promise `.then`). The four child chapters are ingested
separately (scholar-ingest-erights-10).

## The four layers (child map)

The chapter lists four layers, each its own child page (all verified reachable on the
erights.org GitHub Pages mirror, real titles, not 404s):

1. **References as Observables** — `when/ref-when.html` (title "1) References as
   Observables"). The lowest layer: observing the resolution of a reference. Content
   SHA-256 `d943520d3936...`.
2. **The When* Reactors** — `when/when-reactors.html` (title "2) The When* Reactors").
   The reactor objects that fire on resolution. Content SHA-256 `b39e64ddb55a...`.
3. **The when-catch Syntactic Shorthand** — `when/when-catch.html` (title "3) The
   when-catch Syntactic Shorthand"). The `when (...) -> { ... } catch ... { ... }`
   surface syntax; the direct ancestor of Endo's `E.when` and promise reactions.
   Content SHA-256 `6f664b3f644a...`.
4. **Joining Multiple Resolutions** — `when/joiners.html` (title "4) Joining Multiple
   Resolutions"). Waiting on several promises at once (the `asynchAnd`-style join).
   Content SHA-256 `73d5b78c4795...`.

## Translation to Endo

| E (Four Layers of When) | Endo / Hardened JavaScript |
|---|---|
| references as observables | observing a promise's settlement |
| When* reactors | the reaction objects a `HandledPromise` notifies on resolution |
| when-catch syntactic shorthand | `E.when(p, onFulfilled, onRejected)` / `p.then(...)` |
| joining multiple resolutions | `Promise.all` / combinators waiting on several promises |

Source: [elib/concurrency/when/index.html](https://erights.github.io/erights-org-website/elib/concurrency/when/index.html) (canonical `http://erights.org/elib/concurrency/when/index.html`), content SHA-256 `dcf52b12f6348edc08580427e9fa46e2f9607fd8efee7778fcad2a28d5ff487c`, fetched via the erights.org GitHub Pages mirror.
