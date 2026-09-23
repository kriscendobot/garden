---
title: Implications for Endo
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

This section is the **direct architectural ancestor of Agoric Zoe**. The library can cite this paper whenever:

1. **A design names Zoe or smart-contract framework.** §6's Contract Host is Zoe at 22 lines of JavaScript. The contemporary Zoe is the production scaling with additional concerns (deployable contract instances, governance, fees, etc.) but the structural pattern is unchanged.
2. **A design discusses atomic swap / escrow / two-phase commit at the contract layer.** §5 is the canonical worked example. The Q.all + Q.race + failOnly composition is the canonical atomic-commit pattern.
3. **A design discusses contract-participation tokens.** §6's *redeem the token to obtain the exclusive right to play* is the structural ancestor of Zoe's *invitation* primitive. The four-axis taxonomy applies cleanly.
4. **A design discusses what counterparties must agree on.** §6's four-point list (issuers, contract source, side assignment, mutually-trusted contract host) is the canonical answer.
