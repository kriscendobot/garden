---
title: "Waterken: capability URLs for the web (2004–2009)"
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

Related: the Waterken Server (Waterken Inc., 2004–2009, https://waterken.sourceforge.net/) demonstrated capability-based security for the web through cryptographically protected capability URLs ("web-keys"). The project implemented asynchronous messaging and promises in a distributed computing model and integrated the Joe-E verification tool.

**What Waterken demonstrated:** That capability-by-reference could work as a web architecture: an unguessable URL carries both designation and authority, enabling secure interactions between web clients and servers without ambient authentication state. This is the Tyler Close web-key idea documented in [papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix.md).

**What happened:** Waterken closed in 2009. The web-key idea persisted in academic literature and influenced secure API design (Tahoe-LAFS, Agoric). No commercial deployment.

Source: Library's ingested papers collection (Miller-Tribble-Shapiro 2005, Miller-Tulloh-Shapiro 2004, Swasey-Garg-Dreyer 2017), Wikipedia article on E programming language, Waterken project page. Retrieval date: 2026-06-11.
