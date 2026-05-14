---
title: System fit — why a user agent needs this rather than orthogonal persistence
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security]
status: current
---

## What the Endo Daemon is, and what its persistence layer must do

The Endo Daemon is a **user agent for distributed capabilities**.
Capabilities pass to peers, bots, and applications with **the user's
informed consent and the right to timely revocation** of any reference
going forward. The persistence layer has three system-level
constraints driven by that role:

### 1. Ephemeral clients and fast convergence

Nodes — especially clients — go on and offline frequently. An
ephemeral client needs to **quickly recover** access to capabilities
it was previously granted. It cannot afford to:

- Replay a transcript of prior interactions, or
- Restore a heap snapshot containing large numbers of capabilities
  unrelated to the task at hand.

Formulas solve this directly: when a client restarts, the formula
graph describes how to reconstruct **exactly the capabilities the
client needs, and only those capabilities, without replaying history.**

### 2. Retaining policy without fatiguing the user

If a user has granted a capability in a previous incarnation, **that
grant should be honored in subsequent incarnations without
re-prompting.** Repeatedly asking the user to re-authorize previously-
granted capabilities — *"harassing the user"* — erodes trust and
makes the system unusable in practice.

Formula-based retention of policy enables this: the formula graph
encodes **not just how to reconstruct a capability but the fact that
it was authorized.** When an ephemeral session is re-established, the
system can re-derive the authorized capabilities from their formulas,
restoring the user's prior policy decisions without re-confirmation.

### 3. Revocation by withdrawal of construction

The mechanism is detailed in
[[endo--designs-dp--acyclic-formula-graph-and-revocation]] — what the
system fit adds is that this revocation form *requires* a model where
the formula is the durable artifact. In Waterken-style orthogonal
persistence, there is nothing to "withdraw" except the heap object,
and the heap object is opaque to the user agent.

## Why not orthogonal persistence?

The design rules out orthogonal persistence on three grounds:

### The upgrade problem dissolves the distinction

The obligation to manually persist important state is **shared** by
Formula Persistence and any orthogonally-persistent system that must
support upgrades. An upgrade may invalidate assumptions encoded in a
heap snapshot; the program must reconstruct its working state from
durable inputs afterward.

> *The orthogonal persistence machinery provides comfort during
> normal operation but does not eliminate the need for reconstruction
> logic. Formula Persistence accepts this reality as a starting point
> rather than discovering it as a consequence.*

### Instant restart

Because the formula graph encodes how to reconstruct **all**
capabilities, a node can restart instantly. There is no heap snapshot
to load, no replay log to process. Formulas are evaluated **lazily**
as capabilities are demanded.

### What is sacrificed

| | |
|---|---|
| **Determinism** | Reconstruction from formula may produce observably different results from one incarnation to the next (e.g., if a dependency's behavior has changed). |
| **Ephemeral state** | Heap state not captured in a formula or manually persisted is lost across incarnations. |

## Formula Persistence as a choice within Endo

Formula Persistence is **not intrinsic to Endo.** Endo provides a
shared model for passable values (data and capabilities), patterns,
and message passing. Other systems built on Endo make different
choices along the entangled dimensions:

- The choice of **CapTP** determines message ordering.
- The choice of a **Network** determines the range within which pass-
  invariant equality can be relied upon.
- The **Daemon** chooses Formula Persistence.

For example, the **Agoric chain** uses Endo components with
**orthogonal persistence** to ensure that all honest validators
produce the same deterministic computation, independent of whether
they crashed and restarted or simply continued. Formula Persistence is
a design choice particular to the *user agent*, where the priorities
are fast convergence, user agency over retention, and timely
revocation — not determinism across validators.

That said, **the Daemon can host a worker that is itself constrained
to determinism and keeps its own replay transcript.** The Daemon
serves as host for the purpose of connecting the worker to the broader
network and vending capabilities, without imposing its own persistence
model on the worker's internals.
