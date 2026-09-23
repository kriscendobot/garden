---
title: See also
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

- [[per-agent-keypair]] — the concept page. §4.2's VatID is the 2000 framing of the per-agent-keypair primitive; cycle 47's daemon-persistence ingest provides the Endo enactment.
- [[four-tables-coordinated-retention]] — the swiss-number is the 2000 framing of the unguessable-formula-id property; the four-tables design extends this to coordinated cross-peer retention.
- [[formula-graph]] — the persistence side of the same primitive: formula identifiers are persistent, unguessable, and content-addressed.
- [[four-ways-to-acquire-references]] — §4.2's transfer-of-a-capability-across-the-network is the cross-vat *Introduction* mechanism. The library concept generalizes to all four mechanisms.
- [[caretaker-pattern]] — §6.5's TitleCompanyMaker is structurally identical to the Caretaker pattern at one level up: a purse-shaped facet wraps a single underlying object and adds an exclusivity invariant. The Caretaker page's "split into action and control facets" framing applies.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — Concurrency Among Strangers 2005 expands the vat concept introduced here; the 2005 paper is the canonical citation for vat as *unit of persistence, migration, partial failure, defense*; this 2000 paper is the citation for vat as *unit of cryptographic identity*.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — Concurrency Among Strangers 2005 §9.2 *Offline capabilities* (`captp://...` URIs and `SturdyRef`) is the 2005 evolution of this paper's VatID + swiss number framing.
