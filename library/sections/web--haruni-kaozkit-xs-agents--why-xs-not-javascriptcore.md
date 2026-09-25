---
title: "Why XS, and not JavaScriptCore"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, persistence, capability-security]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: Burel switched from JavaScriptCore to XS for four reasons that became product features: whole-heap **snapshots** (`writeSnapshot()` / `init(snapshot:)`, so a resident agent's brain is a file that restores mid-thought in a fresh process or on another machine, with zero serialization code); **one cheap XS machine per agent** (sub-agents as separate machines on their own threads with marshalled calls); **confinement by construction** (XS has no ambient authority, so capabilities are added one host function at a time via `xs.h`); and a **clean async bridge** that settles promises across the engine-thread boundary, built with Patrick Soquet's help.

Fair question — JSC ships with every Mac. I started with it. I switched for four reasons, each of which turned out to be a product feature rather than an implementation detail.

- **Heap snapshots.** XS can serialize its entire heap to bytes and restore it in a fresh process. Not "serialize your state to JSON" — the heap: every object, every closure, every pending timer, the conversation an agent is in the middle of. In KaozKit this is `writeSnapshot()` / `init(snapshot:)`. The consequence: a resident agent's brain is a file. Kill the process, copy the file to another machine, restore — the agent picks up mid-thought. I wrote zero lines of serialization code, and I never will.
- **One machine per agent.** XS was built for microcontrollers. A machine costs very little memory, which makes "one isolated engine per agent" a reasonable architecture rather than a luxury. An orchestrator can spawn sub-agents as separate XS machines (new Thread + new Service, with calls marshalled across the boundary) and keep several resident agents alive side by side. With JSC, I would have been counting contexts.
- **Confinement by construction.** XS has no ambient authority. There is nothing to sandbox away — you add capabilities, one host function at a time, in C, against the classic `xs.h` API. The Swift side implements them; the C side is a thin shim that hands work over and settles promises when Swift is done. It is the same discipline embedded developers use to expose a sensor to a script, applied to exposing a language model.
- **A clean async bridge.** The engine runs on a private thread; Swift work runs off it; `await` continuations settle correctly across the boundary. This was the hard part, and it is where Patrick's help was decisive — some of the machinery that makes it clean is now in KaozKit's C layer, and some of it is simply knowing which invariants XS holds and which it doesn't.

If you only need to evaluate a script, JavaScriptCore is fine. If you want stateful, restartable, confined agents, you want XS.

**Scholar note.** "No ambient authority" here means the bare XS *engine* ships only the language (no I/O host), which is the property Endo's SES/`lockdown` has to establish by taming on V8/Node; it does not by itself give SES-style frozen, shared-safe intrinsics between co-resident programs — KaozKit gets isolation by putting each agent in its own machine instead.

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
