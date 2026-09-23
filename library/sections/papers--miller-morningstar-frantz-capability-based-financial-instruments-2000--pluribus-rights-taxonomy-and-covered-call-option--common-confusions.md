---
title: Common confusions
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "20-32 (§4 Pluribus distributed protocol; §4.3 Subjective Aggregation; §5 PKI comparison; §6 Financial Instruments + four-axis rights taxonomy + CoveredCallOptionMaker + TitleCompanyMaker; §7 Conclusion)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, captp, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option
---

- **"Pluribus is the same as TLS."** Pluribus uses SSL-like handshake mechanics (key exchange, mutual authentication) but adds the *capability semantics* — the swiss number is revealed only after secure-connection establishment, and the result is a *capability* (an arrow with two ends), not just a confidential channel. TLS provides confidentiality; Pluribus provides confidentiality *plus* capability semantics.
- **"Subjective aggregation means everyone has a different view of reality."** No — the *graph* is objective; the *aggregation* is subjective. All parties see the same reference graph; what differs is how each party *groups* objects in the graph into composites for analysis. The §4.3 "only trust makes distinctions" is the architectural framing: refusing to make a distinction is equivalent to suspicion.
- **"The swiss number is just a UUID."** No — it must be unguessable. UUIDs are not cryptographically unguessable; swiss numbers must come from a cryptographically secure random source large enough that collision probability is negligible. Endo's formula identifiers preserve this property.
- **"The CoveredCallOption requires trusting the broker."** Yes, and the §6.4 paper is explicit: *"Assume the existence of a broker mutually trusted by the option buyer and seller."* The broker's role is to be the source of the `CoveredCallOptionMaker` invocation; both option-writer and option-buyer must trust the broker not to subvert the contract code. Agoric Zoe addresses this by hosting contract code in a vat that both parties can verify the hash of, rather than trust personally.
- **"Capability systems can't audit who did what."** §5's structural argument is that auditing in capability systems requires *introducing intermediary objects* to track the authorization path, where SPKI gets auditing for free from the public-key structure. The tradeoff is real; the answer is that capability systems can compose auditing-objects (a Caretaker-like wrapper that logs invocations) where SPKI compels it. Endo's journal-as-message-bus pattern is the garden's enactment of this auditing-via-composition idea.
- **"The four-axis taxonomy maps cleanly to ERTP."** Yes for two axes (Specific/Fungible, Exclusive/Shareable) and partially for the others. Exercisable/Symbolic doesn't have a sharp ERTP analog because ERTP amounts are *always* exercisable through the issuer; Opaque/Assayable is partially captured by the brand-equality check ERTP provides. The taxonomy is more general than ERTP's design space.
