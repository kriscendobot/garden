---
title: See also
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "14-19 (§4.5 Access Abstraction, §5 Confinement, §5.1 Non-Discretionary Model, §5.2 The *-Properties)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement
---

- [[caretaker-pattern]] — the existing concept page. The factory + factoryMaker pattern is structurally identical at one abstraction level up: caretaker mediates *one* target, factory mediates *one* code-and-state-template.
- [[principle-of-least-authority]] — deferred concept page. §4.5's "POLA simply adds that authority should be handed out only on a need-to-do basis" is the canonical one-line statement.
- [[four-ways-to-acquire-references]] — deferred concept page. §5's Cassie-confines-Max example demonstrates the *Endowment* mechanism in its purest form: state from Cassie, code from Max, instance is born already-endowed.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity` — the §4.5 "modularity gives access control for free" thesis is the seed of *Structure of Authority*'s Table 1 ("security as extreme modularity").
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — Concurrency Among Strangers' "defensive correctness despite arbitrary client behavior" is the partial-failure-side companion to this section's *-property argument.
