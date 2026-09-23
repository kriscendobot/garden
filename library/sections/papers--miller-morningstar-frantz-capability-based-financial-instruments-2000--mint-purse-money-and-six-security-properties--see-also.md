---
title: See also
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "15-20 (§3.4 Simple Money — the canonical capability-based money example with its six security properties walked through Alice-pays-Bob)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties
---

- [[caretaker-pattern]] — the §3.4 `decr` function is a *narrower facet* of the purse; the purse's `getDecr` exposes only the sealed-form, not the function itself. Same pattern.
- [[four-ways-to-acquire-references]] — the §3.4 deposit verification depends on *only connectivity begets connectivity*: the unsealer is unreachable except from same-currency purses, which is enforced by the four-ways constraint.
- [[security-as-extreme-modularity]] — the §3.4 visual-inspection-proof methodology IS the operational form of *security as extreme modularity*. The reader is doing the same code review they would do for modularity; the security properties fall out for free.
- [[smallcaps-encoding]] — Endo's marshal serialization layer; brand-stamped values are serialized with their brand identity preserved, enabling cross-vat verification of the same six properties.
- `papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement` — Paradigm Regained's Cassie+Max factory + factoryStamp is the 2003 generalization of this 2000 paper's BrandMaker + sealer/unsealer. The factoryStamp pattern is the trademark form; the sealer/unsealer is the sibling form.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — vats as units of persistence and migration; the §3.4 money example is *single-vat* by default but §4 will distribute it across multiple vats using Pluribus.
