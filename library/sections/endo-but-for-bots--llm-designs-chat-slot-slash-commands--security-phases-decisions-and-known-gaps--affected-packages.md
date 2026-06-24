---
title: Affected packages
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

- `packages/daemon/src/host.js`, `guest.js`: add
  `makeRetainedValue`; extract the shared transient-eval helper.
- `packages/daemon/src/daemon.js`: export the helper and the
  `release` exo constructor from `DaemonCore`.
- `packages/daemon/src/mail.js`: `endow`, `submit`, and form
  handling accept formula IDs in binding positions.
- `packages/daemon/src/interfaces.js`: interface guards for
  `makeRetainedValue`.
- `packages/daemon/src/help-text.js`, `help.md`: document the
  new verb.
- `packages/daemon/src/graph.js`: expose a captp-scoped pin
  tracker (minor extension of the existing `pinTransient`
  counter) and wire the partition-handler intrinsic release.
- `packages/daemon/src/daemon.js` (gateway bind): track
  transient pins per captp connection and release on disconnect.
- `packages/chat/slot-input.js` (new): unified slot input
  component with slash mode, picker drop-down, and show-value
  affordance.
- `packages/chat/endow-modal.js`, `inbox-component.js`,
  `send-form.js`, `form-builder.js`,
  `counter-proposal-form.js`: migrate to `slot-input.js`.
- `packages/chat/command-registry.js`: new `slotVerbs` table
  keyed by slot type.
- `packages/chat/index.css`: styles for the slash chip, retained
  chip, picker drop-down, and error substate.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
