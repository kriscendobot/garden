---
title: Common confusions
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

- **"Three connectivity mechanisms vs four."** The 2000 paper enumerates three (Introduction, Parenthood, Construction); the 2004 paper enumerates four (Introduction, Parenthood, Endowment, Initial Conditions). They're compatible — *Construction* is the 2000 name for what *Endowment* names in 2004, and the 2004 paper adds *Initial Conditions* as the bootstrap-time mechanism the 2000 paper implicitly assumed. Use the 2004 four-way list as the canonical reference; this paper's three-way version is the historical first cut.
- **"Sealer/unsealer is cryptographic."** No — it is *like* public/private key pairs but is a *language-level* primitive. The unguessability is enforced by reference-graph constraints, not cryptographic hardness. Endo's brand primitive is the same: brand unguessability is enforced by the SES realm, not by cryptography.
- **"The Granovetter Operator is just a function call."** It is a function call *plus* an authority transfer. The §1.2 perspective enumeration is the framing: the same call simultaneously supports six independent interpretations, and the capability-security interpretation is what makes it more than a function call.
- **"BrandMaker's name argument is part of the seal."** No — it is *purely for documentation and debugging*. The security comes from the unguessability of the sealer/unsealer pair itself, not from any string label.
- **"Object computation = capability computation."** No — object computation is the lambda + dispatch + side-effects substrate. Capability computation *adds* the three prohibitions (no forged references, no mutable global state, encapsulation absolute) to make *only connectivity begets connectivity* hold. The §3 enumeration is precisely the set of constraints needed.
