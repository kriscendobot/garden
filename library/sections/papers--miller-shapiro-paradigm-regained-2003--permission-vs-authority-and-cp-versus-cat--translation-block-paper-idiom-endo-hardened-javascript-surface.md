---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "1-7 (§1 Introduction, §2 Terminology and Distinctions, §3 How Much Authority Does cp Need?)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Permission (de jure)                       | What an exo's compartment endowment object directly contains; the surface bindings.                    |
| Authority (de facto)                       | What that exo can ultimately cause via the methods of objects in its endowment that themselves call elsewhere. |
| Direct access right                        | Holding a reference / proxy that responds to method invocations.                                       |
| Indirect access right                      | Authority a bundle gains transitively by being able to message another bundle that holds something useful. |
| Arrangement-only bound                     | Static analysis of the formula graph: which formula ids appear in which bundle's endowment.            |
| Partially behavioral bound                 | Code review of specific exos: do they re-expose endowments, or do they restrict the surface?           |
| cp pattern (path strings)                  | A bundle that takes a *path* parameter and resolves it against ambient filesystem authority. Avoided. |
| cat pattern (pre-resolved descriptors)     | A bundle that takes pre-resolved capability handles as constructor arguments. Endo's normal pattern.   |
| "Subjects extend the expressiveness of a base by building abstractions" | An exo wrapping a more-powerful capability to expose a narrower interface. The library's `caretaker-pattern` concept. |
