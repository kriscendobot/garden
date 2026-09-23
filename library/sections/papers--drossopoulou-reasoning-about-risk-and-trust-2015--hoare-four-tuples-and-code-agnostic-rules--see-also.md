---
title: See also
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

- [[object-capability]] — the `(METH-CALL-2)` axiom formalizes *only connectivity begets connectivity*, the foundational ocap principle. The `(FRAME-METHCALL)` rule formalizes the dual.
- [[principle-of-least-authority]] — the framing rule `(FRAME-METHCALL)` is the formal POLA: an object can affect only what it has authority to affect (transitively).
- [[four-ways-to-acquire-references]] — the `(METH-CALL-2)` postcondition is the formal model of the *introduction* arm: a method call can introduce only references already reachable from its arguments / receiver.
- [[vat-and-compartment]] — `Focal` modules and the `*` linking operator are the formal counterpart to compartments and `@endo/compartment-mapper` composition.
- [[hardened-javascript]] (topic) — the §3.1 *Focal* language is the formal counterpart to Hardened JavaScript at the dynamic-language level. *Focal* is what JavaScript-under-SES is, modulo concrete syntax.
- [[smart-contract]] — the §3.4 proof technique extends to any multi-party trust-sensitive contract; the four-tuple is the formal mechanism for *during-execution* risk bounds.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect` — the §1-§2.2 introduction of `obeys`, `MayAccess`, `MayAffect` this section formalizes.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--escrow-failure-and-four-case-valid-escrow-spec` — the §2.3-§2.6 application this section's logic proves.
