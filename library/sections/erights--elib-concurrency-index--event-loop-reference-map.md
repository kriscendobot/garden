---
title: "Event Loop Concurrency (ELib): the reference-level chapter map"
source_kind: web
source_url: http://erights.org/elib/concurrency/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/index.html
source_fetched_via: mirror
source_content_sha256: a116bef33730f9b86bfd29814c1d63c49dc13ace30f0982198ad7460dea5fe57
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [eventual-send, e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. This is the
  reference-level (not tutorial-level) Event Loop Concurrency hub under `elib/`,
  the deeper treatment the elang concurrency tutorial's "See Also" points at. The
  hub page itself is a child-chapter map with no prose body; this section captures
  that map plus the vat / turn / eventual-send model and the Endo translation. As of
  scholar-ingest-erights-9 all four single-page mechanics chapters (Reference
  Mechanics, Message Passing, Vat Turns, Partial Ordering) and both sub-hub maps (the
  Four Layers of When, EIO) are ingested; only the six sub-hub child chapters remain
  queued (scholar-ingest-erights-10). source_date is an era approximation matching
  the sibling concurrency chapters.
---

## Abstract

The **Event Loop Concurrency** chapter under ELib is the **reference-level**
treatment of E's concurrency model — the fullest informal statement of the vat /
turn / pending-delivery-queue model that became `@endo/eventual-send` and Agoric's
vat model. It is the deeper companion the tutorial-level *Concurrency in E* hub
points at via "See Also." The hub page carries no prose body of its own; it is a
reading map to a sequence of child chapters. This section captures that map, the
one-paragraph statement of the model, and the Endo translation; the child chapters
themselves are ingested as their own sections (only the two sub-hubs' own child
chapters remain queued).

## The chapter map

The hub's tagline frames the section as **Deadlock-Free Distributed Consistency
Maintenance**. Its child chapters:

- **Concurrency Overview** (`overview.html`) — "Why threads are evil." (ingested: [why-threads-are-evil](erights--elib-concurrency-overview--why-threads-are-evil.md))
- **Event Loop Philosophy** (`event-loop.html`) — what would F.A. Hayek (the
  economist) say? (ingested: [plan-interference-and-deadlock-freedom](erights--elib-concurrency-event-loop--plan-interference-and-deadlock-freedom.md))
- **Semi-Transparency** (`semi-transparent.html`) — distributed programming is
  different, but not too different. (ingested: [semi-transparent-networking](erights--elib-concurrency-semi-transparent--semi-transparent-networking.md))
- **The Vat** (`vat.html`) — the process-like aggregate of objects that fails
  separately. (ingested: [the-vat-heap-thread-queue](erights--elib-concurrency-vat--the-vat-heap-thread-queue.md))
- **Distributed Queuing** (`queuing.html`) — message-flow within and between vats.
  (ingested: [the-stack-queue-L-and-eventual-send](erights--elib-concurrency-queuing--the-stack-queue-L-and-eventual-send.md))
- **Reference Mechanics** (`refmech.html`) — "how do I designate thee? Let me
  count the ways." (ingested: [reference-kinds-near-eventual-broken-promise-far-sturdyref](erights--elib-concurrency-refmech--reference-kinds-near-eventual-broken-promise-far-sturdyref.md))
- **Message Passing** (`msg-passing.html`) — call-return and the eventually
  operator. (ingested: [six-primitives-call-send-outcome](erights--elib-concurrency-msg-passing--six-primitives-call-send-outcome.md))
- **Vat Turns** (`turns.html`) — atomic micro-transactions. (ingested: [turns-as-micro-transactions](erights--elib-concurrency-turns--turns-as-micro-transactions.md))
- **Partial Ordering** (`partial-order.html`) — just enough distributed
  sequentiality. (ingested: [partial-order-on-references](erights--elib-concurrency-partial-order--partial-order-on-references.md))
- **The Four Layers of When** (`when/index.html`) — References as Observables, the
  When\* Reactors, the when-catch syntactic shorthand, and Joining Multiple
  Resolutions. (ingested map: [four-layers-of-when-map](erights--elib-concurrency-when-index--four-layers-of-when-map.md); the four child chapters queued for scholar-ingest-erights-10)
- **EIO** (`eio/index.html`) — "you mean I can't block on a read?" non-blocking
  I/O. (ingested map: [eio-non-blocking-io-map](erights--elib-concurrency-eio-index--eio-non-blocking-io-map.md); the two content children queued for scholar-ingest-erights-10)

The hub closes by noting that, besides local concurrency, this section sets the
ground for the next one — **distributed programming** (`../distrib/index.html`).

## Why this matters for Endo (the model in one paragraph)

E's concurrency unit is the **vat**: a heap plus a single thread plus a queue of
pending deliveries. Within a vat, delivery is run-to-completion per **turn**
(an atomic micro-transaction), so there are no interleaving data races; between
vats, the only communication is **eventual-send**, which never blocks and returns
a **promise** that resolves in a later turn. This is exactly the model Endo
carries forward: `E(target).method(args)` is the eventual-send, the promise is a
`HandledPromise`, a turn is a single resolved-callback job on the microtask queue,
and a compartment / per-agent event-loop domain plays the vat's role. The
"deadlock-free" property in the chapter's tagline is the same one Endo inherits —
because a vat never blocks, a circular *data* dependency surfaces as a
never-resolving promise (data-lock) rather than a wedged process.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| vat | compartment / per-agent event-loop domain |
| eventual-send (`<-`) | `E(target).method(args)` |
| promise / vow | `HandledPromise` / `makePromiseKit()` |
| turn (run-to-completion delivery) | a single resolved-callback job on the microtask queue |
| the Four Layers of When | promise reaction / `E.when` and combinators |
| EIO (non-blocking I/O) | async I/O over promises; no blocking reads |

## Cross-references

- Tutorial-level entry point: [erights--elang-concurrency-index--event-loop-concurrency-map](erights--elang-concurrency-index--event-loop-concurrency-map.md)
  — the *Concurrency in E* informal-introduction hub whose "See Also" points here.
- The vat / turn / promise-pipelining model is formalized in the already-ingested
  [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md)
  paper section.

## Source

Source: [elib/concurrency/index.html](https://erights.github.io/erights-org-website/elib/concurrency/index.html) (mirror of `http://erights.org/elib/concurrency/index.html`), last modified 1998-10-03, content SHA-256 `a116bef33730f9b86bfd29814c1d63c49dc13ace30f0982198ad7460dea5fe57`, fetched via the erights.org GitHub Pages mirror.
