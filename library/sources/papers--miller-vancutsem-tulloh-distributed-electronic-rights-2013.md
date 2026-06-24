---
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_title: "Distributed Electronic Rights in JavaScript"
source_year: 2013
source_venue: "ESOP 2013 (European Symposium on Programming), Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/distributed-electronic-rights-in-javascript.pdf
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_pdf_pages: 20
ingested: 2026-05-30
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2013 Miller-Van Cutsem-Tulloh paper that introduces **Dr. SES (Distributed Resilient Secure EcmaScript)** as the JavaScript platform for distributed electronic rights and smart contracts. Dr. SES is the direct ancestor of the contemporary **Hardened JavaScript** stack (the `@endo/*` packages, the lockdown discipline, the eventual-send/CapTP family) and of **Agoric Zoe** (the §6 Contract Host is Zoe at 22 lines of JavaScript). The library can cite this paper whenever a design needs to ground:

- **The Hardened JavaScript lineage.** Dr. SES = SES (script-injection security) + Q (distribution) + NodeKen (resilience).
- **The Q library.** The `!` eventual-send operator, promise combinators (Q.race, Q.all, Q.join, Q.passByCopy), web-keys (unguessable HTTPS URLs as pass-by-reference encoding) — the architectural ancestors of @endo/eventual-send + the OCapN-family CapTP wire protocols.
- **NodeKen.** Distributed consistent snapshots + reliable messaging — structurally what the Endo daemon's formula-graph persistence enacts.
- **The JavaScript-native mint-purse code.** §4's makeMint is the JavaScript translation of the 2000 *Capability-Based Financial Instruments* §3.4 mint-purse-money pattern. WeakMap replaces BrandMaker pair; `def` replaces E `def`-defensible-object syntax; six security properties hold by visual inspection.
- **The rights-as-property framing.** §3 develops the architectural claim that *ocap systems pursue a property-rights strategy; ACL systems implement a governance strategy* — two different responses to the tragedy of the commons.
- **The four dimensions where money differs from references.** §3.3 reprises the 2000 four-axis rights taxonomy (Shareable/Exclusive, Specific/Fungible, Opaque/Measurable, Exercisable/Symbolic) and applies it to the reference-vs-money contrast.
- **The escrow exchange contract.** §5 is the canonical worked example of an all-or-nothing atomic swap; uses Q.all + Q.race + failOnly composition. The Q.join on `makePurse` is the dishonest-purse defense.
- **The generic Contract Host.** §6 takes the structural step from contract-specific brokers to generic Contract Host infrastructure. The direct architectural ancestor of Agoric Zoe.

## The argument arc

1. **Smart contracts for the rest of us.** Smart contracts need a distributed, secure, persistent, ubiquitous computational fabric. JavaScript provides ubiquity but must be extended.
2. **Dr. SES architecture.** SES (script-injection security) + Q (distribution via communicating event loops + `!` operator + promise combinators) + NodeKen (orthogonal persistence via consistent snapshots + reliable messaging).
3. **Rights as property.** Ocap pursues property-rights strategy; ACL implements governance strategy. The four dimensions where money differs from references.
4. **Money as eright.** The makeMint code in JavaScript: WeakMap as brand, `def` for defensible objects, Nat for natural-number guards. Six security properties hold by visual inspection.
5. **Escrow exchange contract.** All-or-nothing trade in 22 lines. Q.all + Q.race + failOnly composition. Dishonest-purse defense via Q.join on `makePurse`.
6. **Contract Host.** Generic infrastructure hosting any contract. Setup-and-play tokens. What Alice and Bob must agree on: issuers + contract source + side assignment + mutually-trusted host.
7. **Conclusion.** Rights are a scalable means of organizing complex cooperative interactions; Dr. SES turns JavaScript into the platform for expressing this.

## For the Endo / Agoric library

This paper is the **canonical link between the E-language lineage (1988-2005) and the contemporary Hardened JavaScript / Agoric stack**. The library now has the complete arc:

- **1988-2005 E lineage**: Miller-Drexler 1988 (agoric vision), Miller-Morningstar-Frantz 2000 (capability money), Miller-Yee-Shapiro 2003 (capability myths), Miller-Shapiro 2003 (paradigm regained), Miller-Tulloh-Shapiro 2004 (structure of authority), Miller-Tribble-Shapiro 2005 (concurrency among strangers).
- **2013 JavaScript bridge**: this paper — Dr. SES / Q / NodeKen as the JavaScript-native realization.
- **Contemporary @endo / Agoric**: lockdown + harden + Compartment + eventual-send + marshal + captp + Zoe.

The 2013 paper is the **transition document** — it shows how the E-language patterns translate into JavaScript and what additional infrastructure (Q, NodeKen) is needed for parity. The contemporary Endo / Agoric stack is the production realization.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [dr-ses-architecture-and-q-promises](../sections/papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises.md) | capability-security, eventual-send, captp, persistence | current |
| [rights-as-property-and-money-as-right](../sections/papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--rights-as-property-and-money-as-right.md) | capability-security, patterns | current |
| [escrow-exchange-and-contract-host](../sections/papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host.md) | capability-security, eventual-send, patterns | current |

The paper's seven sections collapse to three argument-cluster sections. §1+§2 → Dr. SES architecture; §3+§4 → rights framing + money; §5+§6+§7 → escrow exchange + Contract Host + conclusion. The §7 conclusions are brief; the §6 Contract Host is the load-bearing architectural payoff.

## Provenance

- Fetched 2026-05-30 from `papers.agoric.com/assets/pdf/papers/distributed-electronic-rights-in-javascript.pdf`.
- PDF SHA-256 `061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593`, 20 pages.
- Drafted by the liaison via orchestrator-direct-draft. **Seventh Miller-coauthored paper** in the library (with Van Cutsem and Tulloh as coauthors); the library's first 2013-vintage paper.
