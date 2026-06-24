---
title: Security considerations, phased implementation, design decisions, and known gaps
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, capability-security, eventual-send]
status: current
notes: Fifth and final section for chat-slot-slash-commands. Consolidates four end-of-design sections (security considerations, dependencies, phased implementation, design decisions) plus the known-gaps and affected-packages footers. Four security claims: retained pins cannot escalate authority; no daemon-internal reference leakage via the release exo; bounded lifetime on Chat crash via captp partition; cross-peer eval exposure has same confinement posture as named pet-store values. Seven load-bearing design decisions, including *slot as the unit of transient retention not the command*, *transient pin over deferred formulation*, *real locator over opaque ephemeral identifier*, and *no new message type*. Five-phase implementation totaling ~1 developer-week.
kind: index
section_count: 6
---

The final design surface: four security claims naming what
*cannot* go wrong, a five-phase implementation plan, seven
load-bearing decisions, and a known-gaps footer that defers
quota / telemetry to post-shipping observation.

Sections:

- [Security considerations](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--security-considerations.md)
- [Dependencies](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--dependencies.md)
- [Phased implementation](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--phased-implementation.md)
- [Seven load-bearing design decisions](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--seven-load-bearing-design-decisions.md)
- [Known gaps and future considerations](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--known-gaps-and-future-considerations.md)
- [Affected packages](endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps--affected-packages.md)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
