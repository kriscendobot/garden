---
title: Common confusions
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

- **"This is real money."** §3.4's opening disclaimer is explicit: this example provides *none* of blinding, non-repudiation, accounting controls, or asset backing. It is a *minimal* example demonstrating that capabilities can express the structure of money; it is not a recommendation to deploy this code. Agoric ERTP and similar production systems add the missing properties on top of the same structural pattern.
- **"Property 6 requires trusting the network."** No — Property 6 says trust in the *deposit report* is bounded by trust in the *receiving purse's code*. The receiving purse is Bob's own; Bob can inspect its code or otherwise have reason to trust it. The network is not in the trust path because the receiving purse's `deposit` method is the one verifying.
- **"The unsealer could be stolen by inspecting the mint."** §3.3 sealer/unsealer pairs are unguessable language primitives. Inspection of the mint *from outside* cannot reach the sealer/unsealer — they are free variables of nested closures, only reachable from inside the mint's scope. *Only connectivity begets connectivity* protects them.
- **"`decr` could escape by being passed to an attacker as a sealed envelope."** Yes, it can — but the *envelope* is useless without the matching unsealer, which is only accessible to the matching mint's purses. The attacker holding a sealed `decr` envelope can pass it around but cannot use it.
- **"This requires named brands ('MarkM')."** No — the `name` parameter is purely cosmetic. Strip it (along with `printOn`) and all six properties still hold. The brand's *identity* is its sealer/unsealer pair, not the string label.
- **"Visual inspection isn't a proof."** §3.4's closing argument is that scoping + sealing arguments are *sufficient* given the language-level enforcement of *only connectivity begets connectivity*. The proof is informal but rigorous: the inspector identifies the load-bearing scope boundaries, verifies the sealer/unsealer never escape, and concludes the properties hold. This is the *security-as-extreme-modularity* discipline (the 2026-05-21 library concept page) applied to this example.
