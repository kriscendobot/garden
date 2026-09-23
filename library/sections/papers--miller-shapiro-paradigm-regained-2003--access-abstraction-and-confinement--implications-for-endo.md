---
title: Implications for Endo
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

These sections are the *theoretical anchors* for several Endo primitives often taken for granted as engineering choices:

1. **Brand / trademark is a foundational primitive, not a convenience.** Endo's @endo/marshal brand mechanism IS the FactoryStamp pattern. The §5 confinement argument *depends* on brands working; without them Cassie cannot verify the calcFactory she received from Max is actually a factory and not a back-channel.
2. **Modularity gives access control for free.** §4.5's claim is the *most-cited* library citation for why Endo's good-software-engineering discipline IS its security discipline. The hardener, the lockdown, the marshal pass-style: each is a strict reading of an existing JS practice (deep-freeze; no ambient state; explicit serialization boundaries).
3. **Confinement is achievable in JavaScript.** The §5 Cassie+Max confinement is exactly what an Endo bundle does when it loads a guest module into a compartment with a curated endowment object. The Endo daemon's bundle-loading is the production enactment of `cassie.acceptProduct(calcFactory)`.
4. **Object-capabilities are non-discretionary.** §5.1 is the citation for why Endo's *creator does not own creation* — when an exo constructs a child exo, the constructor's parent does not automatically gain authority to the child. Authority flows by *Endowment* and *Introduction* (the four-ways enumeration), not by parenthood-implies-rights.
5. **The *-property challenge has a positive answer.** §5.2's Cassie-diode example shows that capability-based systems *can* enforce one-way information flow, contradicting a 30-year-old impossibility folklore. Endo can build the analogous one-way channel using a pair of exos with shape-guarded methods over a shared closed-over variable. The library can cite this whenever Endo work needs to defend against the "capabilities can't do MLS" objection.
