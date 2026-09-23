---
title: "Combex, the E language history, caplets, and promise-based distribution"
source: http://www.combex.com/tech/darpaBrowser.html
source_kind: web
source_url: http://www.combex.com/tech/darpaBrowser.html
source_fetched_via: wayback
source_wayback_url: http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html
source_wayback_timestamp: 20260504023216
source_content_sha256: 3a68fd803bbbddc03fa419d5351ee7a03ac1df9620d96e51257c6862858f86bd
source_authors: [Combex, Inc.]
source_date: 2026-06-28
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-theory]
status: current
---

## Abstract

The DarpaBrowser's "Technical Approach and Relevant Capabilities" section — a primary-source account of Combex's founding, the E language's origin and funding ($10M over seven years, begun at Communities.com), and the technical capabilities the project relies on: caplets (capability-confined applications), the Capability Windowing Toolkit (capWT) for mutually-suspicious GUI subsystems, and E's promise-based, deadlock-free, automatically-encrypted distributed computation. This is the historical record the library's secondary-source survey synthesizes from elsewhere.

## Content

**Combex.** "Combex was founded in 1999, to pursue opportunities for capability security in the financial and software development sectors. Combex is the home of the world's greatest repository of expertise on the capability-secure, open-source E Programming Language." The Chief Technology Officer is **Mark Miller**, "the chief architect and implementor of E, and the central coordinator of [the] open source E project." The Chief Operating Officer is **Marc Stiegler**, "the developer of over half of all publicly available E applications deployed in the world today, and author of the book … E in a Walnut." Stiegler is also "the chief architect for the Capability Windowing Toolkit (capWT), a proprietary Combex technology for imposing capability discipline on mutually suspicious application subsystems that must share screen and keyboard/mouse resources in a graphical user interface (gui) environment."

**E's origin and funding.** "E itself is the result of over $10M of research and development over a seven year period; its development was first initiated by the company Communities.com for the implementation of a capability secure decentralized social virtual reality. When Communities.com abandoned development of its own virtual reality for marketing reasons, Communities.com allowed Mr. Miller to open source the language and take control of the central repository." The most mature version at the time, "version 0.8.9, runs on top of the Java Virtual Machine (jvm), versions 1.3 and above."

**E's capabilities.** The language "not only implements capability security within single-computer applications, it applies capability security to distributed systems with strong encryption that is built into the infrastructure: E programmers are not burdened with security considerations for their distributed systems, all communication is automatically encrypted, and remote computation objects are automatically authenticated." E "uses a promise-based architecture for distributed computation, eschewing threads for concurrency control. This eliminates the traditional Sword of Damocles that hangs over all thread-based programming, the threat of deadlock." (This is the model the library's [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005.md) paper formalizes as vats and eventual send.)

The capability "critical to the success of this project" is the power to implement **caplets**: "software applications that are confined by capability discipline even if [they are buggy or malicious]." Caplets are the E analogue of the Java applet — the unit the DarpaBrowser confines, and the same word CapDesk uses for its confined desktop applications.

Source: [The DarpaBrowser](http://www.combex.com/tech/darpaBrowser.html) — captured via the Internet Archive (`source_fetched_via=wayback`) at [web/20260504023216id_/](http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html), content SHA-256 `3a68fd80`.
