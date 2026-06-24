---
title: See also
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "7-14 (§4 The Object-Capability Paradigm, including §4.1 Model, §4.2 A Taste of E, §4.3 Redell's Caretaker, §4.4 Analysis and Blind Spots)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker
---

- [[caretaker-pattern]] — the existing concept page; this section is the *canonical worked-code* citation. Cycle 66's notes also surface the handled-promise.js implementation-rationale parallel.
- [[principle-of-least-authority]] — deferred concept page. §4.4 is the citation that motivates *why* POLA needs to be the discipline — because permission-only analysis is structurally inadequate.
- [[four-ways-to-acquire-references]] — deferred concept page. §4.2's `loader.load(code, [...x ⇒ x, y ⇒ y])` is the *Endowment* mechanism in `papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority` enumerated form.
- `papers--miller-capability-myths-demolished-2003--irrevocability-myth` — the companion paper's framing of the same Redell-1974 result; CMD's *Property E (Composability)* is the formal characterisation.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority` — the four-ways enumeration; Endowment is the §4.2 transformation rule.
