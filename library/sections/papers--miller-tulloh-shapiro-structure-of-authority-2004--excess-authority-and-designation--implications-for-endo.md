---
title: Implications for Endo
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

This section is the *philosophical anchor* for Endo's whole posture on bundle endowment. The cp-vs-cat distinction is the operational principle behind decisions like:

1. **Endow bundles with capability handles, not paths.** When a bundle needs to read a specific document, the user designates that document through the petname graph and the daemon hands the bundle a capability to read *that* document — never the authority to read arbitrary documents in the user's home.
2. **Avoid the "TCB = anything launched by the user" antipattern.** Endo's bundle-launching is closer to CapDesk than to conventional shell launching: a bundle's authority is determined by what was *designated to it* at start, not by what the launching user could have done.
3. **The reference graph IS the access graph.** Endo's formula graph and petname graph together form the same kind of access graph the paper names. Forwarding restrictions, sealing, and marshal's pass-style classifications are all about preserving the access-graph invariant across bundle / vat / network boundaries.
4. **POLA is a discipline, not a feature.** Endo provides the *substrate* (compartment + lockdown + capability-aligned references) but the discipline of granting need-to-do authority is a *design pattern* each Endo application enforces for itself. The paper's framing makes this explicit: POLA can only be practiced where designation is well-aligned with authority.
