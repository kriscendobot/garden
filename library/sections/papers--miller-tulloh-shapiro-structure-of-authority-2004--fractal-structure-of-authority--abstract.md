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
source_paper_pages: "6-15 (§2.2 Fractal Locality of Knowledge, §3 Fractal Nature of Authority, §3.4 Object-Granularity POLA)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority
---

§2.2 names the structural pattern that makes the paper's argument work: knowledge in well-engineered systems exhibits **fractal locality**. Complex systems are hierarchical and recursive (Simon's hierarchy argument) AND within each layer, dynamic subcontracting networks of clients and providers form (Hayek's local-knowledge argument). The static-and-dynamic combination means "least authority" can only be determined *locally*: no central planner has the knowledge to compute what authority every level needs, just as Hayek argued no central planner has the knowledge to allocate economic resources. The implication for POLA is structural: authority-allocation must be *as local as the design knowledge it serves*. §3 names this as the **fractal nature of authority** and surveys four levels of composition (people in an organization, applications launched from a desktop, modules within an application, language-level objects) at which the same POLA logic applies. The paper's deepest contribution is §3.4's **four ways one object can come to know about another**: by *Introduction* (an existing third object shares the reference), by *Parenthood* (an existing object creates the new one), by *Endowment* (an existing object creates a new object pre-bound to a known reference), and by *Initial Conditions* (the universe started this way). These four are *exhaustive* — there is no other way for two previously disconnected subgraphs to come to know about each other. The rule that **only connectivity begets connectivity** falls out as a corollary, and from it the further claim that the reference graph *is* the access graph in any system where these are the only ways objects come to know about each other.
