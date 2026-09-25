---
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
section_count: 6
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

# A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents

Sébastien Burel's first-person account (haruni.net, August 2026) of building **KaozKit**, an MIT SwiftPM agent runtime that runs each LLM agent as a module inside its own Moddable **XS** machine on macOS: the `host` global as the agent's entire capability surface, why XS beat JavaScriptCore (heap snapshots, cheap per-agent machines, no ambient authority, a clean async bridge), resident agents that survive kill/restart from a snapshot file, an Agha actor framework with synchronous handlers, the layered package and provider/tool model, and LGPL licensing. Companion: [web--moddable-kaozkit](web--moddable-kaozkit.md).

| Section | Topics | Status |
|---------|--------|--------|
| [Overview: from Kinoma to an XS agent runtime](../sections/web--haruni-kaozkit-xs-agents--overview.md) | xs-agent-runtimes, llm-agent-frameworks | current |
| [An agent is a module (the host global as the whole capability surface)](../sections/web--haruni-kaozkit-xs-agents--an-agent-is-a-module.md) | xs-agent-runtimes, capability-security, llm-agent-frameworks | current |
| [Why XS, and not JavaScriptCore](../sections/web--haruni-kaozkit-xs-agents--why-xs-not-javascriptcore.md) | xs-agent-runtimes, persistence, capability-security | current |
| [What the snapshot changes in practice (resident agents and an actor framework)](../sections/web--haruni-kaozkit-xs-agents--what-the-snapshot-changes-in-practice.md) | xs-agent-runtimes, persistence, scheduled-agent-tasks | current |
| [The layers (SwiftPM products, providers, tools)](../sections/web--haruni-kaozkit-xs-agents--the-layers.md) | xs-agent-runtimes, llm-agent-frameworks, capability-mediated-integrations | current |
| [Licensing and what's next](../sections/web--haruni-kaozkit-xs-agents--licensing-and-whats-next.md) | xs-agent-runtimes | current |

## Cross-source comparison (with the companion article)

Both articles describe the same project (KaozKit), one by its author and one by the XS vendor. They **agree** on: XS is small enough to embed per app; the engine exposes no ambient I/O, so confinement is additive (host functions/services are added, never removed); API/OS access lives in a Swift host; heap snapshots let an agent survive process exit and move between machines.

They **differ** in emphasis and in a few specifics:

- *Security claim.* Hoddie asserts XS has **no known security vulnerabilities** after years of adversarial fuzzing; Burel makes no such claim and frames confinement architecturally ("confinement by construction", "the `host` global is the entire capability surface").
- *Suspend protocol.* Hoddie says agents are **notified on suspend and resume**; Burel's resident-agent demo stresses that *zero* serialization code is needed and does not mention the notification hooks.
- *Per-agent isolation.* Burel's "one XS machine per agent" (sub-agents as separate machines with marshalled calls) and the Agha actor framework with synchronous handlers appear only in Burel's article.
- *Portability.* Hoddie qualifies cross-device resume with "a compatible version of KaozKit"; Burel's "copy the file to another machine" is unqualified.
- *Licensing* (MIT KaozKit over LGPL-v3 XS; commercial XS license for App Store builds) appears only in Burel's article.
- *Provenance.* Hoddie credits Burel's LLM feedback with shaping tool support in Moddable's ChatAudioIO API; Burel credits Patrick Soquet with the async-bridge machinery.

Garden cross-references for this pair live on the topic page [xs-agent-runtimes](../topics/xs-agent-runtimes.md) § Garden cross-references.
