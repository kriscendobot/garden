---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "19-22 (§5.3 The Arena and Terms of Entry, §5.4 Mutually Suspicious Composition, §6 Conclusion)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Arena (virtual machine within a virtual machine) | An Endo bundle nesting a compartment, possibly with its own sub-bundles. The Endo daemon itself is an arena for bundles; each bundle is an arena for its sub-exos. |
| Terms of entry                             | The compartment construction options + endowment object. The bundle's `Compartment(...)` invocation IS the terms-of-entry checkpoint. |
| Initial conditions                         | The bootstrap petname graph; the daemon's startup endowments. Cycle 47's daemon-persistence ingest names this. |
| Meta-linguistic abstraction                | An Endo bundle hosting a guest module via @endo/static-module-record + @endo/compartment-mapper. The guest sees one language; the host sees the substrate. |
| Mutually suspicious composition            | Two bundles, each holding capabilities they trust, message each other without either trusting the other's *implementation*. The marshal pass-style boundary is exactly this. |
| "Diverse policies over the same graph"     | Two distinct review disciplines (e.g. cleaner's coverage discipline, judge's panel) both applying to the same PR graph, each strict-over-its-own-concerns, conservative-over-everything-else. |
| "Mostly we reused the security properties of the base..." | The architectural justification for *not* adding new primitives to SES every time a new policy is wanted. Build the policy as an exo using existing primitives. |
| "Failures of conservatism" in verification | The failure mode of automated audits over Endo bundles: a static review that flags every endowment as "potentially dangerous" gives no information; the useful audit is *behavioral*. |
