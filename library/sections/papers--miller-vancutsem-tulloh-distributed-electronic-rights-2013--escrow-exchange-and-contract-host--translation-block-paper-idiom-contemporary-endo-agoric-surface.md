---
title: Translation block (paper idiom → contemporary Endo / Agoric surface)
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

| 2013 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| Escrow exchange contract | Agoric Zoe's *atomic swap* contract is the production enactment. |
| Q.join on shared `makePurse` for purse verification | Agoric ERTP brand-check: `issuer.getBrand() === expectedBrand` is the modern verification. |
| Contract Host with setup + play tokens | **Agoric Zoe** is the production realization. Zoe's *invitation* primitive is the 2013 token; Zoe's contract-instance setup-and-offer flow is the §6 setup-and-play flow. |
| Confine for evaluating contract source | Agoric Zoe runs contracts in Hardened JavaScript compartments via `@endo/static-module-record` / module-source; the architectural pattern is identical. |
| What Alice and Bob must agree on | The same four points apply to Agoric Zoe contracts: agree on the issuers, the contract code (Zoe shows the *instance hash* of the contract), which side you're playing, and a trusted Zoe deployment. |
| Q.race against Q.all | `Promise.race` against `Promise.all` is now ES native; the architectural pattern composes the same way. |
| failOnly idiom | A pattern: a promise that *only* rejects (never resolves successfully); used to cancel a race. |
