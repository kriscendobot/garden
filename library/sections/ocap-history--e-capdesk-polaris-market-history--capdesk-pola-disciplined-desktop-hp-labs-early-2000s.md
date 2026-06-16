---
title: "CapDesk: POLA-disciplined desktop (HP Labs, early 2000s)"
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

CapDesk was an HP Labs research project implementing a capability-based desktop environment. The Miller-Tulloh-Shapiro 2004 paper (§3.5, already ingested) uses CapDesk as a worked example of the spawning-tree POLA pattern:

> "Doug uses CapDesk to endow CapMail with access to his SMTP server *by static configuration*. CapMail's main() module grants this access to its imported SMTP module."

**What CapDesk demonstrated technically:** That a desktop environment built on capability discipline can configure application authority at install-time and enforce it at runtime. Each application receives only the capabilities it needs to function (POLA), conveyed through static configuration by the user at install time, not through ambient ambient file-system access. CapMail, a CapDesk email client, held only the SMTP credential it was explicitly endowed with — not a general credential store.

**What happened:** CapDesk remained a research prototype at HP Labs. The HPL-2004-116 technical report documents the system (URL from bibliography: https://www.hpl.hp.com/techreports/2004/HPL-2004-116.html — not directly retrieved due to connection refusal; cited via the Miller-Tulloh-Shapiro paper's bibliography). No commercial product followed.

Source: Library's ingested papers collection (Miller-Tribble-Shapiro 2005, Miller-Tulloh-Shapiro 2004, Swasey-Garg-Dreyer 2017), Wikipedia article on E programming language, Waterken project page. Retrieval date: 2026-06-11.
