---
title: Abstract
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

§1 frames the paper's central question: given a method call `x.m(y)` where the receiver `x` is *unknown* — supplied from elsewhere in an open system with no central trust authority — what can the caller conclude about the call's behaviour? The traditional *closed-world* answer (assume all objects are trustworthy because they are *confined* in Lampson's sense) does not apply. The §1 answer the paper proposes is to introduce three new specification predicates that let code reason *conditionally and hypothetically* about untrusted callees. **`o obeys Spec`** is the first-class trust predicate: it means *the current object trusts `o` to adhere to specification `Spec`*. The `obeys` predicate is **hypothetical** — there is no central authority that can assign trustworthiness, and there is no trust bit on objects that can be tested at runtime. `obeys` is an assumption that may or may not be true, and the verification proceeds by *cases*: if we trust the object, we can use the object's specification to determine the call's results; if we do not trust the object, we determine the *risk* — the maximum amount of damage the call could do that turns out not to meet the specification. **`MayAccess(o, p)`** means it is *possible* that the code in object `o` could potentially gain a capability to access `p` — equivalently, `p` is in the transitive closure of the points-to relation on the heap starting from `o`, including both public and private references. **`MayAffect(o, p)`** means it is *possible* that some method invocation on `o` would affect the object or property `p`. The three predicates form a *complementary* pair: `obeys` tells us what we can rely on for trustworthy callees; `MayAccess` and `MayAffect` tell us what damage untrusted callees could inflict on the rest of the system. The §1 framing is the paper's central methodological move: it makes the trust assumption *explicit* in the specification language, rather than buried as an implicit closed-world assumption underneath conventional spec-and-prove machinery.
