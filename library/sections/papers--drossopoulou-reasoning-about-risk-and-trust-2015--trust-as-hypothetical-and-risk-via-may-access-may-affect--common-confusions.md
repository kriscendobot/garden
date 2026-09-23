---
title: Common confusions
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft (referenced as Drossopoulou-Noble *Swapsies on the Internet* PLAS 2015 [17] in the bibliography; the full technical report is ECSTR-15-08, VUW, 2015 [18])"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "1-7 (§1 Introduction; §2.2 Modelling Trust and Risk: obeys, MayAccess, and MayAffect)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect
---

- **"`obeys` is a runtime check."** No. `obeys` is *hypothetical*. There is no runtime predicate `o.obeys(Spec)` that returns true or false. `obeys` is a verification-time assumption that the proof either discharges (by ground-truth provenance) or carries as a remaining hypothesis. An object that is *not* trusted by us is *not* `obey`ed in our reasoning; we still must bound the damage it could do.
- **"`MayAccess` requires reachability analysis."** It requires the *abstract* points-to relation, which is decidable in the formal model (the heap is a finite graph). In a real implementation, `MayAccess` is over-approximated by *what could conceivably happen* under the worst-case adversarial callee. The paper's §1 *Disclaimers* explicitly notes that quantification over the entire heap is part of the abstraction.
- **"`MayAffect` only covers writes."** It covers *any* observable effect a method call could have on a property — writes are the dominant case but throws, invalidations, and other observable mutations are also `MayAffect`-able. The paper's §1 Disclaimers notes that objects are assumed not to throw or breach encapsulation, which keeps `MayAffect` tractable; the realistic generalization requires additional cases.
- **"Hypothetical reasoning is just informal pondering."** No. The hypothesis is *formal* — it enters the proof as an antecedent of an implication. *If* `o obeys Spec` *then* the strong postcondition holds; *if not* then only the weak postcondition (the risk bounds) holds. Both branches are part of the overall theorem, not a hand-wave.
- **"This subsumes traditional specification languages."** Partially. Traditional specs are a *special case* of this paper's specs where every object's `obeys`-predicate is assumed true (closed world). The §2.2 framing is *strictly more expressive* than the traditional approach but requires more from the verifier: every untrusted-callee case must be handled.
- **"The paper claims to eliminate trust."** No. The paper makes trust *explicit*. The reduction is from *implicit-blanket-trust* (every object is trustworthy) to *case-by-case-explicit-trust* (each `obeys` hypothesis is discharged or carried). This is a *qualitative* improvement in the precision of specifications, not an elimination.
