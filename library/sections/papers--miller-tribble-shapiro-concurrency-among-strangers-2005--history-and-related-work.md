---
title: History and Related Work (Smalltalk → Actors → Vulcan → Joule → Original-E → E; Web-Calculus, Oz-E, Twisted Python)
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_paper_pages: "221-227 (§11 History, §12 Related Work)"
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory]
status: current
---

## Abstract

The paper's history and related-work coda traces E's design lineage through five precursor languages — Smalltalk, Actors, Vulcan, Joule, Original-E — and surveys contemporary distributed-programming systems that share parts of E's model. The lineage is not just citation tracking: each precursor contributed *one specific abstraction* that survived into E, and the §11 narrative names which. Smalltalk gave object references and message passing as the substrate; Actors added asynchronous-only message delivery and the data-flow / control-flow split (futures vs continuations) that E's promises vs when-catch later inherits; Vulcan added concurrent-logic data-flow postponement and named the "merge problem" (clients can only share access to a stateful object by explicit pre-arrangement) that the *Channels* abstraction was designed to solve; Joule (the immediate ancestor) added capability security, channels-as-generalized-promises (with multicasting), tanks (the unit of separate failure / persistence / migration / resource management that E rebrands as **vats**), and the Joule→KeyKOS resource-management model that E does not yet inherit; Original-E added the cryptographic securing of the Joule-style network extension and the sequential-immediate-call / asynchronous-eventual-send mix; E itself contributes the distinct reference *states* (near, eventual, broken) and the transitions among them — exactly the Harel statechart partition the rest of the paper expounds. Related work splits cleanly: §12 surveys systems with overlapping but different goals (MIT Promises and Batched Futures, group-membership / Paxos systems, Croquet and TeaTime), §12.1 surveys systems explicitly influenced by E's concurrency control (Web-Calculus, Oz-E, Twisted Python).

## Body

### §11 History — five-precursor lineage

The paper opens §11 with Alan Kay's framing that "Smalltalk is a recursion on the notion of computer itself" — each object is "a recursion on the entire possibilities of the computer", with semantics like "thousands and thousands of computers all hooked together by a very fast network." This is the conceptual seed; subsequent steps add what Smalltalk left out.

**Smalltalk (1970s).** Imported only the network-aspects that made it easier to program a single machine — not network transparency. The sequential subset of E has much in common with early Smalltalk: object references ↔ E's *near references*, message passing ↔ E's *immediate-call* operator.

**Actors (Hewitt et al. 1973; Hewitt 1985).** Inspired by early Smalltalk; goals include full network transparency under decentralization and mutual suspicion. The asynchronous-only subset of E *is* an Actors language: Actors' references ↔ E's eventual references; Actors' message passing ↔ E's eventual-send operator (`<-`). Actors provides both data-flow postponement (via futures — like E promises *without* pipelining or contagion) and control-flow postponement (continuations — similar in effect to E's when-catch). The price of Actors' uniformity is that all programs must work in the face of network problems even when local; E inverts this — the local case is strictly easier, so near-reference guarantees are a *strict superset* of the guarantees provided by other reference states.

**Vulcan (Kahn, Tribble, Miller, Bobrow 1987).** Merged aspects of Actors and concurrent logic / constraint programming. Concurrent-logic variables (much like futures or promises) taught the project to emphasize data-flow postponement and de-emphasize control-flow postponement. Vulcan was built on a concurrent-logic base and inherited the "merge problem" absent from pure Actors: clients can only share access to a stateful object by explicit pre-arrangement, so the equivalent of object references were not usefully first-class. The *Channels* abstraction (Tribble, Miller, Kahn, Bobrow, Abbott, Shapiro 1987) was the answer — it also provides useful ordering properties.

**Joule (Tribble, Miller, Hardy, Krieger 1995).** A capability-secure, massively-concurrent, distributed language; the *primary precursor* to E. Joule merges Vulcan with the remaining virtues of Actors. Three specific contributions survive into E:

1. **Joule channels** are similar to E's promises *generalized to provide multicasting*.
2. **Joule tanks** are the unit of separate failure, persistence, migration, and resource management; tanks inspired **E vats**. E vats further define the unit of sequentiality (event-loop turn boundary); E's event-loop approach achieves much of Joule's power with a more familiar and easier-to-use computational model.
3. **Joule's resource management** is based on abstractions from **KeyKOS** (Hardy 1985). E vats do not yet address this issue. This is the explicit open-issue in the lineage — the resource-management story E inherits is incomplete.

**Promise pipelining in Udanax Gold (Miller 1992).** A pre-web hypertext system with a rich client-server interaction protocol. In 1989, the project independently reinvented an *asymmetric* form of promise pipelining as part of its protocol design. This was the first attempt to adapt Joule channels to an object-based client-server environment (peer-to-peer was not supported).

**Original-E (Electric Communities, mid-1990s).** The result of adding Joule's concepts to the sequential, capability-secure subset of Java. Original-E was the *first* successfully to mix sequential immediate-call programming with asynchronous eventual-send programming. Original-E cryptographically secured the Joule-like network extension — something planned for in prior systems but not actually realized. Electric Communities used Original-E to build Habitats, a graphical, decentralized, secure social-virtual-reality system.

**From Original-E to E (post-1998).** In Original-E, the co-existence of sequential and asynchronous programming was still rough. E brought the invention of the **distinct reference states** (near, eventual, broken) and the transitions among them — i.e., exactly what the body of the paper expounds. With these rules, E bridges the gap between Smalltalk's network-as-metaphor view and Actors' network-transparency ambitions. The decisive property: in E, *the local case is strictly easier than the network case*, so near-reference guarantees are a strict superset of other-state guarantees. When programming for known-local objects, a programmer can do it the easy way; otherwise the programmer must address the inherent problems of networks — but the same code then painlessly handles the local case without further analysis.

### §12 Related Work — overlapping-goal systems

**Promises and Batched Futures at MIT (Liskov & Shrira 1988; Bogle & Liskov 1994).** The promise-pipelining technique was *first* invented by Liskov and Shrira (LS88); significantly improved by Bogle (BL94). Like Udanax Gold, these are asymmetric client-server systems. In other ways, the techniques used in Bogle's protocol resemble quite closely those in E's protocol. (Library cross-reference: Endo's pipelining-on-`E()` is the latest descendant in this LS88 → BL94 → Udanax → Original-E → E → Endo / Agoric-SDK lineage. The CapTP `<desc:answer>` answer-slot reference Endo uses is the wire-level enactment of the same idea.)

**Group Membership (Birman & Joseph 1987; Amir 1995; Paxos / Lamport 1998).** Extensive body of work on group-membership systems and (broadly speaking) Paxos. These provide a *different* form of partial-failure framework: closer approximations of common knowledge than E, at the price of *weaker support for defensive consistency and scalability*. Group-membership frameworks better support tightly-coupled composition of separate plan-strands into a virtual single overall plan; E's mechanisms better support loosely-coupled composition of networks of independent but cooperative plans. The paper sketches a *partition-aware application* (Babaoğlu et al. 1998; Sussman & Marzullo 2003) as the framework's natural use case — a single logical service to all clients, with multiple separated components changing state out of contact. E itself "provides nothing comparable"; the patterns of fault-tolerant replication E supports are all primary-copy replication with a single stationary authoritative host. The composability is good but the abstraction gap is real: how partition-aware applications can be programmed in E and how they compose with others is named as future work.

**Croquet and TeaTime.** The Croquet project has many of the same goals as the Habitats project: a graphical, decentralized, secure, user-extensible social-virtual-reality system spread across mutually-suspicious machines. Salient differences: Croquet is built on Smalltalk extended onto the network by *TeaTime*, which is based on Namos (Reed 1978) and Paxos to replicate state among multiple authoritative hosts. Unlike Habitats, Croquet is user-extensible but is not yet secure.

### §12.1 Work Influenced by E's Concurrency Control

**The Web-Calculus (Close 2004).** Brings to web URLs three simultaneous properties:

- The cryptographic capability properties of E's offline capabilities (both authenticating the target and authorizing access to it).
- Promise pipelining of eventually-POSTed requests with results.
- The properties recommended by the REST model of web programming (Fielding 2000). REST attributes web success to loose-coupling properties of `http://...` URLs.

As a language-neutral protocol compatible and composable with existing web standards, the Web-Calculus is well-positioned for widespread adoption. The paper signals intent to build a bridge between E's references and Web-Calculus URLs.

**Oz-E (Spiessens & Van Roy 2005).** Like Vulcan, the Oz language descends from both Actors and concurrent-logic / constraint programming. Unlike these parents, Oz supports shared-state concurrency (though Oz programming practice discourages its use). Oz-E is a capability-based successor to Oz designed to support both local and distributed *defensive consistency*. For the reasons explained in the paper's §6 (the "Defensive Correctness" argument), Oz-E suppresses Oz's shared-state concurrency.

**Twisted Python (Lefkowitz).** A library and a set of conventions for distributed programming in Python, based on E's model of communicating event-loops, promise pipelining, and cryptographic capability security. (Library cross-reference: the Twisted citation is one of the earliest non-E enactments of the model the paper expounds. Endo's HandledPromise inherits the same pattern — see `endo--packages-eventual-send-src-handled-promise-js--*` sections for the JavaScript realization.)

### §13 Discussion and Conclusions

The conclusion frames the contribution at the level of *defensive consistency*: under conventional shared-state multi-threading, defensive consistency is unreasonably difficult; under communicating event-loops, it becomes tractable. The enhanced reference graph in different states (where the message-delivery abilities of a reference depend on its state) is the operative structure: only **eventual references** convey messages between event-loops, and deliver messages only in separately scheduled turns — providing temporal separation of plans. **Promises** pipeline messages towards their likely destinations, compensating for latency. **Broken references** safely abstract partition. **Offline capabilities** (the `captp://` URI form) abstract the ability to reconnect.

The closing aspiration is one this library can name in retrospect: "When a system is composed of defensively consistent abstractions, to a good approximation, corruption is contagious only *upstream*." This is the architectural property Endo's vat-shaped compartments and capability discipline operationalize twenty years later.

### Acknowledgements

The paper thanks Darius Bacon, Dan Bornstein, John Corbett, Bill Frantz, Ian Grigg, Jim Hopwood, Piotr Kaminski, Alan Karp, Matej Kosik, Jon Leonard, Kevin Reid, Michael Sperber, Fred Spiessens, Terry Stanley, Marc Stiegler, Bill Tulloh, Bryce "Zooko" Wilcox-O'Hearn, Steve Witham, and the e-lang and cap-talk communities. Terry Stanley suggested the listener pattern and purchase-order examples. Ka-Ping Yee and David Hopwood receive special thanks for extensive technical feedback, clarifying rephrasings, crisp illustrations, and moral support; Ka-Ping Yee also drew Figures 2-5.

## Implications for Endo

The history-and-related-work section is the library's **lineage anchor** for the Endo stack. When a future designer needs to cite where eventual-send came from, where vats came from, where pipelining was first published, or where the secure cryptographic-capability network extension was first realized in practice, this section is the answer. Of particular note for Endo:

- **Joule → E vat** is the direct lineage that Endo's compartment / bundle isolation extends. The [[vat-and-compartment]] concept page (still to be written) anchors the translation; this section is the historical anchor.
- **LS88 → BL94 → Udanax → E → Endo** is the promise-pipelining lineage. Endo's `E(E(x).foo()).bar()` reduction in `handled-promise.js` is the JavaScript enactment of the same pattern Liskov and Shrira published in 1988 and that Bogle's "Batched Futures" (BL94) significantly improved upon.
- **KeyKOS resource management** is the open issue named in §11 (and inherited from Joule) that E and Endo still do not address; this is a *gap* for future Endo work to consider.

## See also

- [[caretaker-pattern]] — the forwarder + revoker construction, first described by Redell 1974 (cited in Capability Myths Demolished 2003), is the patterns-level companion to this paper's reference-state machinery.
- [[promise-pipelining]] — the concept page anchors the lineage at the *technical* level; this section anchors it at the *historical* level.
- [[object-capability]] — the four-models taxonomy from Capability Myths Demolished is the access-control side of the same lineage E represents on the concurrency-control side.
- `papers--miller-capability-myths-demolished-2003--*` — the companion 2003 paper on capability theory; cited as [MYS03] in the references list.

## Common confusions

- **"Vats and Actors are the same."** No. Actors require asynchronous-only messaging; vats add a sequential-immediate-call substrate (near references) that Actors deliberately lack. The §11 narrative makes this explicit: "the asynchronous-only subset of E is an Actors language" — but E itself is more.
- **"Pipelining is an E invention."** No. Pipelining was first invented by Liskov and Shrira (LS88) and improved by Bogle (BL94). E (and now Endo) inherits the technique; its contribution is the *combination* of pipelining with promise multicast (from Joule channels) and broken-reference contagion (E's own addition).
- **"E inherits KeyKOS resource management."** No. §11 names this as an explicit open issue: "Joule's resource management is based on abstractions from KeyKOS. E vats do not yet address this issue." Endo, twenty years later, still does not have a complete story here.
