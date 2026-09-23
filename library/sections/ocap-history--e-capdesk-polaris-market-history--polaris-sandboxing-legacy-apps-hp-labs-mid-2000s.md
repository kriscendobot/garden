---
title: "Polaris: sandboxing legacy apps (HP Labs, mid-2000s)"
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

Polaris (referenced in HPL-2006-116, "How Emily tamed the Caml" — cited in [papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane](../sections/papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane.md) as "Stiegler 2006") was an HP Labs demonstration that capability discipline could be applied to *legacy applications without modification*.

The Miller-Tulloh-Shapiro 2004 paper (§3.7, already ingested) uses Polaris as its canonical worked example:

> "Polaris restricts the authority available to `killer.xls` without modifying the spreadsheet itself, Excel itself, or WindowsXP. POLA is imposed *at the boundary*."

**What Polaris demonstrated technically:**

- A capability-based wrapper for Microsoft Windows that confined existing executables (Excel spreadsheets in the prototype) without requiring changes to the wrapped application, the hosting environment (Windows XP), or the application runtime (Excel).
- The "open file" interaction: when `killer.xls` attempted to open a file, the Polaris wrapper intercepted the request, presented the user with an attenuation-granting dialog, and conveyed only the specifically-chosen file — not a general file-system handle.
- This is the earliest named working demonstration of the "agent proposes capability attenuation as code; user reviews and endows" interaction pattern that the Endo gateway's MCP termination layer is designed to provide.

**What happened:** Polaris remained a research prototype. The HP Labs Stiegler-Miller 2006 paper ("How Emily tamed the Caml," HPL-2006-116) documents the system. Marc Stiegler wrote popular-audience explanations of the Polaris interaction pattern. No commercial product followed.

Source: Library's ingested papers collection (Miller-Tribble-Shapiro 2005, Miller-Tulloh-Shapiro 2004, Swasey-Garg-Dreyer 2017), Wikipedia article on E programming language, Waterken project page. Retrieval date: 2026-06-11.
