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
source_paper_pages: "15-18 (§3.5 Nested TCBs, §3.6 Subcontracting, §3.7 Legacy, §3.8 Multiplicative Reduction, §4 Conclusions)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity
---

- **"Multiplicative reduction is hand-wavy because we can't quantify it."** §3.8 explicitly concedes that *quantifying* the reduction is largely inaccessible due to knowledge limits. But the *structural* claim — that nesting layers of POLA enforcement compose multiplicatively rather than additively — is testable and rests on the spawning-tree argument from §3.5. Quantification matters less than structural soundness.
- **"Table 1 is just a tidy slogan."** Table 1 is doing structural work. Each row asserts that one capability-discipline practice is the *strict* version of the corresponding software-engineering practice. The architectural claim is that anyone practicing the left column is most of the way toward the right column; the move from one to the other is *cultural* (accepting that the strict reading is achievable) more than *technical*.
- **"Legacy is a deal-breaker for POLA."** §3.7's framing is that legacy is a *bounded limit*, not a deal-breaker. POLA can be enforced at the legacy boundary, and incremental replacement compounds. The architectural prescription is "wrap, don't refuse"; the wrap is the boundary at which POLA holds even if it can't hold inside.
- **"Static POLA is dead."** No. §3.5 explicitly endorses static approaches at the spawning-tree level — the *initial conditions* slice of the access graph is the right place for policy files and static configuration. Dynamic POLA is needed *because the running system extends the access graph via Introduction*, but the initial state can be (and often should be) statically defined.
