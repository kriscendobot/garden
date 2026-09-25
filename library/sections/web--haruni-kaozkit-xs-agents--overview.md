---
title: "Overview: from Kinoma to an XS agent runtime"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, llm-agent-frameworks]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: Sébastien Burel (ex-Kinoma, now building the TyKaoz private AI wiki for macOS) needed a runtime for the *agent* (the small program that picks tools, keeps state between turns, remembers, and wakes on schedule), not the model; Node-based (OpenClaw) and Python-based (Hermes) agent runtimes were rejected as too heavy and too ambient for a native Mac app that promises nothing leaves the machine, which led him back to Moddable's XS engine.

Twenty years ago, I worked at Kinoma, in California. We were building software for tiny devices, and at the heart of it was a JavaScript engine designed to run where nothing else would fit: XS. It was small, strict, and elegant — the work of Patrick Soquet, who is still its architect today.

Kinoma is gone, but XS is not. It lives on at Moddable, the company Peter Hoddie and Patrick founded, where it powers connected objects all over the world. I used it once more in between, to ship Frigo Magic, a consumer app written entirely in XS.

Last winter I started building a Mac app — a private AI wiki, where you ask questions about your own documents and everything stays on your machine. Early on I hit a question every AI app hits: what runs the agents? Not the model — the agent: the small program that decides which tool to call, keeps state between turns, remembers what it learned, and wakes up on schedule to do it again.

The existing answers all looked the same. OpenClaw needs Node. Hermes needs Python. Fine for a server; wrong for a native Mac app that promises "nothing leaves your machine" and can't reasonably ship a 100 MB runtime to run a ten-line script.

Then I remembered XS.

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
