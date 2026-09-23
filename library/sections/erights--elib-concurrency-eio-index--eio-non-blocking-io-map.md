---
title: "EIO: E's non-blocking I/O library (chapter map)"
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/index.html
source_fetched_via: mirror
source_content_sha256: 9a12b0cb39d16f0d7430f4b368629a627250a67616f905af21ab2aa045b1085b
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Sub-hub map child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). EIO is E's non-blocking I/O library ("you mean
  I can't block on a read?"): since a turn cannot block, I/O is requested by send and
  delivered by notification, the InStream/OutStream model. This section captures the
  chapter map and the verified ingestable child hrefs (Design Goals, Obtaining
  elements from an InStream); the API entry is external javadoc. The two content
  children are now ingested as their own sections (scholar-ingest-erights-10).
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The sub-hub for **EIO**, E's non-blocking I/O library — the answer to "you mean I
can't block on a read?" Because a vat turn runs to completion and an object cannot
stop executing even on I/O (see the message-passing chapter), blocking reads are
impossible; instead I/O is **requested by sending** and its results **delivered by
notification** to a designated object, over a stream abstraction (InStream /
OutStream). The current EIO design is credited mostly to **E. Dean Tribble** and
**Mark Miller**, with contributions from Chip Morningstar, Norm Hardy, Dan Bornstein,
Zooko, and Constantine Plotnikov; the page notes the design "has been thrown out and
redone several times." This section captures the chapter map and its verified child
hrefs; the two content children are now ingested as their own sections
(scholar-ingest-erights-10).

## Chapter map (children)

The EIO hub maps these children (the two content pages now ingested as their own
sections; the API entry is external javadoc and is not ingestable):

1. **Design Goals** — `eio/goals.html` (title "EIO Design Goals"). What requirements
   and preferences shaped EIO's design. Content SHA-256 `b8492e10dce4...`, ~22 KB.
   (ingested: [design-goals-requirements-and-preferences](erights--elib-concurrency-eio-goals--design-goals-requirements-and-preferences.md))
2. **API** — the javadoc-umentation of the EIO package (external javadoc, not an
   ingestable HTML chapter).
3. **Obtaining elements from an InStream** — `eio/obtaining.html` (title "Obtaining
   Elements from an InStream"). Further documentation on the InStream API. Content
   SHA-256 `5ffca11a5097...`, ~26 KB. (ingested: [obtain-primitive-and-input-operation-taxonomy](erights--elib-concurrency-eio-obtaining--obtain-primitive-and-input-operation-taxonomy.md))

The page also points at a live discussion of the API on the E Language Wiki.

## Translation to Endo

| E (EIO) | Endo / Hardened JavaScript |
|---|---|
| non-blocking I/O by send + notification | async I/O surfaced as promises / async iterators |
| InStream / OutStream | `@endo/stream` reader/writer async-iterator streams |
| "can't block on a read" | the event-loop turn never blocks; reads return promises |

Source: [elib/concurrency/eio/index.html](https://erights.github.io/erights-org-website/elib/concurrency/eio/index.html) (canonical `http://erights.org/elib/concurrency/eio/index.html`), content SHA-256 `9a12b0cb39d16f0d7430f4b368629a627250a67616f905af21ab2aa045b1085b`, fetched via the erights.org GitHub Pages mirror.
