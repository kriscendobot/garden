---
title: Translation block (E idiom → Endo / JavaScript surface)
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

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Spawning tree                              | Endo's daemon → bundle → sub-bundle → compartment → exo hierarchy. Each parent creates and endows its children. |
| TCB at each layer                          | The host (kernel) is the OS TCB; the Endo daemon process is the daemon TCB; each bundle's main() is its own TCB; each exo is its own TCB. Recursion all the way down. |
| Subcontracting via designation             | An exo passing a capability handle to another exo via `E()` arguments. The receiver gets exactly the authority needed to honor the request, no more. |
| Legacy boundary                            | An Endo bundle wrapping a Node-native or NPM-installed library. POLA enforced at the wrapper boundary; nothing finer-grained inside. |
| Multiplicative attack-surface reduction    | The architectural justification for Endo's deep nesting: daemon, bundle, compartment, exo, individual method endowments. Each layer's POLA multiplies into the total. |
| Table 1: security as extreme modularity    | The discipline Endo invites every bundle to follow: `harden()`, no `globalThis`, explicit endowments, brand-by-reference, strict pass-style boundaries. Each is the strict reading of a JavaScript best practice. |
