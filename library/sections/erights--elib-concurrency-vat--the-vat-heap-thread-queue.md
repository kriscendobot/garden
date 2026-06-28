---
title: "The Vat: heap + single thread + pending-delivery queue"
source_kind: web
source_url: http://erights.org/elib/concurrency/vat.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/vat.html
source_fetched_via: mirror
source_content_sha256: 841a8ccc68f9af47f58cbf8fea0ce094f9c8d5870bfa0e969bceb64cd992334f
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The canonical definition of the VAT — the
  process-like aggregate of objects that fails separately, executes one
  non-blocking event-loop turn at a time, and is the unit of the vat / turn /
  eventual-send model that became `@endo/eventual-send` and Agoric's vat model.
  source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

The chapter that defines the **vat**, E's unit of separate computation. A vat
bundles a single thread of control with an address space of synchronously
accessible objects, hosted on exactly one machine at any moment; a machine may host
many vats and a vat hosts many objects, but each object is hosted by exactly one
vat. Unlike a traditional OS process, a vat's thread is necessarily a **non-blocking
event loop servicing a queue of pending deliveries**: each pending delivery pairs a
message with a recipient, and each turn around the loop runs one delivery **to
completion** before the next (the synchronous computation serving a single pending
delivery is a **turn**). Within a vat is mostly-traditional sequential call-return
programming (Local-E); between vats there is only asynchronous non-blocking message
sending. This is the direct ancestor of Agoric's vat and of the
single-turn-to-completion discipline `@endo/eventual-send` enforces.

## What a vat is

E is a distributed programming language: the set of all machines executing Local-E
interpreters and hooked to the internet via the E Network Protocol (Pluribus)
jointly constitute the **Distributed E Virtual Machine**. Distribution requires
concurrency, and large-scale and secure distribution require loosely-coupled
asynchrony, so we need separate computational subworlds that proceed forward
simultaneously. In E that notion is the **Vat**.

In the reference diagrams, rounded rectangles are vats, circles and rectangles are
objects, thin arrows are references (capabilities), and the thick stubby arrow is a
message. **A machine may host many vats. At any moment a vat exists on only one
machine. A vat hosts many objects. Any given object is hosted by exactly one vat.**

The evolution of the object-to-object reference topology just follows the logic of
the abstract object/capability model, without regard to vat boundaries. Vat
boundaries show up elsewhere in the semantics to reflect the inescapable issues of
distributed systems: concurrency, asynchrony, several kinds of partial failure,
resource control, and decentralized administration. "One might almost say half of E
exists to allow the programmer to ignore the problems of distributed computation
where possible, and the other half exists to enable the programmer to deal with
those problems where necessary."

Vat boundaries enter the semantics through four mechanisms the chapter cross-links:

- **Reference Mechanics** explains the different kinds of live references (the
  different colors of thin arrows).
- **Message Passing** explains the ways one object can message another (the thick
  stubby arrow).
- **Handling Partial Failure** explains how SturdyRefs (the diamond-arrowhead
  arrow) maintain connectivity and recover consistency after the failures that can
  temporarily or permanently sever connections between vats.
- **Object Passing** explains the difference between PassByProxy objects (circles)
  and PassByConstruction / PassByCopy objects (rectangles): a Granovetter diagram
  passes a reference to a PassByProxy object (Carol), whereas the number `3` is
  PassByCopy, so passing a `3` from Alice to Bob gives Bob a NEAR (green) reference
  to a copy of the `3` in his own vat.

## One thread, one turn at a time

**Each vat executes concurrently with all other vats, but there is no concurrent
execution within a vat.** In this sense a vat is vaguely like a traditional OS
process: it bundles a single thread of control with an address space of
synchronously accessible data, avoiding the need for bug-prone fine-grained locking.
Unlike an OS process, **a vat's thread is necessarily a non-blocking event loop
servicing a queue of pending deliveries.**

Each **pending delivery** is a pair of a message and a recipient to whom it should
be delivered. Each time around the loop, the vat-thread extracts a pending delivery
from the queue and calls the recipient with the message; **this top-level call
executes to completion before the next pending delivery is processed.** The
synchronous computation performed in service of a single pending delivery is a
**turn**.

Within a vat is a mostly-traditional world of sequential call-return object
programming, called **Local-E**. Between vats there is only asynchronous
non-blocking message sending: a message transmitted between vats (its security
provided by E's cryptographic implementation of distributed capabilities) is, when
received, queued on the recipient vat's queue as a pending delivery of that message
to that recipient, processed in its own later turn.

## Why this matters for Endo

The vat is the single most important inherited abstraction. Agoric's "vat" is
named directly from this page, and Endo's agent / event-loop domain plays the same
role: heap + one thread + a queue of jobs. "Runs to completion before the next
pending delivery" is precisely JavaScript's run-to-completion job semantics that
`@endo/eventual-send` relies on: an `E(target).method()` enqueues a job (a pending
delivery) that runs as its own turn, and no two turns interleave. "No concurrent
execution within a vat" is why Endo needs no locks. PassByProxy vs PassByCopy is
the ancestor of Endo's marshal pass-styles (remotables passed by reference,
copyRecords/copyArrays passed by copy). SturdyRefs are the ancestor of OCapN's
persistent capability locators.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| vat | agent / event-loop domain / compartment |
| pending delivery | a queued job on the microtask / event-loop queue |
| turn (run-to-completion delivery) | a single job run to completion, no interleaving |
| Local-E (intra-vat call-return) | synchronous method calls within one agent |
| PassByProxy object | a remotable (`Far` / `Remotable`) passed by reference |
| PassByCopy object | a `CopyRecord` / `CopyArray` passed by copy via marshal |
| SturdyRef | a persistent OCapN capability locator |
| NEAR (green) reference | a local / resolved reference |

## Cross-references

- Parent hub: [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md).
- The stack-and-queue picture of a vat's pending work: [erights--elib-concurrency-queuing--the-stack-queue-L-and-eventual-send](erights--elib-concurrency-queuing--the-stack-queue-L-and-eventual-send.md).
- Why a vat is the unit of separate failure: [erights--elib-concurrency-semi-transparent--semi-transparent-networking](erights--elib-concurrency-semi-transparent--semi-transparent-networking.md).
- Formalized in the [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) paper section.

## Source

Source: [elib/concurrency/vat.html](https://erights.github.io/erights-org-website/elib/concurrency/vat.html) (mirror of `http://erights.org/elib/concurrency/vat.html`), last modified 1998-10-03 (era approximation), content SHA-256 `841a8ccc68f9af47f58cbf8fea0ce094f9c8d5870bfa0e969bceb64cd992334f`, fetched via the erights.org GitHub Pages mirror.
