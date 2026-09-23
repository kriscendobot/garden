---
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_title: "Capability-Based Financial Instruments"
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/capability-based-financial-instruments.pdf
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_pdf_pages: 35
ingested: 2026-05-28
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2000 Financial Cryptography paper by Mark S. Miller, Chip Morningstar, and Bill Frantz that introduces the **Granovetter Operator** as a bridging abstraction across three intellectual communities (object computation, capability-based secure operating systems, financial cryptography), develops the canonical **capability-based money** example with **six demonstrable security properties** verifiable by visual inspection, presents the **Pluribus** distributed protocol with **VatID + swiss number + subjective aggregation** as the cryptographic enactment of capability semantics across mutually-suspicious machines, compares the capability model to SPKI as a public-key infrastructure, develops the **four-axis rights taxonomy** (Shareable/Exclusive, Specific/Fungible, Opaque/Assayable, Exercisable/Symbolic), and walks through the **CoveredCallOption** smart contract as a compositional construction from those primitives — finished by the **TitleCompanyMaker** pattern that adds exclusivity to any sharable instrument.

This is **the canonical citation for several Endo / Agoric primitives** the library has been threading through other papers' sections:

- **Vat as unit of persistence and cryptographic identity.** §4's vat concept is the 2000 ancestor of the Concurrency Among Strangers 2005 §3 expansion; here the vat carries the *cryptographic identity* (VatID = public-key fingerprint) and *export-time-assigned swiss number* per object. Endo's per-agent-keypair concept and the formula-graph's unguessable-id property both trace to this paper.
- **The Granovetter Operator and the six perspectives.** The same Alice-sends-Bob-`foo(carol)` diagrammatic step supports six independent disciplines simultaneously (Objects / Capability Security / Cryptographic Protocol / PKI / Game Rules / Financial Bearer Instruments). The library's `four-ways-to-acquire-references` concept page generalizes this paper's three-way enumeration (Introduction / Parenthood / Construction) to the 2004 four-way enumeration.
- **Sealer/unsealer pair as the rights-amplification primitive.** §3.3's `BrandMaker pair(name)` returns a sealer/unsealer pair (encryption/decryption analogy). The pair has no cryptographic backing — its security comes from reference-graph unguessability — but the structure is precisely Endo's `@endo/marshal` brand primitive.
- **The mint/purse/sealed-decr money example.** §3.4's ~25-line E implementation is the most-cited single example in the capability-security literature. The six demonstrable security properties, verified by visual inspection of three scope+sealing arguments, anchor the library's `security-as-extreme-modularity` concept page and ground Agoric's ERTP design.
- **Subjective aggregation.** §4.3's claim that "only trust makes distinctions" — that mistrust of a vat is equivalent to ignorance of its internal structure, so "we can reason as if we are only suspicious of objects" — is the architectural justification for Endo's per-bundle trust model.
- **The four-axis rights taxonomy.** §6.2's Shareable/Exclusive, Specific/Fungible, Opaque/Assayable, Exercisable/Symbolic axes are the design vocabulary Agoric's ERTP `AmountMath` system encodes.
- **Smart contracts as compositions.** §6.4's CoveredCallOption + §6.5's TitleCompanyMaker are the canonical worked example of a non-trivial financial instrument built compositionally from existing primitives rather than as a bespoke protocol. Agoric Zoe is the production enactment.

## The argument arc

1. **The cooperation problem.** Every new smart contract would seem to require its own cryptographic protocol; protocol design is hard and expensive; therefore cryptographically-enabled commerce is unreachable. The paper's response: find a common abstraction across three communities that lets contracts be composed rather than designed individually.
2. **The Granovetter Operator as bridge.** Alice sends Bob `foo(carol)`. Six independent interpretations apply simultaneously: object message-send, capability authority-transfer, cryptographic protocol step, PKI authorization, game-rule move, financial-bearer-instrument transfer.
3. **The object-capability model.** Lambda + dispatch + side-effects + three connectivity-acquisition mechanisms (Introduction / Parenthood / Construction) + sealer/unsealer pairs as rights amplification.
4. **The mint/purse/sealed-decr money example.** Six demonstrable security properties verified by visual inspection of three scope+sealing arguments. The most-cited capability example in the literature.
5. **Pluribus + VatID + swiss number.** The cryptographic protocol enacting capability semantics across mutually-suspicious machines. Each vat generates a public/private key pair; the public-key fingerprint is the VatID; each exported object gets an unguessable swiss number; transfer of a capability requires the recipient to handshake with the hosting vat over a Diffie-Hellman-keyed channel and only then receive the swiss number.
6. **Subjective aggregation: "only trust makes distinctions."** Mistrust of a vat is equivalent to ignorance of its internal structure. Without loss of generality, capability analysis can reason as if only suspicious of objects. The architectural justification for the Endo per-bundle trust model.
7. **PKI comparison (SPKI).** Same Granovetter Diagram applies; structural tradeoffs differ along auditing, designation (confused-deputy risk), cost, and confinement axes.
8. **Four-axis rights taxonomy.** Shareable/Exclusive, Specific/Fungible, Opaque/Assayable, Exercisable/Symbolic. ERTP's AmountMath design vocabulary maps here.
9. **CoveredCallOption smart contract.** Composition of timer + escrowedStock + escrowedMoney + brand + state. Atomic exercise; deadline-based cancel; sharable-by-default.
10. **TitleCompanyMaker.** Adds exclusivity to any sharable instrument by adapting the §3.4 purse pattern to wrap a single specific object.
11. **The conclusion.** The Granovetter Operator as bridge enables the three communities' strengths to be applied synergistically to a single integrated system.

## For the Endo / Agoric library

This paper is the *fifth Miller-coauthored paper* in the library and the *most domain-specific* of the cluster. While CMD / Paradigm Regained / Structure of Authority / Concurrency Among Strangers articulate the *foundational* discipline (POLA / four-ways / abstraction-as-protection / vat-and-eventual-send), this paper applies the discipline to the **financial-instruments domain** and demonstrates the *compositional* power of the primitives. The library can cite this paper whenever:

- A design names "ERTP" or "issuer-kit" or "purse-and-brand" → §3.4 + §6 are the canonical citations.
- A design names "smart contract" → §6.4 CoveredCallOption is the canonical worked example.
- A design names "vat" with cryptographic connotations (VatID, swiss number) → §4.2 is the canonical citation. (For *concurrency-control* connotations, Concurrency Among Strangers 2005 §3 is the canonical citation.)
- A design names "subjective aggregation" or "only trust makes distinctions" → §4.3 is the canonical citation.
- A design names "rights taxonomy" or specific axes (fungible/specific, etc.) → §6.2 is the canonical citation.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [granovetter-six-perspectives-and-object-capability-model](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model.md) | capability-theory, capability-security, patterns | current |
| [mint-purse-money-and-six-security-properties](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties.md) | capability-security, patterns | current |
| [pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) | capability-theory, capability-security, captp, patterns | current |

The paper's seven sections collapse to three argument-cluster sections in the library: §1-§3.3 → foundations + rights amplification; §3.4 → the canonical money example; §4-§7 → distributed enactment + rights taxonomy + smart contract + conclusion. §2's lambda-and-dispatch derivation, §5's PKI comparison, and §6.3's options-domain background are *supporting* material that doesn't carry distinct theoretical content beyond the three retained sections.

## Provenance

- Fetched 2026-05-28 from `papers.agoric.com/assets/pdf/papers/capability-based-financial-instruments.pdf` per the established Agoric-mirror discipline.
- PDF SHA-256 `49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e`, 35 pages.
- Drafted by the liaison via orchestrator-direct-draft per the maintainer-authorized disposition (`entries/2026/05/17/223038Z-result-liaison-bdf459.md`). Fifth Miller-coauthored paper in the library; this paper plus the four-paper 2003-2005 cluster comprise the library's most-cited capability-theory source set.
