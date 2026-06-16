---
title: Known gaps and future considerations
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, capability-security, eventual-send]
status: current
notes: Fifth and final section for chat-slot-slash-commands. Consolidates four end-of-design sections (security considerations, dependencies, phased implementation, design decisions) plus the known-gaps and affected-packages footers. Four security claims: retained pins cannot escalate authority; no daemon-internal reference leakage via the release exo; bounded lifetime on Chat crash via captp partition; cross-peer eval exposure has same confinement posture as named pet-store values. Seven load-bearing design decisions, including *slot as the unit of transient retention not the command*, *transient pin over deferred formulation*, *real locator over opaque ephemeral identifier*, and *no new message type*. Five-phase implementation totaling ~1 developer-week.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps
---

- Define the exact wire representation of a formula ID in
  `endow` bindings and `submit` values (tagged string vs.
  marshalled remotable). The simplest option is to leverage the
  existing marshalled Passable pipeline: the Chat UI resolves
  the retained ID to its capability through `provide(id)` and
  hands *that* capability to `submit`. Evaluate whether the
  additional round-trip is worth the uniformity.
- Confirm the captp partition-handler API surface needed to
  trigger Exo intrinsic release on disconnect. If the per-Exo
  cancellation promise is not yet exposed by `@endo/captp`, the
  implementation phase adds the minimum surface required.
- **Future consideration:** a `/view`-like read-only inspector
  inside a slot. The chip's "show value" button covers the
  immediate need by reusing the existing value modal; a
  slot-local `/view` verb is a worthwhile follow-up.
- **Future consideration:** per-gateway pin quota. No quota is
  needed at this time; the captp-bounded lifetime is the
  load-bearing safeguard. If future telemetry shows pathological
  pin counts during a single session, a quota can be added then.
- **Future consideration:** telemetry to record slot-slash usage
  patterns and inform the verb set.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
