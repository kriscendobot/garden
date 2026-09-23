---
title: Abstract
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

§1 frames the central proposal: **Dr. SES (Distributed Resilient Secure EcmaScript)** — the platform-for-eright-and-contract that the Miller-Van Cutsem-Tulloh team is building on JavaScript. The architectural claim: JavaScript provides the *ubiquity* (it is already understood and used by many non-expert programmers) but must be *significantly extended* to address (a) security against script injection — the SES sub-platform freezes intrinsics and confines mobile code; (b) distribution — the Q library extends JavaScript with eventual-send (`!`) and promise combinators across communicating event loops; (c) resilience — the NodeKen platform provides distributed orthogonal persistence (consistent snapshots + reliable messaging) so programs survive crashes and partitions without effort. The §2 sections walk these three layers in turn. §2.3 develops **SES** as the ocap subset of ES5: lexically scoped, encapsulated functions, whitelisted globals (immutable when transitively reachable), `def()` for defensible objects (deep frozen + tamper-proof method records), `confine(exprSrc, endowments)` for safe mobile code, `Nat()` for type-checked natural numbers, `WeakMap` for rights amplification via object-identity-keyed tables. §2.4 develops **Q** with the **eventual-send `!` operator**: `pointP ! getX()` enqueues a `getX` call on `pointP`'s remote event loop. Promises designate either local objects (accessed via `.then`) or remote objects (interacted with via `!`). The Q library provides `Q.race`, `Q.all`, `Q.join`, `Q.passByCopy` as composition combinators. Remote object references use **web-keys** — unguessable HTTPS URLs of the form `https://www.example.com/app/#mhbqcmmva5ja3` — for pass-by-reference encoding over RESTful transport. §2.5 develops **NodeKen**: distributed consistent snapshots (Ken protocol) layered on Node.js, so that *every message ever sent will be delivered in order exactly once* after any sequence of crashes and partitions. The architectural payoff: a Dr. SES programmer writes plain JavaScript with the `!` operator and the system handles security + distribution + resilience for them.
