---
title: See also
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "14-19 (§5 The Escrow Exchange Contract; §6 The Contract Host; §7 Conclusions)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, eventual-send, patterns]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host
---

- [[smart-contract]] — the umbrella concept page. The §5 escrow exchange + §6 Contract Host are the canonical 2013-JavaScript worked example. The cycle-77 concept page now has the Dr. SES lineage anchor and the Zoe production-ancestor lineage.
- [[mint-purse-money]] — §5 escrow exchange uses the §4 mint-purse code as foundational primitive. The two patterns compose.
- [[brand-and-trademark]] — the Q.join on `makePurse` is brand verification at the JavaScript level.
- [[principle-of-least-authority]] — the Contract Host needs *only* the contract source + Q + tokens to run; no other authority. POLA at the contract-runtime layer.
- [[vat-and-compartment]] — the contract runs in a `confine`-isolated compartment; one bundle per contract instance.
- [[agoric-system]] — the broader framework. Zoe is the production agoric-system component this paper anticipates.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the 2000 §6.4 CoveredCallOption is the E-language ancestor of the §5 escrow exchange.
