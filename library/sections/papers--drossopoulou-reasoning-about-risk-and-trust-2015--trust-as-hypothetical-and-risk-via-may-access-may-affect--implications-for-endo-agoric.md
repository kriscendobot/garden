---
title: Implications for Endo / Agoric
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

This section is the **formal underpinning for the Hardened JavaScript trust discipline**. The library can cite this paper whenever:

1. **A design needs to formalize trust assumptions.** The `obeys` predicate is the canonical way to make a trust assumption *explicit* and *dischargeable* in a specification. Hardened JavaScript code makes the same assumption implicitly via *defensive consistency*; the §2.2 framing exposes the structure.
2. **A design needs to bound damage in the untrusted case.** `MayAccess` and `MayAffect` are the formal bounds: an untrusted callee can read what it can reach, mutate what it has affect-authority over. Both bounds are *static* properties of the pre-state, not runtime checks.
3. **A design discusses the open-world / closed-world distinction.** The §1 paper is the canonical statement of the open-world specification problem. The contemporary Endo / OCapN ecosystem is *paradigmatically* open-world: any vat may meet any other vat, no central authority assigns trust.
4. **A design needs to verify code *under* trust hypotheses.** The §2.2 multi-case discipline (one case per trust hypothesis, each contributing to the overall correctness proof) is the canonical reasoning style. Hardened-JavaScript review practice follows this discipline implicitly; making it explicit can sharpen review.
