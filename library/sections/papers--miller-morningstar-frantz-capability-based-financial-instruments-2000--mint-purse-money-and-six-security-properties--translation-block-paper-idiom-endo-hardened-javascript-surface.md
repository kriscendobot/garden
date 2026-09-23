---
title: Translation block (paper idiom → Endo / Hardened JavaScript surface)
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "15-20 (§3.4 Simple Money — the canonical capability-based money example with its six security properties walked through Alice-pays-Bob)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties
---

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| MintMaker / mint / purse                   | `@agoric/ertp` (or the Agoric IST module equivalent): `makeIssuerKit` → `{ mint, brand, issuer }`. The Endo / Agoric production enactment of this paper's worked example. |
| `BrandMaker pair(name)`                    | `@endo/marshal`'s `makeBrand(iface)` returning a brand. |
| `sealer seal(decr)`                        | A brand-stamped value; @endo/marshal-style "mark this as belonging to this brand". |
| `unsealer unseal(envelope)`                | A brand-checked unwrap; throws if the value wasn't stamped by the matching brand. |
| `decr(amount : (0..balance))`              | An exo method with a method-guard from @endo/patterns: `M.gte(0)` and `M.lte(balance)` shape constraint. |
| `purse.sprout`                             | An issuer method that creates a fresh empty purse of the same brand. Agoric ERTP equivalent: `issuer.makeEmptyPurse()`. |
| `deposit(amount, src)` with sealed-decr verification | An exo method that uses brand-verification via @endo/patterns to confirm `src` is a same-brand purse before invoking its internal balance-mutation. |
| Visual-inspection proof methodology        | The discipline an Endo design reviewer follows: identify the load-bearing scope + brand properties, verify them by reading, accept the design without exhaustive code-path analysis. |
