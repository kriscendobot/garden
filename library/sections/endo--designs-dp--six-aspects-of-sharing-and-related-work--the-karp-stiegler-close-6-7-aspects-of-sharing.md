---
title: The Karp / Stiegler / Close 6/7 aspects of sharing
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
parent: endo--designs-dp--six-aspects-of-sharing-and-related-work
---

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
