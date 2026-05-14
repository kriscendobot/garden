---
title: The 6/7 aspects of sharing and related work
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [capability-security, persistence, ocapn, captp]
status: current
---

## The Karp / Stiegler / Close 6/7 aspects of sharing

A capability system must support six aspects of sharing, illustrated
by a single scenario:

> Due to an emergency (**dynamic**), Bob asks Alice to have her son
> (**cross-domain**, **chained**) put Bob's car in Carol's garage
> (**composable**), all while being unable to open the car's trunk
> (**attenuated**) yet being held responsible for mishaps
> (**accountable**).
>
> — Karp, Stiegler, Close,
> *Not One Click for Security* (HP Labs, 2009)

Karp adds a seventh — **revocable** — for contexts where delegation
relationships are dynamic and long-lived.

| # | Aspect | What Formula Persistence contributes |
|---|---|---|
| 1 | **Dynamic** | The formula graph and petname database are mutable; formulas can be created and destroyed by the user agent without administrator intervention. *Persistence does not ossify sharing relationships; it records them in a form that can be revised.* |
| 2 | **Chained** | Formula dependencies encode chains of delegation. A formula can describe a capability derived from another capability, which is itself derived from another, without privileging any link in the chain. |
| 3 | **Cross-domain** | The coordinated retention mechanism enables peers with independent petname databases to maintain mirrored retention roots across administrative boundaries, synchronized as a CRDT when sessions are open (see [[endo--designs-dp--coordinated-retention-and-four-tables]]). |
| 4 | **Composable** | A formula can depend on multiple independent formulas from different grantors. A process can hold and combine references constructed from unrelated parts of the formula graph. |
| 5 | **Attenuated** | A formula can describe a capability that is a restricted facet of a dependency. The construction recipe can encode attenuation, ensuring the attenuated form is what gets reconstructed across incarnations. |
| 6 | **Accountable** | The petname graph provides a human-readable record of what was granted, to whom, and through what chain of dependencies. Because formulas encode their dependencies, the delegation structure is inspectable. |
| 7 | **Revocable** | **Revocation by withdrawal of the constructor** — immediate, local, no distributed protocol. Stronger than caretakers (which must remain alive), revocation lists (which must propagate), or expiry (which is coarse-grained). |

The design reads the 6/7 aspects as a *checklist a persistence
strategy must not impede.* Several of these aspects (especially #3
cross-domain, #6 accountable, and #7 revocable) are not just "not
impeded" by Formula Persistence — they have something **specific** to
gain from it.

## Related work

The design situates itself relative to five lineages.

### Waterken server (Tyler Close)

Java-based capability platform providing orthogonal persistence and
masked partition. Objects are made accessible via **web-keys** —
HTTPS URLs containing an unguessable cryptographic fragment that
serves as a transferable capability. Each distinct permission is
assigned a distinct web-key, enabling fine-grained delegation. The
`ref_send` API provides asynchronous messaging with orthogonal
persistence across network boundaries.

- Waterken server: <https://waterken.sourceforge.net/>
- Web-keys: <https://waterken.sourceforge.net/web-key/>

### E language and CapTP (Mark Miller)

Distributed, persistent, secure language for concurrent and
potentially malicious components on potentially malicious machines.
Introduces **CapTP** for distributed capability messaging, and defines
a hierarchy of reference types:

- **Live references** for immediate use,
- **Sturdy references** ("offline capabilities") for persistence
  across partition,
- **Locators** for re-establishing connectivity.

Partition and revival are exposed at the level of individual
references.

- E language: <https://erights.org/>
- CapTP: <https://erights.org/elib/distrib/captp/index.html>
- Robust Composition (Miller's dissertation, 2006):
  <http://papers.agoric.com/papers/robust-composition/abstract/>

### Concurrency Among Strangers (Miller, Van Cutsem, et al., 2005)

How E addresses concurrency + security by changing only a few
concepts of conventional sequential object programming. Internet-scale
environment with large latencies and partial failure is the same
environment Formula Persistence is designed for.

- <http://papers.agoric.com/papers/concurrency-among-strangers/abstract/>

### Market-based distributed garbage collection (Drexler & Miller, 1988)

Market-based mechanisms for computational resource management,
including a distributed GC algorithm able to collect unreferenced
loops that cross trust boundaries through decentralized market
negotiations. **Formula Persistence sidesteps this obligation by
keeping the formula graph acyclic and locally reference-counted.**

- Incentive Engineering for Computational Resource Management:
  <http://papers.agoric.com/papers/incentive-engineering-for-computational-resource-management/abstract/>
- Markets and Computation: Agoric Open Systems:
  <http://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/>

### Distributed Electronic Rights in JavaScript (Miller, Van Cutsem, Tulloh, 2013)

Extending JavaScript into a distributed, secure, persistent,
ubiquitous computational fabric — enabling mutually suspicious parties
to cooperate safely through the exchange of rights. **Ancestor of the
Endo/Agoric platform on which Formula Persistence is built.**

- <http://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/>

### Petname systems (Stiegler, 2005)

Three components:

- **Petnames** — self-assigned, human-readable, memorable names chosen
  by the user,
- **Nicknames** — human-readable names proposed by the named party,
  not necessarily unique or trustworthy,
- **Keys** — globally unique, cryptographically secure identifiers,
  not human-readable.

> *Formula Persistence places petnames at the root of the persistence
> system rather than layering them on top of an existing reference
> mechanism.*

- Petname Systems (Stiegler, 2005), HP Labs HPL-2005-148:
  <https://shiftleft.com/mirrors/www.hpl.hp.com/techreports/2005/HPL-2005-148.html>
- Petnames: A Humane Approach to Secure, Decentralized Naming
  (Lemmer-Webber, Miller, Larson, Sills, Yaacoby):
  <https://files.spritely.institute/papers/petnames.html>
