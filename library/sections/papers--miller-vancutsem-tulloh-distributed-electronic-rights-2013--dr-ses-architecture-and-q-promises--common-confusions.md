---
title: Common confusions
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

- **"Dr. SES is Agoric."** Closer to *Dr. SES → @endo + Agoric lineage*. The Dr. SES platform proposal (2013) became the contemporary @endo / Hardened JavaScript stack (lockdown + harden + Compartment + eventual-send + marshal + captp); Agoric is the company building on this stack at the contract-execution + value-transfer layer. Dr. SES is the platform; Agoric is one production deployment.
- **"NodeKen exists."** Not as of the 2013 paper. The team was working on integrating Ken with v8 (`supergillis/v8-ken`). The contemporary realization is the Endo daemon's formula-graph persistence + OCapN messaging — structurally equivalent properties but realized through different machinery.
- **"`!` is the same as `await`."** No — `!` is *eventual-send* (an operation), not *await* (a control-flow primitive). `p ! m(x)` enqueues a method call on `p`'s event loop and returns a promise; it does *not* suspend the current code. The modern Endo equivalent is `E(p).m(x)` which returns a promise; you can `await` that promise *separately* in an async function. The eventual-send is the operation; the await is the suspension.
- **"Web-keys are cryptographic capabilities."** The unguessable-fragment is *structurally* a capability (you can only learn it by being told); it is not *cryptographically* unforgeable. Web-keys depend on TLS for confidentiality in transit and on the URL-fragment-is-not-sent-to-the-server property for confidentiality at the server. The contemporary CapTP wire protocol uses cryptographic-key pairs at the substrate.
- **"Dr. SES requires ES7."** The paper uses two ES6/ES7 conveniences (arrow functions and `!`) but works in ES5 underneath. Modern Hardened JavaScript runs on modern engines; the architectural argument is independent of any specific ES version.
