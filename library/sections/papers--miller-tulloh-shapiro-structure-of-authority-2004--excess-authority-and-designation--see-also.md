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
source_paper_pages: "1-6 (§1 Excess Authority, §1.1 How Much Authority Is Adequate, §2 Composing Complex Systems, §2.1 Object-Capability Model)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation
---

- [[principle-of-least-authority]] — *placeholder concept page*. The paper's §1.1 cp/cat example and §2.1 closing paragraph are the canonical exposition; this section is the citation when a future Endo design needs to ground POLA in the literature.
- [[object-capability]] — the existing concept page (anchored to Capability Myths Demolished's Model 4 framing) gains another citation here. The four-models taxonomy and the designation-aligned-with-authority framing are complementary perspectives on the same model.
- `papers--miller-capability-myths-demolished-2003--abstract-and-introduction` — the companion paper that names the four capability models; this paper *uses* Model 4 and shows it scales across abstraction layers.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — the same authors' concurrency-control framing of POLA; the statusGetter/statusSetter facet-split example there is a worked instance of the cp/cat lesson at the object-method granularity.
