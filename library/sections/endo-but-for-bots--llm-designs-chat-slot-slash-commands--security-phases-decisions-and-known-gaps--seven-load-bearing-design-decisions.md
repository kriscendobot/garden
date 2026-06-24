---
title: Seven load-bearing design decisions
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

1. **Slot as the unit of transient retention, not the command.**
   Transience belongs to the *use* of a value, not to the verb
   that produced it. `/js` in the command bar with `resultName`
   is persistent; the same `/js` inside a slot is transient
   because the slot's consumer decides its fate. This keeps the
   verb semantics uniform across contexts.

2. **Transient pin over "deferred formulation".**
   An alternative is to defer formulation entirely: the slot
   records the source text and arguments, and formulation
   happens only when the outer form submits. We rejected this
   because errors must surface immediately at the slot (syntax
   errors, resolver failures, worker-start failures) rather than
   appearing as opaque submit failures on the outer form.
   Formulate-now-pin-briefly preserves the existing eval error
   paths.

3. **Slash prefix is always the trigger.**
   A per-field toggle is less fluent for keyboard users. The
   slash prefix matches Chat's existing vocabulary and is
   unambiguous relative to pet names. A picker drop-down is
   still provided for mouse users, opening the petname
   drop-down first and advertising `/` as the route to commands.

4. **Verbs are registered, not hard-coded in the slot.**
   Slot verbs share a registry with command-bar commands but are
   filtered by slot `type`. This lets a `source`-typed slot
   expose only `/js`, while a generic capability slot exposes
   the full set.

5. **Release by capability, not by channel state.**
   Returning a `release` exo makes the lifetime explicit and
   testable. A purely implicit scheme (e.g., "release when the
   gateway session sends the next submit") would entangle UI
   and daemon-session state in a way that is hard to reason
   about across reconnects. The captp connection still serves
   as the outermost lifetime bound (via partition-triggered
   release), but inside that bound the release Exo is the
   explicit handle.

6. **Real locator over opaque ephemeral identifier.**
   Every slot value either has a real locator (a formula
   identifier the daemon recognises) or is a passable that the
   daemon can marshal. We deliberately do not introduce an
   "ephemeral identifier" distinct from an ordinary formula
   identifier. The retention is a property of the daemon's
   transient pin set, not of a different identifier kind. This
   means every existing affordance (show value, inspect,
   resolve, dependency-walk) works on the retained value
   without special cases.

7. **No new message type.**
   Slot slash commands never produce daemon messages. The outer
   form still produces the single `submit`, `endow`, or `form`
   message it already produces today, now with formula IDs in
   its payload. This keeps the message protocol unchanged.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
