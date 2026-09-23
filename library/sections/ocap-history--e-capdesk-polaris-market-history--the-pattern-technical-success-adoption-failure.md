---
title: "The pattern: technical success, adoption failure"
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
