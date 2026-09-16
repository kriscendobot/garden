---
title: "Confinement: the SW model, E's observable immutability, and keybits without revealing keys"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2000-July/
source_snapshot: http://web.archive.org/web/20130603012702id_/http://www.eros-os.org/pipermail/cap-talk/2000-July.txt.gz
source_content_sha256: 52cc13f4e94b1cfc1ffd047f9bdf8742c8f66c9a0b0f35b1e9b03c04c88b0924
source_authors: [Jonathan S. Shapiro, Mark S. Miller]
source_date: 2000-07-16
thread_subject: "Capbility Concepts"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A sub-argument of the July 2000 "Capability Concepts" thread in which Shapiro and Miller compare how EROS/KeyKOS and E each achieve **confinement** (the property that a freshly instantiated subsystem holds no authority its instantiator did not grant). Shapiro's Shapiro-Weber ("SW") model, published at the 2000 IEEE Security and Privacy symposium, is offered as covering "all capability systems that can enforce confinement, and excludes all the ones that cannot." Miller counters with E, which confines "without relying on dynamic kernel-weakening of primitive capabilities," instead using **observable pure immutability** (a factory stage documented at erights.org). Shapiro concedes E satisfies the SW model but that the published proof would need extension. The thread's most reusable idea is Miller's: a service can use "keybits" (capability-identity bits) internally without ever revealing them, so an equality-testing operation and a primitive hash table can serve clients deterministically while remaining safe for computation that must be deterministically replayable.

## The SW model as the confinement yardstick

Shapiro on Mungi (a single-address-space capability OS): if it uses "a per-process or per-system XOR value" or a similar unforgeable transform, then it can confine, and no separate confinement proof is needed. It suffices to "do an equivalence proof between XOR application and capability/data partitioning ... then you fall under the SW model proof." The published model is at `http://www.eros-os.org/papers/oakland2000.ps`. Shapiro: "the SW proof only requires that users cannot invoke capabilities as data. It is not compromised if the user can observe the capability bits ... the SW model covers all capability systems (including Mungi) that can enforce confinement, and excludes all the ones that cannot."

## E confines by observable pure immutability, not kernel weakening

Miller: "E can do confinement without relying on dynamic kernel-weakening of primitive capabilities. Rather, E uses observable pure immutability, corresponding to stage #2 of the factory page. As a result, E's confinement has the costs documented at that URL." He poses the challenge: "The mechanisms of the SW model seem to apply starting at stage #3 ... would you say the SW model covers E? Would you claim that E's confinement is not really confinement as you define it? If no and yes, then E is a counterexample."

Shapiro's concession: "I believe the answer is that E satisfies the SW model, and that the SW proof applies but is incomplete. The SW factory test permits sensory capabilities and purely read-only data capabilities. E has no sensory capabilities, which means that the SW model is strictly more powerful than E and E is therefore covered." He notes the proof would need to handle capabilities "held exclusively by the yield" and a trusted deep copy at instantiation, plus a termination hazard: a developer who "dicks around with the structure maliciously and continuously" could make the deep copy non-terminating, resolved by an additional deep copy at factory-creation time.

## Keybits without revealing the keys

Norm Hardy's objection to deep-copy-with-identity-preservation is that it "requires a widely available keybits equivalent in order to perform the necessary identity tests," which is dangerous to expose. Miller's resolution: "a keybits-equivalent that is equivalent enough for the above purposes still need not reveal the bits in the keys, and can therefore be used safely by those that must not have such access, such as computation constrained to be deterministically replayable. E primitively provides an equality testing operation (the moral equivalent of the equality-testing aspect of DISCRIM), and a primitive hash table. The hash table uses but does not reveal the bits of the keys." The price of determinism: "the table's enumeration order depends on order of entry and removal, not hash order." Miller clarifies "primitive" need not mean kernel-provided: for EROS he would want the hashtable to be "a widely exported service provided by the TCB ... on its honor to provide deterministic service to its clients despite its non-deterministic (keybits-based) implementation."

## Translation

| cap-talk 2000 term | Endo / modern reading |
|---|---|
| SW model / Shapiro-Weber factory | formal confinement model for capability OSes (KeyKOS/EROS factory) |
| observable pure immutability | frozen, transitively-immutable objects (SES `harden`) as the confinement lever |
| factory (E stages) | the object-capability confinement construct; Endo's caretaker/factory lineage |
| keybits / DISCRIM | capability-identity bits; the equality primitive (see [reference sameness](../sections/web--miller-equality-reference-sameness--overview.md)) |
| deterministic replay | a computation whose output cannot depend on covert properties (hash order), a precondition for orthogonal persistence |

Source: [cap-talk 2000-July archive](http://www.eros-os.org/pipermail/cap-talk/2000-July/) (Internet Archive original-bytes snapshot `web/20130603012702id_/.../2000-July.txt.gz`, sha256 `52cc13f4`), messages by Jonathan S. Shapiro and Mark S. Miller, 2000-07-16 to 2000-07-23.
