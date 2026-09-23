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
source_paper_pages: "15-18 (§3.5 Nested TCBs, §3.6 Subcontracting, §3.7 Legacy, §3.8 Multiplicative Reduction, §4 Conclusions)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity
---

- [[principle-of-least-authority]] — *deferred concept page*. Table 1 is the canonical content for that page; this section is one of three citations (along with `defensive-correctness-and-pola` from Concurrency Among Strangers and `advantages-pola-confused-deputy` from Capability Myths Demolished).
- [[object-capability]] — Table 1's "no global name spaces" and "forbid mutable static state" entries are the strictness conditions that make the four-models-Model-4 framing operational.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — the same authors' concurrency-control framing of POLA. This paper's Table 1 is the *modularity-side* mapping; that paper's defensive-correctness/consistency framing is the *concurrency-side* mapping. Same discipline, two perspectives.
- `papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties` — the seven properties (A-G) are the formal characterization; Table 1 is the *engineering-practice* characterization.
- `endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly` — the implementation-level enactment: handled-promise's reduction of `applyMethod` into `get` + `applyFunction` is exactly the "designation conveys authority" pattern at the eventual-send substrate level.
