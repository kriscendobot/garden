---
title: Waterken and E as endpoints — two entangled dimensions of partition and persistence
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [persistence, capability-security, captp]
status: current
notes: Background framing for the Formula Persistence design. See [[endo--designs-dp--frame-and-position-in-design-space]] for the resulting position in the design space.
---

Distributed capability systems must choose along **two entangled
dimensions**:

1. How partition and revival are presented to application programs.
2. How state is persisted across restart and upgrade.

The dimensions are entangled — choices about partition visibility
constrain persistence strategy and vice versa — but they are not the
same axis. Formula Persistence is distinctive in making a *different*
choice along each.

## Endpoint A: Masked partition + orthogonal persistence (Waterken)

Tyler Close's **Waterken server** masks partition and revival from
application code. All loss of connectivity is treated as temporary; a
program never observes a broken reference and simply waits. Waterken
pairs Joe-E (a capability-safe Java subset) with a live crypto-cap
protocol in the CapTP family, and uses **orthogonal persistence** to
snapshot the heap and restart from that snapshot — possibly on a
different host — without the program's knowledge.

| | |
|---|---|
| **Advantages** | Simpler programming model (no defensive code against partition); determinism across communicating programs; transparent relocation |
| **Disadvantages** | Sacrifices availability — a single partitioned dependency stalls all dependents; entangled distributed heaps require **distributed garbage collection**; different participant incentives motivate market-based GC algorithms (Drexler & Miller 1988); upgrading programs in flight is difficult because the heap snapshot encodes assumptions an upgrade may violate |

## Endpoint B: Exposed partition per reference (E)

Mark Miller's **E** language exposes partition and revival at every
individual reference. A program is written so that any dereference or
message send to a potentially remote reference might fail; recovery
requires reconstructing the chain of computation that led to the
broken reference after partition heals.

| | |
|---|---|
| **Advantages** | Simpler runtime; does not sacrifice availability to Waterken's extent; no obligation to retain "offline capabilities" indefinitely (sturdyrefs and out-of-band URL-like references are necessarily weak references; sturdyrefs additionally enable *distributed confinement* without revealing cryptographic material to a multi-peer confined program) |
| **Disadvantages** | More complex programming model — every dependent computation must handle mid-process recovery defensively |

## The common substrate: URL-like references

Both models share the notion of a **URL or URL-like reference**
(sturdy reference, locator) that weakly retains a capability on a peer
and can be redeemed for a live reference.

- In the Waterken model, these references must be persisted
  **indefinitely**, or dependent distributed processes are silently
  corrupted (they wait forever for references that will never return).
- In E, sturdy references and locators are the basis for restoring
  connectivity after partition heals.

In both models, **petname systems are expected to be built on top of
these reference mechanisms.** Formula Persistence's distinctive move
is to invert this layering — petnames become the persistence root, and
the URL-like reference layer is derived from them (see
[[endo--designs-dp--formula-graph-and-cohort-destruction]]).
