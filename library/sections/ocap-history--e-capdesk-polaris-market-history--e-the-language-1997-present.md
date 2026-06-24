---
title: "E: the language (1997–present)"
source_kind: web-survey
source_url: https://erights.org/elang/index.html
source_date: 2026-06-11
ingested: 2026-06-11
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: |
  Synthesized from: Miller-Tribble-Shapiro 2005 "Concurrency Among Strangers" (already ingested at
  papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md),
  Miller-Tulloh-Shapiro 2004 "The Structure of Authority" (already ingested, specifically §3.5–§3.7
  which name CapDesk and Polaris as worked examples),
  Wikipedia article on E programming language (en.wikipedia.org/wiki/E_(programming_language),
  retrieved 2026-06-11),
  Waterken project page (waterken.sourceforge.net, retrieved 2026-06-11),
  E language home page (erights.org, ECONNREFUSED at retrieval time — site intermittently down).
  The Miller papers already in the library are the authoritative technical sources;
  this section focuses on the market/adoption narrative and connects the named systems.
  No market-size numbers are cited because no sourced figures were found.
parent: ocap-history--e-capdesk-polaris-market-history
---

E was created in 1997 by Mark S. Miller, Dan Bornstein, Douglas Crockford, Chip Morningstar, and others at Electric Communities. The design descended from the concurrent language Joule and from Original-E, a set of extensions to Java for secure distributed programming (see [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) for the full lineage).

**What E demonstrated technically:**

- Object references as capabilities, with zero extra computational overhead ("capabilities add no computational or conceptual overhead costs" — Wikipedia on E).
- Event-loop-based concurrency that structurally prevents deadlock ("A concurrency model based on event loops and promises ensures that deadlock can never occur").
- The near/eventual/broken reference state machine, the promise-pipelining protocol, and the broken-reference contagion pattern that Endo/HandledPromise later inherits.
- Cryptographic securing of cross-machine capability references: Original-E was "the first successfully to mix sequential immediate-call programming with asynchronous eventual-send programming" and "cryptographically secured the Joule-like network extension" (Concurrency Among Strangers §11).
- Electric Communities used Original-E to build Habitats — a "graphical, decentralized, secure social-virtual-reality system spread across mutually-suspicious machines" — which is the working proof-of-concept for the platform-thesis architecture.

**What happened:** E remains an active research language and intellectual ancestor but never achieved commercial adoption as a programming platform. The Electric Communities social VR venture did not succeed commercially. E's ideas propagated into academic literature (the Miller-Tribble-Shapiro, Miller-Yee-Shapiro, Miller-Tulloh-Shapiro papers in this library), into JavaScript (Mark Miller led the SES / Hardened JavaScript work at Google; the Proxy and WeakMap additions to ES6 were shaped by these ideas), and into Endo/Agoric. But E itself — as a deployed language runtime — remains a research artifact.

The E home page (erights.org) is intermittently unreachable as of 2026; the intellectual lineage is documented in the library's papers collection.

Source: Library's ingested papers collection (Miller-Tribble-Shapiro 2005, Miller-Tulloh-Shapiro 2004, Swasey-Garg-Dreyer 2017), Wikipedia article on E programming language, Waterken project page. Retrieval date: 2026-06-11.
