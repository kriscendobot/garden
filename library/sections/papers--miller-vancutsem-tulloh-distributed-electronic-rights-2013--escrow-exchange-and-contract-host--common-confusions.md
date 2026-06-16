---
title: Common confusions
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

- **"The escrow exchange is naive — it doesn't handle Byzantine faults."** §5 is explicit about the trust assumptions: Alice and Bob trust the issuers + the contract host; they do not trust each other. If issuers misbehave, the contract loses; if the contract host misbehaves, the contract loses. Byzantine fault tolerance at the issuer / host layer is a *separate* concern; the §5 paper does not address it. Contemporary Agoric production handles it via deployment choices (e.g. running on a blockchain that provides BFT consensus for the issuer + host).
- **"Q.race resolves promiscuously."** §5 is careful about which promises feed the race: only the Q.all of both transfers can *fulfill* the race; the failOnly promises can only *reject* it. So if either Alice or Bob cancels first, the race rejects; if both transfers complete first, the race fulfills with both-completed.
- **"Tokens are just hash keys."** The §6 tokens are *unforgeable references* — `def({})` returns a fresh empty defensible object whose *identity* is the token. The WeakMap uses object-identity, not hash equality, so the token cannot be guessed or forged. The 2013 architectural design depends on this property of JavaScript object identity + WeakMap.
- **"The contract host can read the contract source."** Yes — the contract host *must* read the source to evaluate it via `confine`. But the contract source is *also* a public artifact that Alice and Bob agreed on before initiating the contract instance. The contract host has no privileged read access; it sees what Alice and Bob agreed it would see.
- **"Confining the contract is a sandbox."** Closer than not. The §6 confine creates a fresh global environment containing only the SES whitelisted globals + the explicit endowments (`{ Q: Q }` in §6). The contract has no other ambient authority. The structural-architectural pattern matches the 2003 *Paradigm Regained* §5 arena framing: terms-of-entry checked at compartment-construction time.
- **"This eliminates trust."** No — §6 explicitly enumerates the trust requirements. The reduction is from *contract-specific trust* (the §5 escrow exchange agent) to *generic-host trust* (the §6 Contract Host). Trust is *consolidated* and *amortized* across many contracts, not eliminated.
