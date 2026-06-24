---
title: Phased implementation
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

1. **Daemon: `makeRetainedValue` for `type: 'eval'`.**
   Introduce the method on host and guest, reusing the existing
   transient-pin-and-await path but exposing a `release` exo.
   Wire the captp partition signal to the Exo's intrinsic
   release. Unit tests: pin retention across an await; release
   triggers collection; retention through a second formula
   prevents collection after release; captp disconnect triggers
   release. *Size: S-M (2 to 3 days), captp partition wiring
   being the open variable.*

2. **Chat: extract `createSlotInput`.**
   Consolidate the current slot-input clones in `endow-modal.js`
   and `inbox-component.js` into one component. No behavioural
   change yet, just refactor with the existing pet-name-only
   semantics. *Size: S (1 day).*

3. **Chat: slash mode, `/js` verb, picker drop-down,
   show-value.** Add the state machine, the slash chip, the
   `/js` handler that calls
   `makeRetainedValue({ type: 'eval', … })`, the petname picker
   drop-down with modeline `/` hint, and the chip's show-value
   affordance. Wire the release lifecycle to the form's submit /
   cancel / dispose. Add Cmd-Enter Monaco expansion mirroring the
   command bar. *Size: M (3 to 4 days).*

4. **Daemon + Chat: submission acceptance of formula IDs.**
   Extend `endow` bindings and `submit` values to accept formula
   IDs alongside pet names. Make Chat serialise retained slot
   values as formula IDs in the outbound payload. *Size: S-M
   (1 to 2 days).*

5. **Additional verbs.** Add `/json`, `/locator`, and `/ref`.
   *Size: S (1 to 2 days).*

Total: **M, roughly 1 week** for one developer.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
