---
title: See also
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "9-22 (§3 Dynamic Sealing + §4 Caretaker + §5 Membrane)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane
---

- [[capability-security]] (topic) — OCPL's three OCPs map directly to contemporary capability-security patterns.
- [[capability-theory]] (topic) — the formal-Hoare-style program logic for OCPs joins cycle-85's Drossopoulou Hoare-logic and cycle-91's Taly Datalog analysis.
- [[hardened-javascript]] (topic) — HLA's representation of OCPs in a generic higher-order concurrent language; HardenedJS is the contemporary realization.
- `papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety` — the prior section: the OCPL foundation that this section's specifications build on.
- `papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane` — the third section: how OCPL relates to prior work + Iris foundations + Firefox same-origin-policy membrane future work.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the cycle-82 escrow exchange uses dynamic sealing for the contract participation tokens; OCPL could verify the §6 Contract Host pattern.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the canonical Mint pattern that §3 verifies as conservation-of-currency.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint` — cycle-91's Taly et al verified the *same* three OCPs (Sealer-Unsealer, Mint) using ENCAP's static Datalog analysis. OCPL's program-logic approach is the program-logic complement to Taly's static-analysis approach.
