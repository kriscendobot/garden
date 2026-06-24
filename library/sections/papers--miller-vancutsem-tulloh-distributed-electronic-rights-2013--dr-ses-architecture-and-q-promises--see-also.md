---
title: See also
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "1-10 (§1 Smart Contracts for the Rest of Us; §2 Dr. SES with §2.1-§2.5)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, eventual-send, captp, persistence]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises
---

- [[vat-and-compartment]] — the structural-isolation primitive. Dr. SES compartments are the JavaScript realization; the concept page now spans both vintages.
- [[principle-of-least-authority]] — POLA at the SES whitelisted-globals layer is the architectural enforcement.
- [[brand-and-trademark]] — WeakMap in SES is the rights-amplification primitive; ES6 native, frozen by lockdown.
- [[smart-contract]] — §6 Contract Host is the smart-contract layer this paper develops. The cycle-77 concept page now has the Dr. SES lineage anchor.
- [[mint-purse-money]] — §4 makeMint code in §4 of this paper is the JavaScript realization of the 2000 mint-purse pattern.
- [[promise-pipelining]] — Q's `!` and promise combinators are the substrate that makes pipelining possible in JavaScript.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the 2005 paper's offline-capabilities + vat-checkpoint machinery is the structural ancestor of NodeKen.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties` — the 2000 paper's mint-purse example reappears in §4 of this paper, in JavaScript.
