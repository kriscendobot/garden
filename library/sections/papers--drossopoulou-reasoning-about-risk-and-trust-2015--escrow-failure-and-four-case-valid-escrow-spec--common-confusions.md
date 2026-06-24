---
title: Common confusions
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

- **"`true` means both parties were honest."** No — this is the §2.6 paper's central methodological lesson. `true` could arise from case 1 (all four participant purses trustworthy) *or* case 4 (matching pairs of untrustworthy purses cooperating to suborn the escrow). The verifier cannot distinguish these cases from the return value alone.
- **"Reciprocal zero-amount deposits validate trust at runtime."** They *establish a biconditional*: either *both* purses are trustworthy or *both* are untrustworthy. They do not *resolve* either hypothesis individually. The hypothesis is *carried* through the rest of the verification.
- **"The risk to honest purses is zero in case 3 / case 4."** Not zero — *bounded*. The §2.6 specification says trustworthy purses outside the *pre-existing reachability cone* of untrustworthy participant purses are unaffected. A trustworthy purse that was already accessible to an untrustworthy purse *could* have its balance changed. The risk is contained to what was *already at risk* before the call.
- **"The escrow purse is special infrastructure."** No — it is a freshly-sprouted ordinary purse. The §2.5 trick is that *freshly-sprouted* purses cannot be aliases for any pre-existing untrustworthy purse (per `Pol_sprout`'s `res ≠ p` clause). This is the §2.5 architectural reason the escrow uses sprouted purses rather than asking participants to supply escrow purses directly.
- **"The §2 paper revises the §2 paper of the 2013 paper."** No — the §2 of this paper formalizes the 2013 paper's informal §5 escrow exchange. The 2013 paper had the *code*; the 2015 paper has the *specification* and the *correctness proof*. Both papers are necessary; the 2015 paper builds on the 2013 worked example.
- **"This means escrows are broken."** No — escrows do exactly what they can do. The methodological lesson is that *the contract cannot communicate trustworthiness via its return value*. Trustworthiness must be established *externally* (by the issuer's identity, by reputation, by audit). Within those external trust anchors, the escrow correctly performs the atomic exchange and bounds the risk of failure.
