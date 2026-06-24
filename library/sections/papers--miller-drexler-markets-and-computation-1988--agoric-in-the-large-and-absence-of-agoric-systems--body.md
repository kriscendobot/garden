---
title: Body
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "156-176 (§6 Agoric systems in the large; §6.1 software distribution markets; §6.2 marketplace of mind; §7 The absence of agoric systems; §8 Conclusions; Appendix I summary)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, agent-conventions, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems
---

### §6.1 Software distribution markets — charge-per-use as the architectural change

§6.1.1 names the incentive-structure question that *charge-per-use* markets address. In the conventional model, software is sold by the copy: high purchase prices discourage many potentially-frequent users from trying the software in the first place; occasional users pay as much as intense users; and a builder of composite software faces *summed* license fees from all the component creators, making composition pathological.

The §6.1.1 architectural alternative: *agoric systems will naturally support a charge-per-use market for software*. In a charge-per-use environment:

- High-volume users pay finite marginal prices for using software rather than paying zero marginal price after a large lump sum.
- Low-volume users experience zero barrier-to-entry; they use expensive software they could not afford under charge-per-copy.
- Component creators earn royalties when their components are *used*, not just *installed*. Composition becomes profitable.

The §6.1.1 closing diagnosis: **the peculiar incentive structure of a charge-per-copy market may have been a greater barrier to achieving Hamming's dream than the more obvious technical hurdles.** Hamming's quoted question — *"how are we to get to the situation where we build on top of the work of others rather than redoing so much of it in a trivially different way?"* — is the architectural problem the paper claims charge-per-use solves at the incentive layer.

### §6.1.2-§6.1.3 Hardware encapsulation and the inhibition of theft

§6.1.2 develops the *hardware encapsulation* substrate that makes charge-per-use feasible: an *opaque box* containing sensors, a processor, dynamic RAM, and a battery, whose private-key encryption key is held in the RAM. Objects encrypted with the box's public key can migrate to the box and be decrypted internally. If the box detects an attempt to violate its physical integrity, it wipes the dynamic RAM. The box is *opaque* because no one can see its contents.

The §6.1.2 architectural enactment: an opaque box would contain one or more branches of external banks, linked to them from time to time by encrypted communications; these banks would handle royalty payments for use of software. The §6.1.2 closing observation: *charge-per-use markets can support a model in which copies of software are available for the cost of telecommunications. CD-ROMs full of encrypted software might be sold at a token cost to encourage use.* (The 1988 paper anticipates exactly the contemporary streaming-software-distribution architecture by ~30 years.)

§6.1.3 develops the *inhibiting theft* argument: as society embodies more and more of its knowledge and capabilities in software, the theft of this software becomes a growing danger. *A charge-per-use environment will reduce this problem* by encouraging the development of software systems that are *composites of many proprietary packages, each having its security guarded by its creator*. The division and distribution of functions will make the problem faced by a thief less like that of stealing a car and more like that of stealing a railroad. **Traditional methods of limiting theft (such as military classification) slow progress and inhibit use; computational markets promise to discourage theft while speeding progress and facilitating use.**

### §6.1.4 Integration with the human market — Conway's law

§6.1.4 names the architectural justification for the agoric-systems posture at the social layer: it has been shown how an agoric system would use price mechanisms to allocate use of hardware resources among objects. This price information will also support improved decisions regarding hardware purchase: *if the market price of a resource inside the system is consistently above the price of purchasing more of the resource on the external market, then incremental expansion is advantageous*. The system can recognize a need for new hardware and, by buying it, perform an act of capital formation.

The §6.1.4 closing invokes Conway's law:

> Organizations which design systems are constrained to produce systems which are copies of the communications structures of these organizations. — M. E. Conway, 1968

The §6.1.4 architectural reading: *if so, then software systems developed in a distributed fashion can be expected to resemble the organization of society as a whole. In a decentralized society coordinated by market mechanisms, agoric systems are a natural result.* This is the paper's reverse-Conway argument: an agoric computational substrate enables organizational structures that match how decentralized human cooperation actually works.

### §6.2 The marketplace of mind — emergent intelligence from market interactions

§6.2 develops the most ambitious claim in the paper: agoric open systems should form an attractive *knowledge medium* in Stefik's sense (cited from this volume's [VII]). The argument: AI is unnecessary for building an agoric open system and achieving the benefits already described; building such a system may, however, *speed progress in AI*.

The §6.2 architectural framing: in a large evolving system where participants have great but dispersed knowledge, *"in the incentive structure lies the power"*. The incentives of a distributed charge-per-use market can widen the knowledge-engineering bottleneck by encouraging people to create chunks of knowledge and knowledge-based systems that work together.

The §6.2 closing argument addresses the *intelligence vs individuality* question. The paper claims that the most intelligent system now known is *human society as a whole* — not any individual person. The arguments against this seemed unfair: comparisons against an individual's brain miss that *human society includes not only brains but intestines* — not all parts need be intelligent for a system to be so. The deep claim:

> **The idea of intelligence may thus be separated from the ideas of individuality, consciousness, and will.**

The §6.2 conclusion: agoric systems may be seen as proposing *a form of multi-agent, societal approach to artificial intelligence* — Minsky's Society of Mind operating at the scale of distributed software rather than individual cognition.

### §7 The absence of agoric systems — a careful negative-evidence argument

§7 takes up the natural skeptical question: *if market-based computation is such a good idea, why hadn't it yet been developed by 1988?* When an idea of this sort neither lends itself to formal proof nor to small, convincing demonstrations, the difficulty of making a case for it grows. Support from abstract arguments and analogies can be helpful, as can an examination of the practical issues involved. But in addition, it helps to see whether the idea has been tested and found wanting.

The §7 framework: *considering this major category of possible negative evidence is an aspect of due-process reasoning.* The §7 enumeration of reasons agoric systems hadn't yet been built by 1988:

1. **Lack of immediate compelling need.** The software community had focused on better programming environments and methodologies (encapsulation of information and access; tools for visibility) — all *without building markets*. These advances had decreased the urgency of enabling extensive cooperation *without* mutual trust or extensive communications.

2. **Scale-sensitivity of the market approach.** In small systems, the overhead of accounting and negotiations is unjustified. Incremental increases in scale had thus far been possible without markets. Robust service-trading objects must have a certain minimum complexity, or have access to trusted business-agents of a certain minimum complexity. **The virtues of markets are greatest in large, diverse systems** — which had not yet existed at the scale agoric systems would require.

3. **Cultural factor: academic and government research environments.** Large research-oriented computer networks had focused on academic and government work — non-profit use. The academic community already had an informal incentive structure rewarding creators of useful software in rough proportion to its usefulness. *These reputation-based reward mechanisms facilitate the development of software systems that build on others' work; the differing incentives in the commercial community may be responsible for its greater tendency to build redundant systems from scratch.*

4. **Conceptual development of decentralization without markets.** Object-oriented programming gave property rights in data; agoric systems extend property rights to resources. The conceptual machinery for the latter was still developing in 1988.

The §7 closing argument: *these considerations seem sufficient to explain the lack of agoric systems today, while giving reason to expect that they will become desirable as computer systems and networks grow*. The development of automated programming systems will introduce "programmer's" having (initially) a sharply limited ability to plan and comprehend, re-emphasizing the problem of the "programmer's" span of conceptual control and *increasing the need for mechanisms that strengthen localization and system robustness*.

(*Library cross-note: this 1988 framing anticipates the rise of AI-coded systems by ~38 years. The "programmer's having sharply limited ability to plan and comprehend" matches the contemporary AI-assisted-software-development posture; the paper's prescription — localize and strengthen robustness — anticipates the contemporary capability-security argument. The garden's own steward / monitor / bundle posture is structurally what the §7 prescription anticipates.*)

### §8 Conclusions

§8 closes with the architectural thesis the rest of the paper develops:

> A central challenge of computer science is the coordination of complex systems. In the early days of computation, central planning — at first, by individual programmers — was inevitable. As the field has developed, new techniques have supported greater decentralization and better use of divided knowledge. Chief among these techniques has been object-oriented programming, which in effect gives property rights in data to computational entities. Further advance in this direction seems possible.

The §8 paper's contribution: *as systems grow in scale and complexity, so will the advantages of market-based computational systems*. The architectural prescription that follows: build the agoric foundations, allow market mechanisms to scaffold up from initial market strategies, and expect spontaneous order to produce coherent system-wide behavior that no individual planner could specify.

### Appendix I — issues × levels matrix

Appendix I (§I.1-§I.6) develops the *issues × levels* matrix tracking how concerns change character from low to high system levels:

| Issue | Low level | High level |
|-------|-----------|------------|
| Economics | planning | spontaneous order |
| Security | encapsulation | skepticism |
| Compatibility | message passing | operability |
| Degrees of trust | trust | reputations |
| Reasoning | logic | due-process |
| Coordination | serialization | negotiation |

The §I.1 *Security* sub-section makes the most-quoted observation in the appendix: *hard-edged criteria at lower levels of organization have soft-edged counterparts at higher levels*. Encapsulation provides security at a low level as a formal property of computation; *security at a high level involves skepticism and the establishment of effective reputation systems*. Encapsulation — protection against tampering — is *necessary for skepticism to work*. Without encapsulation, a skeptical object's intellectual defenses could be overcome by the equivalent of brain surgery.

The §I.3 *Degrees of trust* sub-section closes with the strategic-trust framing: *Axelrod's iterated prisoner's dilemma tournament shows another way in which strategic considerations can give rise to trust. One object can generally expect cooperative behavior from another if it can arrange (or be sure of) appropriate incentives.* Reputation systems within a community can extend this principle and lower the overhead of using it.

The §I.6 *Summary* closes the appendix: *issues often blur at the higher levels — security and trust become intertwined, and may both depend on due-process reasoning. The bulk of this paper concentrates on low- and mid-level concerns which must be addressed first, but high-level issues all present a wealth of important research topics.*
