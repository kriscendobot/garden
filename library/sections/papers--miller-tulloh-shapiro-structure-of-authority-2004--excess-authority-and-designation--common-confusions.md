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
source_paper_pages: "1-6 (§1 Excess Authority, §1.1 How Much Authority Is Adequate, §2 Composing Complex Systems, §2.1 Object-Capability Model)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation
---

- **"POLA is about denying capabilities."** No. POLA is about *granting capabilities precisely matched to need*. The §1 framing makes clear that withholding authority (the applet stance) is just the failure mode of denying functionality; POLA aims to be cooperative AND safe simultaneously, which requires *granting* the right authority at the right moment.
- **"Capabilities and ACLs are interchangeable access-control mechanisms."** No. The §2.1 architectural claim is that the object-capability model *eliminates* access control as a separable concern; capability discipline is *not* an access-control mechanism layered over a modular system — it is a *property* of how the modular decomposition is done. ACL systems treat access control as a separate concern; capability systems don't.
- **"cat is more secure than cp because cat is shorter."** No. The §1.1 lesson is that cat is more secure because *the shell* performs the designation in the user's namespace before invoking cat, so cat receives a *narrow capability* (a file descriptor) instead of a *broad credential* (the user's filesystem authority). The architectural property is in the shell-cat composition, not in cat itself.
