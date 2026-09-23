---
title: Abstract
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

§4 takes the local capability machine of §3 to the network: **Pluribus** is E's cryptographic capability protocol enacting the Granovetter Operator across mutually-suspicious machines. The structural primitives the paper introduces here become foundational anchors of the Endo / Agoric distributed model: **vats** (units of persistence and migration; address-spaces-with-thread holding objects), **VatID** (the fingerprint of a vat's public key; the identity by which a vat is reachable across the network), and **swiss number** (an unguessable randomly-chosen identifier the receiving vat assigns to each exported object; the *knowledge-is-authority* construction the paper attributes to Swiss bank account numbers). §4.3 names **subjective aggregation** — the deepest structural argument in the paper: a participant may *subjectively aggregate* arbitrary sets of objects into composites; given the same graph, different participants will employ different aggregations according to their own ignorance or interest in finer distinctions. The architectural one-liner: **"only trust makes distinctions."** A fully paranoid actor models all of VatB as a monolithic composite and reasons as if VatB is conspiring against them; with trust, finer distinctions become available. §5 compares the capability model with SPKI: the same Granovetter Diagram applies, but the Subject and Issuer have no direct link, secrecy of private keys is the only barrier, communications can be in the clear, and confining the Issuer is impossible. §6 introduces the **rights taxonomy** along four axes — *Shareable vs Exclusive*, *Specific vs Fungible*, *Opaque vs Assayable*, *Exercisable vs Symbolic* — and applies the taxonomy to the **CoveredCallOption** smart contract, the paper's canonical worked example of a non-trivial financial instrument built compositionally from §3.4's primitives plus an extension (`TitleCompanyMaker`) that adds exclusivity. §7 closes by claiming that the Granovetter Operator-as-bridge enables the three communities' strengths to be combined synergistically rather than added separately.
