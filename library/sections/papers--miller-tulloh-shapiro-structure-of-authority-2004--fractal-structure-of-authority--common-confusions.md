---
title: Common confusions
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

- **"The four ways are pluralistic — there might be others."** No. §3.4 makes the exhaustiveness claim explicit and proves it by exclusion: any way for B to come to know about C must either be a fact of the universe-of-discourse's initial state (Initial Conditions), or involve a third object A connecting B to C (Introduction), or involve B coming into existence already-connected (Endowment), or involve C coming into existence in B's hands (Parenthood). These are the only possibilities; any "new" way collapses to one of these four.
- **"Endowment is just constructor injection."** Endowment is structurally identical to constructor parameter injection *when the parameter is a capability reference rather than a value*. The §3.4 framing reveals why constructor injection is the discipline it is: it enacts Endowment, which is one of the only four authority-transfer mechanisms.
- **"Hierarchy and subcontracting are competing models."** No. The §2.2 framing combines them: hierarchy is the *static* skeleton (Simon), subcontracting is the *dynamic* topology (Hayek), and POLA is enforceable only because both hold. A purely flat system would lack the locality that makes least-authority computable; a purely static system would lack the dynamic responsiveness that makes least-authority appropriate.
- **"Only connectivity begets connectivity is just GC reachability."** GC reachability is *one* consequence — disjoint subgraphs can be collected because they cannot affect anything reachable. But the rule is stronger than GC: it also gives the *security* result that disjoint subgraphs cannot affect each other, and the *composition* result that two-near-disjoint subgraphs interact only through their bridging objects. These three results share the same structural cause.
