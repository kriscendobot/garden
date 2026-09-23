---
title: Common confusions
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

- **"Capabilities can't revoke."** §4.3 + §4.4 are the canonical refutation. Capabilities-as-bare-references cannot revoke, but Redell's 1974 *Caretaker pattern* — a behavioral abstraction *built from* capabilities — does revoke. The infeasibility-of-revocation literature relies on permission-only analysis that the Caretaker is invisible to.
- **"Behavioral analysis is too hard."** Per §4.4: "Alice should use arrangement-only analysis for reasoning about what potential adversaries may do. But Alice also interacts with many objects, like the Caretaker, *because she has some confidence she understands their actual behavior*." Behavioral analysis is *targeted* — applied to the small set of trusted behavioral abstractions in any given design, not to every untrusted subject.
- **"The Caretaker requires `var`. JavaScript has `var`, so we're fine."** Conceptually right but watch the encapsulation: in E, `var target` is *encapsulated by* the enclosing `caretakerMaker.make` scope. In JavaScript, the equivalent is `let target` inside the constructor closure — not a free `var target` at module top level (which would be shared across all Caretaker instances and would leak between bundles).
- **"`E.call(target, verb, args)` is dangerous because it's generic dispatch."** It is generic dispatch, but Bob *cannot reach `target` directly* — he can only message `carol2`, which calls `E.call(target, ...)` *internally*. The genericity is *internal to the Caretaker*; the discipline is that Bob's authority is bounded by what the Caretaker chooses to forward.
