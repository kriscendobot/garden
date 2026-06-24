---
title: Translation block (paper idiom → contemporary Endo / Agoric surface)
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

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `obeys` as hypothetical trust predicate | The `harden`-and-Compartment discipline: a hardened object *may or may not* meet its informal contract; the consumer-side proof discharges the hypothesis by ground-truth-checking provenance (e.g. `assertCanonicalShape`) or by deferring to documented invariants. |
| `MayAccess` as transitive points-to closure | The pass-by-copy / pass-by-reference discipline in `@endo/marshal`: a reference reaches a remote vat *only* if it traverses a pre-existing introduction chain; capabilities cannot be forged or spontaneously generated. |
| `MayAffect` as bounded mutation | Harden's *immutability-by-default* combined with `WeakMap`-keyed private state: mutation channels are explicit and gateway-mediated; an alleged-trustworthy object cannot mutate arbitrary heap nodes. |
| Hypothetical multi-case verification | The Hardened JavaScript reasoning style: assume nothing about untrusted callees; bound the damage they could do; verify the local invariants hold *regardless* of callee behaviour. |
| Open world | The Endo formula graph: any vat can introduce any other vat at any time; trust is per-introduction, not per-deployment. |
