---
title: Abstract
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

§3.5-§3.8 synthesize the paper's argument into four structural claims about how POLA composes across the nested layers of a real system. **§3.5** observes that *nested TCBs follow the spawning tree*: the TCB of each subsystem creates the initial population of subsystems within it and endows them with their initial portion of the authority granted to the system as a whole. The spawning tree's hierarchical structure (Simon's recurrence) is what makes static approaches to POLA — like policy files — viable at the *initial-conditions* level, even when dynamic POLA is needed for the running system. **§3.6** observes that *subcontracting forms dynamic networks of authority*: the topology of who-relies-on-whom changes as components make requests of each other, and the least authority a subcontractor needs to perform a request can often be painlessly conveyed along with the designations that request must already carry. The adjustments needed to the access graph are often *identical* to the adjustments already made to the reference graph for functional reasons. **§3.7** acknowledges that legacy code limits POLA — only co-existence between POLA-disciplined and legacy components enables incremental adoption — but argues this limit is *bounded*: POLA can be enforced *at the boundary* of a legacy component even if it cannot be enforced *inside* it. **§3.8** delivers the paper's quantitative-in-principle claim: nested POLA *multiplicatively* reduces a system's attack surface. The cross-hatched fraction of attack surface removed at each level multiplies into the total; secure languages used according to capability discipline extend POLA to "a much finer grain than is normally sought," so the remaining attack surface resembles a recursively-hollowed fractal. Table 1 summarizes the paper's strongest practical claim: **security IS extreme modularity** — every entry in the right column ("Capability discipline") is just the strict reading of the corresponding entry in the left column ("Good software engineering"). §4 closes by observing that the same hierarchical structures of *knowledge* (which good software engineering already produces via abstraction and information hiding) can be turned into hierarchical structures of *authority* via the natural alignment of designation and authority that object-capability languages provide. To get this, "we need merely make a natural change to our foundations, and a corresponding natural change to our software engineering discipline."
