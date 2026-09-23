---
title: Implications for Endo / Agoric
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft, technical report ECSTR-15-08 (VUW, 2015)"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "3-11 (§2 Escrow Exchange through §2.6 Specifying the Mutual Trust Escrow + Discussion)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, patterns, spec-to-implementation]
status: current
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--escrow-failure-and-four-case-valid-escrow-spec
---

This section is the **formal specification model for Agoric Zoe and Hardened JavaScript trust verification**. The library can cite this paper whenever:

1. **A design needs to formalize a multi-party contract spec.** The four-case structure is the canonical pattern: enumerate the cases on participant-trust and specify what holds (and what risk is bounded) in each.
2. **A design needs to discuss what a return value can and cannot tell you.** The §2.6 Discussion is the canonical statement: `true` cannot distinguish *all-honest* from *jointly-conspiring-untrustworthy* in any multi-party contract. The verifier should not rely on the return value beyond what the spec guarantees.
3. **A design needs to establish mutual trust between two cap holders.** The §2.4 reciprocal-deposit construction is the canonical pattern: zero-amount handshake calls in both directions yield a biconditional on `obeys`. This is also the structural pattern for *cross-vat capability handshake*.
4. **A design discusses the risk bounds of an untrustworthy callee.** The §2.3 `Pol_protect_balance` is the canonical formalization: an untrustworthy caller can affect a balance only if it had prior access. *Only connectivity begets connectivity* is the underlying ocap axiom; this paper is the formal model.
