---
title: "Event Loop Concurrency: the ELib reference chapter map"
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
  Primary erights.org ELib reference hub for Event Loop Concurrency (the deeper
  reference the elang concurrency tutorial's See-Also points at). This page is a
  navigation HUB: its body is a chapter map, not prose. Captured as a single map
  section so the named reference entry point resolves and its child chapters are
  enumerated for any later cycle. Reachable via the erights.org GitHub Pages
  mirror. source_date is an era approximation matching the sibling concurrency
  chapters.
---

## Abstract

The **Event Loop Concurrency** chapter under ELib is the *reference-level* (not
tutorial-level) treatment of E's concurrency model — the deeper document the
`elang/concurrency` tutorial hub's "See Also" points at, and the fullest informal
statement of the **vat / turn / pending-delivery-queue** model that became
`@endo/eventual-send` and Agoric's vat model. Like its tutorial sibling it is a
navigation **hub**: its body is a child-chapter map, not prose. The map names the
load-bearing chapters: *Why threads are evil*, *Event Loop Philosophy*
(the F. A. Hayek framing), *Semi-Transparency* (distributed programming is
different, but not too different), *The Vat* (a process-like, separately-failing
aggregate of objects), *Distributed Queuing* (message flow within and between
vats), *Reference Mechanics*, *Message Passing* (call-return vs the eventually-
operator), *Vat Turns* (atomic micro-transactions), *Partial Ordering* (just enough
distributed sequentiality), *The Four Layers of When* (References as Observables,
the When* Reactors, the when-catch syntactic shorthand, Joining Multiple
Resolutions), and *EIO* (non-blocking I/O — "you mean I can't block on a read?").
This section captures that map and the Endo translation; the substantive child
chapters are queued for a later cycle.

## The chapter map

**Deadlock-Free Distributed Consistency Maintenance** (the section's framing
goal). Concurrency Overview chapters, in the page's order:

- **Why threads are evil** — the motivating argument against shared-state /
  preemptive-thread concurrency.
- **Event Loop Philosophy** — "What would F. A. Hayek (the economist) say?" The
  decentralized-coordination framing of the event-loop model.
- **Semi-Transparency** — distributed programming is different, but not too
  different; the principled limits of location transparency (the same point Endo
  makes about `E()` working locally or remotely while not hiding partition).
- **The Vat** — a process-like aggregate of objects that **fails separately**: the
  unit of heap + single thread + delivery queue.
- **Distributed Queuing** — message flow within a vat and between vats.
- **Reference Mechanics** — "How do I designate thee? Let me count the ways" — the
  reference-state machinery (near / eventual / broken, live / sturdy).
- **Message Passing** — call-return (synchronous, near only) versus the
  **eventually operator** (asynchronous, any reference).
- **Vat Turns** — turns as **atomic micro-transactions**: run-to-completion
  delivery is the grain that eliminates intra-vat races.
- **Partial Ordering** — "just enough distributed sequentiality": the message-order
  guarantee E provides across vats.
- **The Four Layers of When:**
  - **References as Observables** — the bottom layer.
  - **The When* Reactors** — the reactor primitives.
  - **The when-catch Syntactic Shorthand** — the `when (p) -> {…} catch e {…}`
    sugar.
  - **Joining Multiple Resolutions** — fork/join over several promises (the
    reference-level treatment of the tutorial's `asynchAnd` / `race`).
- **EIO** — "You mean I can't block on a read? What kind of I/O library is that?"
  Non-blocking, capability-mediated I/O over the event loop.

The page closes by noting it "sets the ground for the next" section, distributed
programming.

## Why this matters for Endo (the model in one paragraph)

This is the reference statement of the model Endo carries forward: the **vat** is a
heap plus a single thread plus a queue of pending deliveries; a **turn** is the
run-to-completion delivery of one message, the atomic micro-transaction that
removes intra-vat data races; between vats the only communication is the
non-blocking **eventually-operator**, which returns a promise resolved in a later
turn and preserves a partial message order. `E(target).method(args)` is that send,
the promise is a `HandledPromise`, and a compartment / per-agent event-loop domain
plays the vat's role. The Four Layers of When are the ancestor of Endo's `E.when`
and the promise-combining patterns; EIO is the ancestor of capability-mediated,
never-blocking I/O.

## Translation (E to Endo)

| E term | Endo / Hardened JavaScript equivalent |
|---|---|
| vat | compartment / per-agent event-loop domain |
| vat turn (atomic micro-transaction) | one run-to-completion microtask-queue job |
| eventually-operator (`<-`) | `E(target).method(args)` |
| the When* reactors / when-catch | `E.when` / `.then` on a `HandledPromise` |
| Joining Multiple Resolutions | promise joins (`Promise.all` / settled joins) |
| Reference Mechanics (near/eventual/broken) | local presence / unsettled promise / rejected-or-severed |
| Partial Ordering | E-order message delivery guarantee |
| EIO (non-blocking I/O) | capability-mediated async I/O (never block a turn) |

## See also

- [erights--elang-concurrency-index--event-loop-concurrency-map](erights--elang-concurrency-index--event-loop-concurrency-map.md): the tutorial-level concurrency hub whose See-Also points here.
- [erights--elang-concurrency-epimenides--reference-states-and-data-lock](erights--elang-concurrency-epimenides--reference-states-and-data-lock.md): the near/eventual/broken reference states this reference's Reference Mechanics chapter develops.
- [erights--elang-concurrency-race--racing-joining-and-timeouts](erights--elang-concurrency-race--racing-joining-and-timeouts.md): the tutorial form of this reference's Joining Multiple Resolutions chapter.
- [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md): the 2005 paper formalizing the vat / turn / partial-order model this reference describes informally.

Source: [elib/concurrency/index.html](https://erights.org/elib/concurrency/index.html), fetched 2026-06-28 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elib/concurrency/index.html](https://erights.github.io/erights-org-website/elib/concurrency/index.html)), content SHA-256 `a116bef33730`.
