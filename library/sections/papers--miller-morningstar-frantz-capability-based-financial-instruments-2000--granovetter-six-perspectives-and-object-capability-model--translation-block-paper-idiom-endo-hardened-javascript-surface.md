---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "1-15 (§1 Overview + §1.1 Introduction + §1.2 Six Perspectives; §2 From Functions To Objects; §3 From Objects to Capabilities, §3.1-§3.3 including Rights Amplification)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Granovetter Operator (`bob.foo(carol)`)    | `E(bob).foo(carol)` — eventual-send with a capability handle as an argument. The library's `four-ways-to-acquire-references` concept page indexes this. |
| Six perspectives                           | The library's organizing principle for capability theory across the four-paper Miller cluster: each paper takes one or two perspectives further. |
| Sealer/unsealer pair (`BrandMaker pair`)   | `@endo/marshal`'s **brand** primitive. A brand pair is the Endo enactment of the sealer/unsealer pair. The "name-for-documentation" hint maps to Endo's brand `iface` parameter. |
| Connectivity by Introduction               | `E()` with a capability argument; marshal pass-style for cross-vat capability transfer. |
| Connectivity by Parenthood                 | A bundle creating a new exo via `makeExo()`; the parent holds the only reference initially. |
| Connectivity by Construction (= Endowment) | A bundle's compartment endowment object; an exo's constructor binding free references. |
| Rights amplification (can + can-opener)    | An exo method that takes two arguments and uses the two together — e.g., `mint.deposit(amount, srcPurse)` uses `srcPurse`'s `getDecr` *only* if the unsealer succeeds. |
| Patterns of cooperation without vulnerability | The library's `patterns` topic; the @endo/patterns package's matcher / guard discipline; the `caretaker-pattern` concept page. |
