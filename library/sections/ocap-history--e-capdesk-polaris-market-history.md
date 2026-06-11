---
title: "Object-Capability Systems History: E, CapDesk, Polaris — Technical Demonstrations and Market Outcomes"
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
---

## Abstract

The E programming language (1997), CapDesk (HP Labs, early 2000s), and Polaris (HP Labs, mid-2000s) represent the canonical first wave of object-capability systems that moved beyond theory into working implementations. E demonstrated capability-secure distributed computing in a language; CapDesk showed that POLA-disciplined desktop applications could be built; Polaris demonstrated that legacy applications (specifically Microsoft Excel) could be wrapped in a capability sandbox without modification. All three achieved technical success. None achieved commercial adoption. This section records what each demonstrated, what happened to each, and what the pattern means for the B2 bear-brief essay's "thirty-year history of technical success and market failure" objection.

## E: the language (1997–present)

E was created in 1997 by Mark S. Miller, Dan Bornstein, Douglas Crockford, Chip Morningstar, and others at Electric Communities. The design descended from the concurrent language Joule and from Original-E, a set of extensions to Java for secure distributed programming (see [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) for the full lineage).

**What E demonstrated technically:**

- Object references as capabilities, with zero extra computational overhead ("capabilities add no computational or conceptual overhead costs" — Wikipedia on E).
- Event-loop-based concurrency that structurally prevents deadlock ("A concurrency model based on event loops and promises ensures that deadlock can never occur").
- The near/eventual/broken reference state machine, the promise-pipelining protocol, and the broken-reference contagion pattern that Endo/HandledPromise later inherits.
- Cryptographic securing of cross-machine capability references: Original-E was "the first successfully to mix sequential immediate-call programming with asynchronous eventual-send programming" and "cryptographically secured the Joule-like network extension" (Concurrency Among Strangers §11).
- Electric Communities used Original-E to build Habitats — a "graphical, decentralized, secure social-virtual-reality system spread across mutually-suspicious machines" — which is the working proof-of-concept for the platform-thesis architecture.

**What happened:** E remains an active research language and intellectual ancestor but never achieved commercial adoption as a programming platform. The Electric Communities social VR venture did not succeed commercially. E's ideas propagated into academic literature (the Miller-Tribble-Shapiro, Miller-Yee-Shapiro, Miller-Tulloh-Shapiro papers in this library), into JavaScript (Mark Miller led the SES / Hardened JavaScript work at Google; the Proxy and WeakMap additions to ES6 were shaped by these ideas), and into Endo/Agoric. But E itself — as a deployed language runtime — remains a research artifact.

The E home page (erights.org) is intermittently unreachable as of 2026; the intellectual lineage is documented in the library's papers collection.

## CapDesk: POLA-disciplined desktop (HP Labs, early 2000s)

CapDesk was an HP Labs research project implementing a capability-based desktop environment. The Miller-Tulloh-Shapiro 2004 paper (§3.5, already ingested) uses CapDesk as a worked example of the spawning-tree POLA pattern:

> "Doug uses CapDesk to endow CapMail with access to his SMTP server *by static configuration*. CapMail's main() module grants this access to its imported SMTP module."

**What CapDesk demonstrated technically:** That a desktop environment built on capability discipline can configure application authority at install-time and enforce it at runtime. Each application receives only the capabilities it needs to function (POLA), conveyed through static configuration by the user at install time, not through ambient ambient file-system access. CapMail, a CapDesk email client, held only the SMTP credential it was explicitly endowed with — not a general credential store.

**What happened:** CapDesk remained a research prototype at HP Labs. The HPL-2004-116 technical report documents the system (URL from bibliography: https://www.hpl.hp.com/techreports/2004/HPL-2004-116.html — not directly retrieved due to connection refusal; cited via the Miller-Tulloh-Shapiro paper's bibliography). No commercial product followed.

## Polaris: sandboxing legacy apps (HP Labs, mid-2000s)

Polaris (referenced in HPL-2006-116, "How Emily tamed the Caml" — cited in [papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane](../sections/papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane.md) as "Stiegler 2006") was an HP Labs demonstration that capability discipline could be applied to *legacy applications without modification*.

The Miller-Tulloh-Shapiro 2004 paper (§3.7, already ingested) uses Polaris as its canonical worked example:

> "Polaris restricts the authority available to `killer.xls` without modifying the spreadsheet itself, Excel itself, or WindowsXP. POLA is imposed *at the boundary*."

**What Polaris demonstrated technically:**

- A capability-based wrapper for Microsoft Windows that confined existing executables (Excel spreadsheets in the prototype) without requiring changes to the wrapped application, the hosting environment (Windows XP), or the application runtime (Excel).
- The "open file" interaction: when `killer.xls` attempted to open a file, the Polaris wrapper intercepted the request, presented the user with an attenuation-granting dialog, and conveyed only the specifically-chosen file — not a general file-system handle.
- This is the earliest named working demonstration of the "agent proposes capability attenuation as code; user reviews and endows" interaction pattern that the Endo gateway's MCP termination layer is designed to provide.

**What happened:** Polaris remained a research prototype. The HP Labs Stiegler-Miller 2006 paper ("How Emily tamed the Caml," HPL-2006-116) documents the system. Marc Stiegler wrote popular-audience explanations of the Polaris interaction pattern. No commercial product followed.

## Waterken: capability URLs for the web (2004–2009)

Related: the Waterken Server (Waterken Inc., 2004–2009, https://waterken.sourceforge.net/) demonstrated capability-based security for the web through cryptographically protected capability URLs ("web-keys"). The project implemented asynchronous messaging and promises in a distributed computing model and integrated the Joe-E verification tool.

**What Waterken demonstrated:** That capability-by-reference could work as a web architecture: an unguessable URL carries both designation and authority, enabling secure interactions between web clients and servers without ambient authentication state. This is the Tyler Close web-key idea documented in [papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix.md).

**What happened:** Waterken closed in 2009. The web-key idea persisted in academic literature and influenced secure API design (Tahoe-LAFS, Agoric). No commercial deployment.

## The pattern: technical success, adoption failure

The B2 bear-brief essay must address this objection at full strength. The honest account:

**Why the first wave did not achieve adoption:**

1. **Platform lock.** Desktop platforms (Windows, macOS) provided no native capability-discipline substrate. Polaris had to wrap Windows from the outside. CapDesk required a complete replacement of the desktop environment. Neither offered a migration story for existing ecosystems.
2. **No installed base.** Each project started from zero. The combination of capability-correct behavior and zero installed base meant that network-effect-dependent applications (email, social) could not achieve critical mass.
3. **Developer experience.** E's syntax and model diverged enough from mainstream languages (Java, Python) that adoption required learning a new paradigm. Most security improvements offer incremental value at incremental cost; capability discipline requires a model shift with concentrated upfront cost and distributed long-term benefit.
4. **Timing.** The early-to-mid 2000s were the years when JavaScript was considered a toy language and web security was still treated as a server-side concern. The large-scale ambient-authority failures (OAuth bearer-token sprawl, supply-chain attacks, agent over-permissioning) that motivate Endo's audience had not yet occurred at sufficient scale to create demand.

**What is structurally different about the current moment:**

- **JavaScript substrate.** Endo's capability discipline is implemented *in* JavaScript, the language that already runs everywhere. No new runtime; no new platform. The SES / lockdown layer is an addition, not a replacement.
- **Demand from AI-agent over-permissioning.** The MCP ambient-authority problem (documented in this library's `mcp-landscape--gateway-hosting-category` section) has created a named, acute enterprise security problem that matches exactly what capability discipline solves. The demand did not exist in 2004.
- **Commercial vehicle.** The Endo gateway (O1 marketplace node → O2 community hubs) provides a revenue model that funds development of the commons without requiring the commons to achieve standalone commercial success first.

Source: Library's ingested papers collection (Miller-Tribble-Shapiro 2005, Miller-Tulloh-Shapiro 2004, Swasey-Garg-Dreyer 2017), Wikipedia article on E programming language, Waterken project page. Retrieval date: 2026-06-11.
