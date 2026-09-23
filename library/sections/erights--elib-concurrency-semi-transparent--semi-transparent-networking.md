---
title: "Semi-Transparency: distributed programming is different, but not too different"
source_kind: web
source_url: http://erights.org/elib/concurrency/semi-transparent.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/semi-transparent.html
source_fetched_via: mirror
source_content_sha256: 262a7e4ca284f3741d2856acb9a4bd9fef07157e44e33409f57a5c3836f3a1a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). Why E gives up on FULL network transparency
  and chooses SEMI-transparency instead: the distributed semantics are a subset
  of the local semantics, never the reverse. The direct rationale for why Endo's
  `E()` is always available locally but only `E()` (never synchronous `.`) works
  across the network. source_date is an era approximation matching the sibling
  concurrency chapters.
---

## Abstract

The chapter that explains E's most consequential design choice: **semi-transparent
networking**. Fully-transparent systems (Actors, Concurrent Logic / Constraint
Programming, Vulcan, Joule) promise that any correct local program stays correct
distributed *and vice versa*, which forces the model to include only features
adequately supportable in both contexts. E rejects full transparency for the same
reason Waldo's *A Note on Distributed Computing* gives (the local-only features are
too cheap and useful to surrender), but keeps half the benefit: **any correct
program written for distributed objects stays correct when those objects are thrown
together in one address space.** The distributed semantics are a *subset* of the
local semantics; "vat" plays the role of "address space." The chapter then
enumerates the five axes (synchrony, latency, concurrency/mutual-exclusion,
atomicity, partial failure, temporal inconsistency) on which local call-return and
distributed eventual-send differ. This is the direct ancestor of Endo's rule that
synchronous calls work only intra-agent while `E()` works everywhere.

## Full transparency and why E gives it up

There have been many attempts at **fully transparent** network programming, several
of them E's ancestors (Actors, Concurrent Logic Programming, Concurrent Constraint
Programming, Vulcan, Joule). *Fully transparent* means any correct program written
for objects co-existing in a single address space stays correct when those objects
are distributed over a network, **and** any correct program written for distributed
objects stays correct when they are thrown together in the same address space. The
computational model of a fully transparent system must include only features
adequately supportable in *both* contexts.

Carl Hewitt's *The Challenge of Open Systems* explains the constraints of large-
scale mutually-suspicious radically-distributed systems; Kahn and Miller's
*Language Design and Open Systems* explains designing fully transparent languages
that satisfy Hewitt's constraints. (At erights.org, "distributed computation"
means the radical distribution of Hewitt's Open Systems unless stated otherwise.)

Waldo, Wollrath, Wyant, and Kendall's *A Note on Distributed Computing* argues, in
effect, that the cost of these restrictions is too high for general-purpose
distributed computing. E disagrees with many of the paper's particular arguments
and finds its conclusions phrased too strongly, but **gives up on full transparency
for the same core reason**: there are compellingly useful features of local
(single-machine, single-address-space) computation that are not naturally available
for distributed computation. They are too expensive to surrender locally where they
are cheap, and impossible or prohibitively expensive to support in the distributed
case. To support them in both, one must introduce a semantic non-uniformity.

## Semi-transparency: distributed semantics as a subset of local

We can give up full transparency without giving up all the benefits of
transparency. **Semi-transparent network programming** keeps the second half of
the definition: *any correct program written for objects distributed over the
network will remain correct when those objects are thrown together in the same
address space.* This implies the semantics available in the distributed case are a
**subset** of the semantics available locally. E is semi-transparent, and "vat"
serves the role of "address space."

## Local call-return vs distributed eventual-send (the cost axes)

The most compelling cost difference between intra-vat and distributed programming
concerns synchrony, latency, concurrency, atomicity, and reliability. Among objects
**in the same vat**, familiar synchronous sequential call-return (the caller waits
for the callee to return) has these attributes:

- **Synchrony** makes efficient use of the CPU (it can only do one thing at a time
  anyway).
- **Adds little latency** (both objects are about equally "close" to the CPU).
- **Cheap atomicity** by disallowing other threads in the same address space (cheap
  again, since the CPU does one thing at a time) and disallowing synchronous
  inter-vat communication.
- **Avoids partial-failure handling**: a hardware failure cannot make some objects
  in an address space fail without making them all fail, so the caller need not be
  prepared to react to the callee's disappearance (any disaster that kills the
  callee kills the caller too, and vice versa).
- **Avoids temporal inconsistency**: no hardware failure can sever the
  caller-callee reference without killing both, so they are always in contact when
  they should be and can safely make coordinated state changes.

By contrast, **distributed** inter-object invocation should be based on
asynchronous, one-way, non-fully-reliable, pipelined messages:

- **Asynchrony**: the sender sends and continues without waiting for a reply,
  letting both processors proceed in parallel. Time between vats is a **partial
  causal order**, the inter-vat messages being the causality links; the computation
  is equivalent to any full order consistent with that partial order.
- **Latency**: pipes can be made wider but not shorter (technology gives more
  bandwidth but may never repeal the speed of light), so round trips must be
  minimized. E's **promise pipelining** lets computation "use" the results of
  previous remote messages before those results come back.
- **Mutual exclusion**: inter-machine mutual exclusion is very expensive (under
  mutual suspicion, often prohibitively so), while intra-vat mutual exclusion is
  free; distributed patterns should exploit this asymmetry.
- **Partial failure**: communication lines can partition, and machines can fail
  transiently (rolling back to a stable state) or permanently (objects forever
  inaccessible); from outside it is generally impossible to tell which. The system
  must continue smoothly, with surviving parts providing value while others are
  inaccessible.
- **Temporal inconsistency**: once parts of an app function despite the
  inaccessibility of other parts, they proceed and change state while out of
  contact, conflicting with the consistency strategies distributed-systems
  designers normally advocate.

## Why this matters for Endo

Semi-transparency is the law Endo lives by. A synchronous method call (`obj.foo()`)
works only between objects in the same agent / event-loop domain (E's "vat"),
exactly as E restricts the synchronous `.`; **`E(obj).foo()`** is the
always-available eventual-send that works whether `obj` is local or remote, exactly
as E's `<-` is the only inter-vat operator. Because the distributed semantics are a
subset of the local semantics, code written against `E()` runs unchanged whether
the target is co-located or across an OCapN connection: you can always collapse a
distributed program into one address space, never the reverse. Promise pipelining,
called out here as the answer to latency, is the same `HandledPromise` pipelining
Endo carries forward.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| vat (= "address space") | agent / event-loop domain / compartment |
| synchronous call-return (`.`) | a synchronous method call, valid only intra-agent |
| eventual-send (`<-`) | `E(target).method(args)`, valid local or remote |
| promise pipelining | `HandledPromise` pipelining over `E()` |
| partial causal order between vats | OCapN message causality / promise resolution order |
| semi-transparency | distributed semantics are a subset of local semantics |

## Cross-references

- Parent hub: [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md).
- The vat as the unit of separate failure: [erights--elib-concurrency-vat--the-vat-heap-thread-queue](erights--elib-concurrency-vat--the-vat-heap-thread-queue.md).
- Promise pipelining and the eventually operator are formalized in the
  [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md)
  paper section.

## Source

Source: [elib/concurrency/semi-transparent.html](https://erights.github.io/erights-org-website/elib/concurrency/semi-transparent.html) (mirror of `http://erights.org/elib/concurrency/semi-transparent.html`), last modified 1998-10-03 (era approximation), content SHA-256 `262a7e4ca284f3741d2856acb9a4bd9fef07157e44e33409f57a5c3836f3a1a4`, fetched via the erights.org GitHub Pages mirror.
