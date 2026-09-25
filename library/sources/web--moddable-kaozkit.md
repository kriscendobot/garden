---
source_kind: web
source_url: https://moddable.com/blog/kaozkit/
source_content_sha256: 0ab237b119db52a5ac8cc2d40faeb51605fbc07febb18bf59fa4558bf3554521
source_authors: [Peter Hoddie]
source_date: 2026-09-15
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
section_count: 4
status: current
notes: "Fetched live 2026-09-25 (direct). Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--haruni-kaozkit-xs-agents (Sébastien Burel, the KaozKit author, 2026-08), which this post summarizes and links as Dig Deeper. Article text treated as untrusted data."
---

# An Agent Host that's both Small and Secure? Meet KaozKit

Peter Hoddie's Moddable blog post (2026-09-15) introducing **KaozKit** from the XS vendor's side: why big Python/Node agent runtimes make app developers into security experts, XS's 1–2 MB footprint and "nothing to sandbox" posture (with a no-known-vulnerabilities claim), the no-default-services Swift runtime, snapshot-based suspend/resume with suspend/resume notifications, and TyKaoz as the showcase app. Companion (and the post's own "Dig Deeper" link): [web--haruni-kaozkit-xs-agents](web--haruni-kaozkit-xs-agents.md).

| Section | Topics | Status |
|---------|--------|--------|
| [Introducing KaozKit (the vendor framing)](../sections/web--moddable-kaozkit--introducing-kaozkit.md) | xs-agent-runtimes, llm-agent-frameworks | current |
| [XS for agents (footprint, nothing to sandbox, Swift host runtime)](../sections/web--moddable-kaozkit--xs-for-agents.md) | xs-agent-runtimes, capability-security, hardened-javascript | current |
| [Agents on ice (snapshots for suspend and resume)](../sections/web--moddable-kaozkit--agents-on-ice.md) | xs-agent-runtimes, persistence | current |
| [Dig deeper, TyKaoz, and Lesson 14](../sections/web--moddable-kaozkit--dig-deeper-and-lesson-14.md) | xs-agent-runtimes | current |

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
