---
title: Implications for Endo
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

This section is the structural justification for several Endo invariants that might otherwise look like implementation choices:

1. **The formula graph IS the access graph.** Endo persists the formula graph because *the formula graph is the persistent record of who-can-access-whom*. The four ways a new formula can come to exist (introduction by passing through marshal; parenthood via new-formula construction; endowment via initial-formula bindings; initial conditions = the daemon's bootstrap petname graph) are the same four enumerated in §3.4. Endo's persistence model — *persistence by traversal from petname roots* — directly enforces "only connectivity begets connectivity."
2. **Marshal's pass-style discipline preserves connectivity.** When values cross a marshal boundary (out-of-process, on the wire, into a fresh bundle), marshal preserves the invariant that the receiver cannot acquire references the sender doesn't already hold. The smallcaps tagged-record syntax, the `@qclass` annotations, and the brand/sealing primitives all serve this invariant.
3. **Endowments are explicit.** Endo bundles do not silently gain authority from the surrounding host; everything in their compartment-construction endowment object is what they will ever have unless future *introductions* (eventual-send passing of new capabilities) extend their access graph. This is the operational form of "imported B module must not magically come into existence with authorities not granted by its importer."
4. **The fractal locality argument justifies bundle composition.** Endo's nested-bundle / nested-compartment posture (a bundle can spawn a sub-bundle with a subset of its own authority) is the operational form of nested POLA. The §3.5 framing (nested TCBs follow the spawning tree) is the architectural blueprint Endo's daemon-bundle-compartment hierarchy enacts.
