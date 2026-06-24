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
source_paper_pages: "6-15 (§2.2 Fractal Locality of Knowledge, §3 Fractal Nature of Authority, §3.4 Object-Granularity POLA)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Introduction (A sends `b.foo(c)`)          | `E(b).foo(c)` — passing a capability through eventual-send. Pre-resolved or unresolved; the receiver gets a usable reference regardless. |
| Parenthood (B creates C)                   | A bundle instantiating a new exo via `makeExo()` or a constructor. The parent holds the only reference to the child initially. |
| Endowment (B is born with c)               | A bundle endowed with specific capability handles at compartment-construction time. The endowment is fixed at the moment of creation. |
| Initial Conditions                         | Endo daemon startup — the initial petname graph + root host object are the "initial conditions" everything else descends from. |
| "Only connectivity begets connectivity"    | The Endo invariant that the formula graph is the access graph. Marshal preserves this across pass-style boundaries by refusing to fabricate references the sender doesn't already hold. |
| "Imported B module must not magically come into existence with authorities not granted by its importer" | Endo's compartment endowment discipline: a compartment is hard-isolated by default; every authority it exercises must trace back to something the parent compartment / bundle explicitly granted at construction time. |
