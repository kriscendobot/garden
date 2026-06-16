---
title: Implications for Endo
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

This paper is the **canonical citation for several Endo primitives**:

1. **The brand pair (`@endo/marshal`) is the sealer/unsealer pair.** When Endo code constructs a brand with `makeBrand()` or via the `iface` shape, the §3.3 sealer/unsealer pattern is what's being enacted. The library can cite this section for the *theoretical* grounding of why brands are the right primitive (rather than e.g. cryptographic signatures).
2. **The Granovetter Operator is `E()`.** Every `E(target).method(arg)` invocation is a Granovetter step. The library's `four-ways-to-acquire-references` concept page (added 2026-05-21) generalizes the three-way enumeration this paper introduces to the four-way enumeration *Structure of Authority* 2004 finalizes.
3. **Patterns of cooperation without vulnerability.** §3.2 names this as the goal of capability discipline; the library's `patterns` topic and the `caretaker-pattern`, `four-ways-to-acquire-references`, and `security-as-extreme-modularity` concept pages are all entries in that growing taxonomy. The §3.2 framing ("required trust is a form of dependency") is the most-quoted one-line justification for why Endo design reviews are authority-reviews rather than just structural reviews.
4. **The six perspectives framing applies to Endo's documentation.** Endo design docs and explanations targeting different audiences (engineers vs reviewers vs ecosystem partners vs financial-applications builders) can be organized around the same diagrammatic step seen from the audience's home perspective. This paper is the model.
