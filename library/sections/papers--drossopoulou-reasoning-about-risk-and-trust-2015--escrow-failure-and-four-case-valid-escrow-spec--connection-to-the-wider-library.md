---
title: Connection to the wider library
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

The §2 paper is the **canonical worked example for the open-world specification methodology**. Three threads:

1. **`ValidPurse` formalizes the mint-purse pattern.** The §2.3 five-policy spec is the formal counterpart to the 1988 Miller-Drexler mint-purse and the 2000 Miller-Morningstar-Frantz `CapMint` and the 2013 Miller-Van Cutsem-Tulloh JavaScript `makeMint`. The library now has the historical lineage *and* the formal specification.

2. **The §2.6 four-case spec is the model for *any* multi-party trust-sensitive contract spec.** Any contract that integrates multiple parties with mixed trustworthiness should be specified as a *case analysis on the trust hypothesis structure*: trustworthy-only, mixed, etc. The four-case structure generalizes beyond escrow.

3. **The §2.4 mutual-trust-via-reciprocal-deposit construction is reusable.** Any two capabilities that expose a *successful-operation-yields-trust* gateway can be combined into a mutual-trust pair via reciprocal calls. This is the formal underpinning of *defensive consistency* in Hardened JavaScript: handshake-style verification at boundaries.
