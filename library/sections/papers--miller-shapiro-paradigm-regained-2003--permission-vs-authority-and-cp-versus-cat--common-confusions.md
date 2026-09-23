---
title: Common confusions
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

- **"Permission analysis is sound; it just gives loose bounds."** Permission analysis *is* sound as a bound on permission. It is *not* sound as a bound on authority — the §4 analysis-and-blind-spots section will show that a permission-only analyzer can declare a system safe that has clear authority leaks via behavioral abstractions like the Caretaker.
- **"Bishop-Snyder's de jure and de facto are independent."** No — *de facto* (authority) properly includes *de jure* (permission); the paper presents them as nested analysis classes, not parallel ones.
- **"cp's least authority is just `read foo.txt + write bar.txt`."** That is what cp's least authority *should* be. What cp's least authority *actually is*, given that cp resolves the path strings itself, is *the user's full filesystem authority*. The point of the §3 lesson is that the architecture forces the broader bound; only the cat-style refactor relaxes it.
- **"Saltzer-Schroeder said `least privilege`, so the term is least *privilege* not least *authority*."** Saltzer-Schroeder's term is ambiguous; the paper makes the ambiguity explicit and chooses *least authority* as the more architecturally useful reading. POLA-as-least-authority is the Endo / Agoric library convention.
