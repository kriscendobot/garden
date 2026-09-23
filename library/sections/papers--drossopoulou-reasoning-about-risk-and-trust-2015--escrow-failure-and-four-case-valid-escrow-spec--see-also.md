---
title: See also
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

- [[mint-purse-money]] — the §2.3 `ValidPurse` is the formal specification of the mint-purse pattern. The 1988 / 2000 / 2013 papers give the historical lineage of the pattern; this paper gives the formal contract.
- [[smart-contract]] — the §2.6 four-case structure is the canonical pattern for any multi-party contract spec.
- [[brand-and-trademark]] — `CanTrade` is the abstract predicate that contemporary brand-equality concretizes.
- [[principle-of-least-authority]] — `Pol_protect_balance` is the formal statement of POLA: an untrusted caller can affect balance only if it had prior access.
- [[object-capability]] — *only connectivity begets connectivity* (the §2.3 policy framing) is the foundational ocap axiom.
- [[four-ways-to-acquire-references]] — `MayAccess` formalizes the introduction arm of the four-ways graph.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect` — the prior section in this source defines the `obeys`, `MayAccess`, `MayAffect` predicates this section uses.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the 2013 escrow exchange contract this paper formalizes and finds weaker-than-expected.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the 2000 escrow-broker pattern the §2 paper traces back to.
