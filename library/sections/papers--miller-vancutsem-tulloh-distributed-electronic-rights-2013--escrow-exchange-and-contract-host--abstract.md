---
title: Abstract
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

§5 develops the **escrow exchange contract** as a worked example of *composing* the §4 mint-purse machinery into a non-trivial smart contract. The §5 scenario: Alice has $10 in one bank, Bob has 7 shares of stock at another bank; they wish to trade *all-or-nothing* — both transfers succeed, or neither succeeds (with original assets returned to original owners). Five players are involved: Alice, Bob, a money issuer, a stock issuer, and an *escrow exchange agent* (the contract). The §5 paper shows the escrow exchange contract in **22 lines of JavaScript** using only the §2-§4 primitives. The contract uses a **Q.race against a Q.all** composition: until a player cancels, the Q.all of both transfers wins; either cancellation rejects the race. The §5 paper closes with a structural observation about the *makePurse* discipline: the contract avoids dishonest-purse attacks by using `Q.join` on `(srcPurseP ! makePurse, dstPurseP ! makePurse)` to obtain a *mutually acceptable* fresh escrow purse — neither Alice's purse nor Bob's purse alone can fool the agent. §6 generalizes from the specific escrow-exchange contract to the **generic Contract Host** — infrastructure that can host *any* contract formulated as a function. The Contract Host's `setup` method takes a contract source string, evaluates it (via `confine`), and returns an array of *tokens* (one per contract parameter); the `play` method takes a token, alleged-source, alleged-side-index, and the player's argument, and consumes the token to complete its parameter slot. Once all parameters arrive, the contract function is called, and its result resolves the outcome promise the contract host returned. The §6 architectural payoff: Alice and Bob no longer need to agree on a *specific* trusted broker for each contract; they only need to agree on (a) the issuers of each right, (b) the contract source code, (c) which side they are playing, and (d) a third party they mutually trust to honestly run *some* contract — *whatever it is*. §7 closes with the architectural thesis: human society uses *rights* as a scalable means for organizing complex cooperative interactions of decentralized agents with diverse interests; Dr. SES enables the expression of new kinds of rights and smart contracts *simply*.
