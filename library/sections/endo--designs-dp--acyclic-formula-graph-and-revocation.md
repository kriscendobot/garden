---
title: Acyclic formula graph, heap-bloat mitigation, and timely revocation
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security, patterns]
status: current
---

## Graph structure and garbage collection

The formula graph and the ephemeral reference graph have
**complementary structural properties** — the design exploits this
complementarity deliberately:

| | Formula graph | Ephemeral reference graph |
|---|---|---|
| Topology | **Acyclic** | May be cyclic |
| Scope | Durable | Scoped to sessions |
| GC mechanism | **Simple local reference counting** | (Sessions bound it) |
| Distributed GC needed? | **No** | n/a |

The formula graph is acyclic *across peers* but admits **limited
cycles among certain co-formula groups** that must present unique,
unforgeable identifiers to the network while being constructed as
facets of a shared underlying capability:

- **Promise-and-resolver pairs**
- **Agent handle pairs**

These groups are treated as units for GC purposes; cycles inside a
group are permitted, cycles between groups are not.

The acyclicity gives Formula Persistence two large simplifications:

1. **No distributed garbage collection protocol** for the durable
   layer. Local reference counting suffices.
2. **No need for market-based distributed-GC mechanisms** to handle
   misaligned-incentive cycles (cf. Drexler & Miller 1988), because
   such cycles cannot exist in the durable graph.

## Mitigating heap bloat through the formula floor

Because formula-backed values can be reincarnated on demand, **the
ephemeral heap is never load-bearing for capability continuity.** If a
connected peer is imposing an undue burden by retaining ephemeral
state, the user can intervene:

- The user can force the offending worker to restart, discarding its
  ephemeral heap. Any formula-backed values reconstruct on demand.
- The OS can obligate a worker to restart as out-of-memory mitigation,
  with the same consequence.
- If neither suffices, the user can manually sever the offending peer.

Heap bloat in the ephemeral layer is mitigated by interventions **one
layer down**, in the formula graph. The formula graph provides the
**floor** from which the system can always recover.

## Timely revocation through local reachability

The acyclicity of the formula graph enables **timely destruction and
severance** of capabilities the user has revoked:

> *Once a reference is locally unreachable in the petname graph, the
> corresponding live reference can be made immediately unreachable
> and gracefully destroyed. All heaps that refer to it and all CapTP
> sessions that retain it can be terminated or severed. There is no
> need to wait for distributed garbage collection to propagate; the
> user agent controls local reachability and acts on it directly.*

This is a key UI affordance of the Endo Daemon, Chat, and Familiar
system. **The user agent gives the user a place to stand to locally
control reachability of local resources**, while still participating
in a distributed reference network.

> *The user does not need to trust the distributed system to honor
> revocation — revocation is enforced locally, at the persistence
> layer, before any distributed protocol is consulted.*

## Revocation by withdrawal of construction

Formula Persistence introduces a **fourth revocation mechanism**
distinct from the three already named in the literature (inline
caretakers, revocation lists, expiry):

> **Revocation by withdrawal of the constructor.**
>
> Removing or invalidating a formula withdraws the recipe for
> constructing the capability. This cascades into the disincarnation
> of the corresponding live reference and anything that depends upon
> it for its own construction.

| Mechanism | Distributed protocol? | Granularity | Immediacy |
|---|---|---|---|
| Inline caretaker | No (local) | Per-reference | Immediate, but requires the caretaker to remain alive |
| Revocation list | Yes (must propagate) | Per-key | Eventual |
| Expiry | No | Coarse-grained (time-based) | Deferred |
| **Withdrawal of constructor** | **No (local)** | **Per-cohort** | **Immediate** |

The mechanism is **immediate, local, and requires no distributed
protocol** — a stronger guarantee than caretakers (which must remain
alive), revocation lists (which must propagate), or expiry (which is
coarse-grained).

This pattern — *control reachability at the petname level; the rest
of the graph follows* — is a worked example of the same
**user-agency-at-the-graph-root** discipline that the OCapN-family
protocols rely on at the network boundary. See
[[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]] for
the cross-peer extension of the same retention discipline (the third
clause of local-GC reachability: "no peer's set in retentionEdges
contains it").
