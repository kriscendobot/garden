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
source_paper_pages: "1-6 (§1 Excess Authority, §1.1 How Much Authority Is Adequate, §2 Composing Complex Systems, §2.1 Object-Capability Model)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| cp's "authority over the user's namespace" | A bundle granted broad endowment access. Avoided by Endo's "endow only what's named" discipline.       |
| cat's pre-opened file descriptor model     | Endo's pattern of passing pre-resolved capability handles into bundles instead of name strings.        |
| Reference as designation + authority       | An Endo formula handle or `E()`-able proxy. Holding the reference *is* the right to invoke.            |
| Static sandboxing                          | Compartment-with-static-endowments. Useful but cannot adapt to dynamic designation.                    |
| Dynamic least authority                    | Endo's preferred posture — each bundle gets the smallest endowment object adequate to the task at the moment it is granted, computed from the user's designation. |
| Object-capability model                    | The model Endo's compartment + lockdown + marshal stack enacts in JavaScript. The reference graph between exos and bundles is the access graph. |
| POLA (need-to-do)                          | The discipline scholar's [[principle-of-least-authority]] concept page (deferred) will anchor.         |
