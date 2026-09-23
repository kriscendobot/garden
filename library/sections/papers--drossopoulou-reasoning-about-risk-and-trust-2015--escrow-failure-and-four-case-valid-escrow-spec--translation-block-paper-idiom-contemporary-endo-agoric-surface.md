---
title: Translation block (paper idiom → contemporary Endo / Agoric surface)
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

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `ValidPurse` specification | Agoric ERTP `Issuer`-and-`Purse`-and-`Brand` invariants. The five policies map directly: `Pol_deposit_1` / `Pol_deposit_2` are the deposit-handle behaviour; `Pol_sprout` is `purse.deposit` on a freshly-empty purse; `Pol_can_trade_constant` is the brand-immutability invariant; `Pol_protect_balance` is the WeakMap-private-state discipline. |
| `CanTrade(prs1, prs2)` | The contemporary `issuer.isMyBrand(brand)` check; the abstract predicate is realized as a concrete brand-equality test. |
| §2.4 reciprocal-deposit mutual-trust construction | The contemporary `assertHandle` + reciprocal-purse-deposit pattern; also the cross-vat handshake that establishes a remote object obeys a particular interface contract. |
| `deal_version2` revised escrow | Agoric Zoe's atomic-swap contract. Zoe handles the mutual-trust establishment via the *brand* identity rather than reciprocal-deposit — but the §2.5 architectural pattern (escrow purses fresh + mutually-validated against participants) is structurally what Zoe enacts via its `seat` machinery. |
| Four-case `ValidEscrow` spec | The contemporary Zoe smart-contract test discipline: contracts should be tested in *each* case of the participant-trust grid (all-honest, some-conspiring, all-Byzantine), and the spec should make the trust assumption explicit. |
| §2.6 *return value does not communicate trustworthiness* | A standing lesson: contract return-values communicate *transaction state* not *counterparty trustworthiness*. Auditing the contract's success-history is necessary but not sufficient for trustworthiness conclusions. |
