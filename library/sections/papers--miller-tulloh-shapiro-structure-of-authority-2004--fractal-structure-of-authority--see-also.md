---
title: See also
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "6-15 (§2.2 Fractal Locality of Knowledge, §3 Fractal Nature of Authority, §3.4 Object-Granularity POLA)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority
---

- [[object-capability]] — the existing concept page. This section is the *structural-theorem* citation; the existing page's *taxonomy* (four models from Capability Myths Demolished) is the access-control-as-distinct-from-other-models citation. Both ground the same model.
- [[four-tables-coordinated-retention]] — the four ways a formula identifier comes to exist in the daemon (introduction via marshal, parenthood via formula construction, endowment via initial petname graph, initial conditions = daemon bootstrap) match the four ways enumerated here. The Endo concept is the implementation enactment.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — the vat model is the unit of *temporal* separation; this paper's nested-POLA framing is the unit of *spatial* / authority separation. Together they cover the full decomposition.
- `endo--designs-daemon-persistence--persistence-by-petname-traversal` — the Endo design that enacts "only connectivity begets connectivity" as a persistence invariant.
