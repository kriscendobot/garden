---
title: Translation block (paper idiom → contemporary Endo / Hardened JavaScript surface)
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

| 2013 Dr. SES concept | Contemporary Endo equivalent |
| -------------------- | ---------------------------- |
| Dr. SES (the platform) | The contemporary **Hardened JavaScript** stack: @endo/init + @endo/ses + lockdown; @endo/eventual-send for Q; @endo/static-module-record / module-source for safe mobile code. |
| SES library (def, confine, Nat, WeakMap) | @endo/ses provides lockdown + harden (= def); @endo/init wires the harden discipline; Compartment(...) (= confine); Nat is a community pattern (Agoric ERTP uses it); WeakMap is ES6 native and frozen by SES. |
| Q library (`!` operator, .then, Q.race, Q.all, Q.join, Q.passByCopy) | @endo/eventual-send provides `E()` (the contemporary spelling of `!`) and the HandledPromise primitive; promise-combinators like Q.race / Q.all are now ES native (`Promise.race`, `Promise.all`); Q.join has no Endo counterpart (the eventual-equality operation is less commonly needed in production). |
| Web-keys (unguessable HTTPS URL with fragment) | Endo's formula identifiers + the OCapN protocol family. The unguessable-fragment pattern is the same; the transport differs from RESTful HTTPS to CapTP-over-various-substrates. |
| NodeKen (Ken + Node.js) | The Endo daemon's formula-graph persistence + ocapn-family CapTP wire protocols. Endo's daemon-persistence enacts the consistent-snapshot discipline; the network-reliable-messaging discipline is the @endo/captp + OCapN layer. |
| `confine(exprSrc, endowments)` | `new Compartment(globals, modules, options).evaluate(source)` is the contemporary spelling. The structural pattern (evaluate in a fresh global environment with explicit endowments) is identical. |
| `def(obj)` | `harden(obj)` is the contemporary spelling. Deep-freeze + tamper-proof method records. |
