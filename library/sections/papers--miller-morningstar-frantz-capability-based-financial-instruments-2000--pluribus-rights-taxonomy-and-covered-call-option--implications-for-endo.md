---
title: Implications for Endo
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

This paper is the **most-cited foundational citation** for the Endo / Agoric distributed model:

1. **Vat = Endo bundle.** The §4 vat concept is the conceptual ancestor of the Endo bundle: a self-contained address-space + thread + persistent identity that hosts objects. Concurrency Among Strangers 2005 §3 expands the vat concept; this paper introduces it for the financial-instruments domain.
2. **VatID + swiss number = formula identifier.** Endo's formula-graph IDs include a per-agent keypair fingerprint (the VatID analog) and an unguessable random portion (the swiss number analog). The `per-agent-keypair` and `four-tables-coordinated-retention` concept pages have this paper as their canonical citation for the *theoretical* grounding (cycle 47's daemon-persistence ingest provides the Endo-implementation enactment).
3. **Subjective aggregation is the trust posture.** §4.3's claim that "we can reason as if we are only suspicious of objects" because mistrust of a vat is equivalent to ignorance of its internal structure is the operational form of Endo's per-bundle trust model. The library can cite this section whenever Endo design reviews need to bound trust at the bundle level.
4. **ERTP is this paper, scaled.** Agoric's Electronic Right Transfer Protocol — issuer + mint + purse + amount — is the direct successor of the §3.4 MintMaker + §6.5 TitleCompanyMaker patterns. The §6.2 rights taxonomy is the design vocabulary ERTP uses (the AmountMathKind set: `nat`, `set`, `copyBag`, `copySet` corresponds to the Specific / Fungible axis; the issuer/brand pair corresponds to the Exclusive-when-issued-from-broker construction).
5. **Smart contracts compose.** §6.4's CoveredCallOption is a *composite* of three pre-existing primitives (purse, timer, brand) plus a small protocol. Agoric Zoe's contract framework is the production enactment of this compositional pattern. The library can cite §6.4 + §7 whenever Endo / Agoric design reviews argue that new financial instruments should be composed from existing primitives rather than designed as bespoke protocols.
