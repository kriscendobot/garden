---
title: Body
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "22-24 (§6 Related Work + §7 Conclusion and Future Work)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane
---

### §6 Robust safety — the cryptographic-protocol-verification lineage

The §6 paper traces robust safety's history:

> The concept of robust safety arose in the context of verifying security protocols that interact with adversaries. Early work used typing to prove "correspondence properties" for cryptographic protocols modeled in the spi calculus (Gordon and Jeffrey 2001). In their work on the refinement type-checker F7, Bengtson et al. (2011) generalized robust safety to a richer class of integrity properties for a process calculus, RCF, with higher-order state. We inherit from their work the basic idea of using a notion of low-integrity values and proving robust safety, but the approaches differ greatly in detail. First, we show how to apply this idea to OCPs, a completely different domain. Second, we show how low-integrity values are directly encodable in modern separation logics, using a simple logical relation.

The §6 structural insight: **robust safety as a meta-theorem was a known idea in cryptographic protocol verification**; the OCPL paper's novelty is *transposing the idea to the object-capability domain* and *encoding low-integrity values in separation logic via logical relation*. The transposition is non-trivial because OCPs use *closures-as-capabilities* rather than *cryptographic-primitives-as-capabilities*, requiring higher-order reasoning that the protocol-verification setting did not have.

### §6 Object-capability specifications — the Drossopoulou + Devriese comparison

The §6 paper names the *very preliminary work* on OCP specifications:

> There has been only very preliminary work on specifying and verifying functional properties of object capabilities and OCPs. In his seminal paper on dynamic sealing, Morris (1973) proposed informal reasoning principles for programmers using dynamic sealing, but did not prove anything formally. Drossopoulou et al. (2015a) proposed predicates modeling trust and risk and used those predicates to specify a capability-based escrow exchange example (Miller et al. 2013). They focused on this one example, whereas we develop general specifications for several OCPs. Further, they focus on syntactic specifications and do not define the semantics of their predicates. A subsequent manuscript (Drossopoulou et al. 2015b) bridges this gap to the semantics, but their Hoare logic seems inadequate for the examples we consider, e.g., it lacks a rule for dynamic allocation.

The §6 *Drossopoulou et al. 2015a/b* citations are **the cycle-85 paper**: 2015a is the PLAS'15 *Swapsies on the Internet* version; 2015b is the ECSTR-15-08 technical report (which the library ingested cycle 85). The OCPL paper's critique:

- **2015a focused on one example (escrow exchange)** — OCPL handles three patterns (dynamic sealing, caretaker, membrane).
- **2015a focused on syntactic specifications** — OCPL provides semantics via logical relations + Iris.
- **2015b's Hoare logic lacks a rule for dynamic allocation** — OCPL handles this naturally via Iris's separation-logic foundation.

This is the *Drossopoulou-paper-cited-and-extended* observation that makes OCPL a *successor* to cycle-85's Reasoning About Risk and Trust.

The §6 *closest comparable work*:

> Perhaps the most closely related work to our own is that of Devriese et al. (2016). As discussed in the introduction, they use a Kripke logical relation and a meta-property called effect parametricity to verify integrity properties for several examples of capability-wrapped user code in a language with higher-order state. There are several points of difference between our work and theirs. First, we work in a concurrent separation logic rather than directly in a low-level logical relation. As a result, in addition to being able to conduct our proofs at a much higher level of abstraction, we can give *compositional* specifications for higher-order object capability *patterns* (i.e., libraries), whereas they only verify specific programs that use object capabilities. We also exploit the notion of robust safety in verifying integrity properties of code that uses OCPs, whereas corresponding arguments only appear implicitly in their proofs. On the other hand, they develop semantic variants of the so-called "reference graph properties" from the literature on object capabilities. These properties are important but they are also orthogonal to verification, and hence, we do not examine them here. Last but not least, our proofs are machine-checked in Coq.

The §6 Devriese-comparison's structural reading: OCPL's *separation-logic + robust-safety* approach is *compositional* (verifies *patterns*, not just *programs*) and *Coq-machine-checked*; Devriese's *Kripke-logical-relations + effect-parametricity* approach handles *reference graph properties* that OCPL doesn't.

### §6 Other OCP verification approaches

The §6 paper surveys further OCP-verification work:

- **Sumii-Pierce 2004**: bisimulation for proving contextual equivalences in a language with a dynamic sealing primitive — *they consider pairs of expressions ("modules") implementing the same "interface" using sealing — and the question they study is whether those expressions are indistinguishable, even if their internal representations differ*. OCPL's specifications are *direct* (not via equivalence).
- **Bengtson et al. 2011**: ideal-cryptographic dynamic-sealing implementations in RCF, *no general specifications for dynamic sealing analogous to the specification in §3*.
- **Van Cutsem and Miller 2013** (§§4.3-4.4): a variant of OCPL's public membrane *used to implement proxy objects supporting so-called language invariants*. Reasoning enabled (such as the ability to "freeze" object properties), but focus is on use of such membranes *as an implementation technique, rather than on verification*. This is the *Trustworthy Proxies* paper that complements cycle-82's *Distributed Electronic Rights in JavaScript* — same authors, similar timeframe, focused on proxy-based language invariants.
- **Spiessens-Van Roy 2005; Spiessens 2007; Murray 2010**: model- and refinement-checking tools for safety and liveness properties of abstract OCP-system models. The §6 takes one example from Murray 2010 — *Murray shows that a specific model of an unsealing operation does not reveal a sealed value unless a capability to that sealed value was passed (possibly indirectly) to the unsealing operation by the context*. The §6 critique: *such properties cannot be directly used to verify clients of the OCPs. In contrast, our goal is very different: we write compositional specifications for concrete implementations of OCPs and our specifications can be directly used to verify clients*.

### §6 Ownership types — Clarke + Banerjee-Naumann + Patrignani

The §6 paper closes with ownership-types comparison:

> There are interesting similarities between the core mechanisms of OCPL and prior work on *ownership types* (Clarke et al. 2013). In their seminal paper, Clarke et al. (1998) proposed a type system based on what came to be called *owners-as-dominators*. Roughly, the idea is to impose an ownership relation on objects, separating a public *owner* object from its hidden *representation* object, and ensuring that an owner mediates all outside access to its representation. ... In a similar vein, OCPL classifies locations as high-integrity (private) vs. low-integrity (public), and enforces that high-integrity locations cannot be accessed from low-integrity locations. However, OCPL is not a static type system, but rather a logic for verifying the enforcement of integrity properties in a dynamically-typed setting.

The §6 *Banerjee-Naumann + Patrignani* extensions:

> Banerjee and Naumann (2005a,b) prove relational parametricity theorems, using logical relations as a proof technique for showing that one representation may be safely replaced by another. Patrignani et al. (2011) show that an extension of owners-as-dominators can be used to prove relational secrecy properties for the join calculus, based on a distinction between high- and low-integrity values.

The §6 framing's structural significance:

> In OCPL, we define low-integrity values using a simple (implicitly step-indexed) logical relation, and (like Patrignani et al.) our key meta-theorem concerns the interaction of user code with untyped, untrusted code. However, despite these similarities to prior work, our concrete goals are very different: rather than reasoning about relational properties, we focus on verifying functional specifications of OCPs and the robust safety of capability-wrapped code.

### §7 Conclusion and Future Work

The §7 paper closes with two future-work directions:

#### Firefox same-origin-policy membrane

> Object capability patterns (OCPs) enable programmers to enforce invariants on the private state of their objects, even when those objects are passed to untrusted code. In principle, this should make it easier to write secure and correct programs, but in practice, programmers may use OCPs incorrectly, resulting in subtle security flaws. In this paper, we develop OCPL, the first logic for compositionally specifying and verifying OCPs. We deploy it in reasoning about both implementations and representative clients of several well-known OCPs, in the context of a simple but expressive programming language with higher-order state.
>
> We believe that using robust safety and separation logic to reason about OCPs scales to much richer settings. The Firefox web browser, for example, uses an automatic and significantly more sophisticated membrane pattern to enforce the so-called same-origin policy (Mozilla 2016; Barth 2011). In ongoing work, we are exploring an extension of OCPL to reason about this system.

The §7 Firefox-same-origin-policy direction is **substantial future work**: the same-origin policy is *the* canonical Web-security mechanism, and verifying it formally would have enormous impact. The OCPL paper signals that the approach should scale, but the work was *ongoing as of 2017*.

#### Coq proof automation

> Furthermore, while the Iris proof mode enables relatively high-level Coq proofs, such manual proofs are nonetheless often tedious and routine. Additional research is needed to scale such proofs up to realistic languages and improve automation.

The §7 *automation* future-work is the *standard machine-verification challenge*: formal proofs are powerful but labor-intensive. Better automation would extend OCPL's reach.

#### §Acknowledgments — RustBelt linkage

The §Acknowledgments note:

> This research was supported in part by a Microsoft Research PhD Scholarship, and in part by a European Research Council (ERC) Consolidator Grant for the project "RustBelt", funded under the European Union's Horizon 2020 Framework Programme (grant agreement no. 683289).

The §RustBelt linkage is structurally significant: **Iris was developed in the RustBelt project**, which uses Iris to verify the safety of the Rust standard library's unsafe abstractions. OCPL is *built on Iris*, so OCPL inherits RustBelt's tooling. The Iris-RustBelt-OCPL lineage runs *Iris → RustBelt's Rust verification → OCPL's OCP verification* — a single tooling foundation supporting two distinct verification domains.

### §OCPL Coq formalization

The §1 paper noted *All our results are fully mechanized in the Coq proof assistant*. The footnote on page 1: *The Coq formalization is available online (OCPL 2017)*. Reference [OCPL 2017]: *Long version of this paper (with appendices) and Coq development. (July 2017). Available at the Iris project website at http://plv.mpi-sws.org/iris/*.

The §formalization availability is the *Coq-mechanization-is-the-source-of-truth* discipline. The paper's specifications and theorems are not just *informally argued* — they are *mechanically checked*. Reading the paper without the formalization gives the *intent* of the proofs; reading the formalization gives the *full content*.
