---
title: Common confusions
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft, technical report ECSTR-15-08 (VUW, 2015)"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "11-18 (§3 A Formal Model of Trust and Risk through §3.4 Proving Mutual Trust)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules
---

- **"Hoare four-tuples are just Hoare triples with the invariant tacked on."** Not quite. The four-tuple's invariant `B` quantifies over *every* intermediate state, not just the terminal state. This is the key formal device for capturing *no-temporary-bad-behaviour-during-execution* — the kind of guarantee that matters for risk in adversarial settings. Standard Hoare triples cannot express this.
- **"`(METH-CALL-2)` requires no specification at all."** The rule applies *in the absence of* a known spec for the called method, but the *language* (`Focal`) provides the memory-safety axioms that the rule depends on. The rule is sound *because* `Focal` guarantees no address-forgery, no non-existent-field-access, etc.
- **"`(CODE-INVAR-2)` makes trust permanent."** It makes trust *invariant across statement execution* — if `x obeys S` held before, it still holds after. This is what lets verification carry trust hypotheses across long sequences without re-discharging them. The hypothesis is still *hypothetical* — it can fail in the world, but within a verification, once assumed it holds throughout.
- **"`Focal` is JavaScript."** Close but stripped to essentials: classes, fields, methods, dynamic typing, memory-safety. No closures (the §3.1 paper does not model them); no eval; no this-style polymorphism complexity. Real JavaScript adds these on top, and the formal model would have to be extended to handle them precisely.
- **"The §3.3 rules let me verify any program automatically."** No — they form an inference system the verifier *uses* to construct proofs. The §3.3 paper presents the rules; the §3.4 paper shows one application; the §1 *Disclaimers* notes that aliasing, concurrency, quantification, confinement, network errors, and exceptions are deferred to follow-on work. Practical mechanization remains future work the §5 conclusion explicitly identifies.
- **"`obeys` is a circular hypothesis."** It is a *carry-able* hypothesis. The verifier *assumes* `x obeys S` and then derives consequences. The hypothesis is *discharged* in two ways: (i) by ground-truth provenance (we built `x` ourselves), or (ii) by structural argument (we received `x` through a trusted introduction chain). Within a verification, the hypothesis is consistent; across verifications, the discharge step matters.
