---
title: Abstract
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

§3.4 presents what has become **the most-cited single example in the capability-security literature**: a complete money implementation in ~25 lines of E built entirely from object-capability primitives + sealer/unsealer pairs from §3.3. The construction is deliberately minimal — it explicitly does *not* provide blinding, non-repudiation, accounting controls against a cheating issuer, or asset-backing — but it demonstrably has **six security properties** that can be verified by *visual inspection of the code*: (1) only someone with the mint of a given currency can violate conservation of that currency; (2) the mint can only inflate its own currency; (3) no one can affect the balance of a purse they don't have; (4) with two purses of the same currency, one can transfer money between them; (5) balances are always non-negative integers; (6) a reported successful deposit can be trusted as much as one trusts the purse one is depositing into. The structural insight that makes this example matter for the library: **capability discipline enables visual-inspection security proofs**. A reader can scan the code, identify the few load-bearing scope-and-sealing properties, and verify the six properties without needing to reason about the entire universe of programs that might interact with the money. The §3.4 walkthrough of `Alice pays Bob $10` is the canonical Alice-Bob worked example for object-capability programmers; the `deposit` method's use of `unsealer unseal(src getDecr)(amount)` is the canonical *rights amplification* application (you must hold *both* a same-currency purse AND have an amount within balance for the transfer to succeed).
