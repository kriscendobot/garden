---
title: Implications for Endo
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

This example is the **canonical citation for several Endo / Agoric primitives and disciplines**:

1. **Brand discipline is sealer/unsealer.** The brand pair Endo's `@endo/marshal` provides IS the §3.3 sealer/unsealer pair. The MintMaker example is the canonical use of brands: the mint's brand stamps the `decr` envelope; the purse's brand-verification on incoming `getDecr` envelopes enforces same-currency.
2. **Rights amplification by composition.** The `deposit` method demonstrates that two references brought together can yield authority neither has alone: you need *both* a same-currency purse AND an amount-within-balance for the transfer to succeed. This is the operational form of §3.3's can+can-opener. Endo's `@endo/exo` class kit method-guards are the language-level enforcement.
3. **The six demonstrable security properties as a design checklist.** When an Endo design proposes a new value-bearing instrument (purse, escrow, escrow-purse-with-policy), the design review can directly invoke the six properties as a checklist. Property 1 (conservation), Property 4 (transferability), and Property 6 (deposit-report trust) are the most-load-bearing.
4. **Visual-inspection proofs.** The §3.4 closing argument that scoping + sealing arguments are *sufficient* to prove security properties is the design-review methodology Endo design reviews implicitly follow. The library can cite this section as the *theoretical justification* for not requiring exhaustive model-checking on Endo bundles whose authority structure is clear-by-inspection.
5. **Agoric ERTP is this example, productionized.** Agoric's Electronic Right Transfer Protocol (ERTP) — the `makeIssuerKit` → `{ mint, brand, issuer }` pattern — is the production enactment of this §3.4 paper code. The library should cite this section whenever discussing ERTP design choices that trace back to the §3.4 invariants.
