---
title: Security considerations
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

- **Retained pins cannot escalate authority.**
  `makeRetainedValue` runs inside the caller's agent (host or
  guest) and pins a formula that the caller is already authorised
  to produce via its existing `evaluate` / `storeValue` /
  `provideLocator` verbs. The only added capability is the right
  to *delay* its collection until a `release` capability is
  invoked or until the captp connection severs. Object-capability
  confinement on the formula itself is unchanged: the eval body
  sees only the endowments it was given.

- **No daemon-internal reference leakage.**
  `release` is an exo whose only method is `release()`. It
  carries no reference to the target value, the target's worker,
  or the daemon's internal graph; it is a deactivation handle
  with zero other authority. A guest that receives a `release`
  from its host cannot read or invoke the retained value through
  it.

- **Bounded lifetime on Chat crash.**
  If the Chat UI process dies between slash-command evaluation
  and form submission, the WebSocket to the daemon closes and the
  captp partition handler fires. Each release Exo held over that
  connection is partitioned and its intrinsic disconnect handler
  invokes `release()` on the daemon side, dropping the transient
  pin. This bounds leakage strictly to the duration of a live
  Chat captp session.

- **Cross-peer eval exposure.**
  Slot slash commands are evaluated in the agent that owns the
  Chat profile. If the enclosing form is being sent to a remote
  peer (for example, a guest filling a slot on a form from a
  remote host), the retained formula is created in the guest's
  namespace. The remote peer receives a *reference* to the
  resulting capability, not the source. This is the same
  confinement posture as naming a value in the pet store and
  passing it by reference.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
