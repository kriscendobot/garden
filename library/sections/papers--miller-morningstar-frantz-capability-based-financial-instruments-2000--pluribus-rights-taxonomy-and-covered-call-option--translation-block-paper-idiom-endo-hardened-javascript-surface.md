---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "20-32 (§4 Pluribus distributed protocol; §4.3 Subjective Aggregation; §5 PKI comparison; §6 Financial Instruments + four-axis rights taxonomy + CoveredCallOptionMaker + TitleCompanyMaker; §7 Conclusion)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, captp, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Vat                                        | Endo daemon / bundle / compartment hierarchy; SwingSet vats in Agoric. |
| VatID (public-key fingerprint)             | Endo's per-agent keypair (`@keypair` formula); the formula identifier that includes the keypair fingerprint. Library concept: `per-agent-keypair`. |
| Swiss number                               | The unguessable random portion of an Endo formula identifier. Library concept: `formula-graph`'s unguessable-id property; `four-tables-coordinated-retention` lineage. |
| Proxy (local representative of remote)     | Endo's HandledPromise / E-proxy pattern. CapTP / OCapN protocol's answer-slot mechanism. |
| Pluribus protocol                          | OCapN-family CapTP protocol. |
| Subjective aggregation                     | The Endo trust posture: each bundle reasons about other bundles *at the granularity of their containing daemon-or-vat* unless and until it has reason to trust finer distinctions. |
| Confined Issuer                            | Endo's compartment + bundle hierarchy ensures the "issuer" (parent bundle) is confined by its own endowment; the parent can only authorize children it has reach to. |
| Four-axis rights taxonomy                  | Endo / Agoric ERTP design vocabulary: brand (Specific), purse (Exclusive when wrapped via title-company pattern), amount (Fungible | Specific depending on AmountMath kind), invitation (Exercisable). |
| CoveredCallOption smart contract           | Agoric's Zoe contract framework; the option pattern in particular is one of the canonical Zoe contracts. |
| TitleCompanyMaker (exclusive wrapper)      | Agoric ERTP's *non-fungible* (NFT-style) issuer kit; an issuer whose AmountMath is `set` or `copyBag` rather than `nat`. |
