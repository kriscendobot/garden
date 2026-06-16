---
title: Connection to the wider library
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

The §2.2 paper is the **specification-language groundwork** for everything that follows in this paper and for a body of follow-on work ([15], [16], [17], [18] in this paper's bibliography). Three threads to highlight:

1. **The `obeys`-as-hypothesis discipline echoes the §2 *paradigm regained* methodological turn**: capability security as *reasoning under uncertainty*. The paper does not ask *is `o` trustworthy?* (which is unanswerable); it asks *what holds if we hypothesise `o` is trustworthy?* and *what holds if we do not?*. Both branches contribute to the overall correctness proof.

2. **`MayAccess` is the formal version of the four-ways-to-acquire-references principle**: a reference to `p` from `o` arises only via the four-ways graph (parenthood, endowment, introduction, fabrication). The paper's §3.3 (`METH-CALL-2`) rule captures exactly this: after `v := x.m(y)`, any new reachability into `z` must be along a chain that was already reachable *before* the call from `x` or `y`. This is the *introduction* arm of the four-ways taxonomy made precise.

3. **`MayAffect` is the boundary that POLA enforces**: an object can affect only what it has authority to affect. The §3.3 (`FRAME-METHCALL`) rule shows the dual: if an effect happens at `z` (i.e. `MayAffect(z, A')`), then either `z` is the receiver / argument of the call, or `z` is in the *new* objects allocated by the call. This is the formal version of *only connectivity begets connectivity*.
