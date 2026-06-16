---
title: Implications for Endo
source: Capability Myths Demolished (SRL2003-02)
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_year: 2003
source_venue: JHU SRL Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
parent: papers--miller-capability-myths-demolished-2003--irrevocability-myth
---

This paper is the **canonical upstream citation** for the caretaker pattern in the Endo lineage. The Endo daemon's specific revocation discipline — Handle / HandleControl, vendor-side credentials retained in the control facet, action-side reference held by the delegate — is the same forwarder/revoker construction with names that emphasize the *agent identity* application of the pattern rather than the bare access-control mechanic.

The Endo daemon adds one variation the paper does not name: [[revocation-by-withdrawal]]. The paper's forwarder/revoker pattern requires the revoker R to remain alive to enforce revocation. Endo's formula-graph design adds a structurally distinct revocation mechanism: withdraw the *constructor* (the formula's recipe), and the next time the cohort tries to reconstruct, the dependency is gone. Where caretakers require the principal to remain online to enforce, withdrawal-of-constructor does not. See [[revocation-by-withdrawal]] for the contrast with the caretaker pattern, and the section on `dp/acyclic-formula-graph-and-revocation` for the design's explicit list of three pre-existing mechanisms (caretakers, revocation lists, expiry) it contrasts with.

The phrase the paper coins for the F-and-R decomposition — *forwarding facet* and *revoking facet* — is the source of Endo's *facet* vocabulary in `defineExoClassKit`. An exo class kit defines multiple facets sharing state; the canonical example is the {forwarder, revoker} kit, which is exactly the paper's construction expressed in modern E / Endo idiom.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
