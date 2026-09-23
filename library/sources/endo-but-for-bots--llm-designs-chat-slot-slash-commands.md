---
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-05-30
ingested_by: scholar
section_count: 5
status: current
notes: **Status: Proposed** upstream. The chat-cluster's load-bearing design for *inline capability provisioning*: a slot input accepts `/js`, `/json`, `/locator`, `/ref` slash commands and the resulting capability is captured into the outer form's formula inputs without ever assigning a pet name. Hinges on a new daemon method `makeRetainedValue(spec) -> { id, release }` that exposes the existing transient-pin lifecycle to the chat-UI caller, with the captp partition handler as the outermost lifetime bound. Five sections cover the problem framing and slash-mode syntax, the slot state machine + handler protocol, the daemon-side `makeRetainedValue` + captp-bounded pin, the chat-UI component consolidation + submission path, and the security / phases / decisions / gaps footer. Cycle 83 ingest — fifteenth chat-cluster source.
---

> Abstract: Slot-local slash commands let a Chat user fill a form slot
> (a field expecting a capability reference) with a *throwaway* value
> (a tiny `x => x + 1` function, a JSON literal, a locator) without
> first naming the value in the pet store. The slot input recognises a
> `/` prefix, dispatches to a slash command, evaluates the expression,
> and fills the slot with the resulting capability. **Four-step pet-store
> round-trip collapses to one keystroke.** Hinges on a new daemon
> method `makeRetainedValue(spec) -> { id, release }` that exposes the
> existing transient-pin lifecycle as an exo capability, with the
> captp partition handler as the outermost lifetime bound (Chat crash
> → connection severs → daemon intrinsically releases). **No new
> formula type** — the retained value is an ordinary `eval` / `marshal`
> / `locator` formula with a real locator at all times; "retained" is
> purely lifecycle (a transient-root pin tied to the captp connection),
> not a persisted property. Submission re-expresses pet names as
> formula inputs on the downstream formula; the design extends `endow`
> bindings and `submit` values to accept formula IDs alongside pet
> names. Five UI changes: the unified `slot-input.js` component, the
> two-stage picker drop-down (petname first, command `/` away), the
> show-value affordance reusing the existing value modal, error
> rendering with re-runnable handler, and a four-state modeline hint
> table aligned with `chat-command-bar.md` modeline-completeness.
> Seven load-bearing decisions including *slot is the unit of
> transient retention, not the command*, *real locator over opaque
> ephemeral identifier*, and *no new message type*. Five-phase
> implementation totaling ~1 developer-week.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-slash-mode-syntax](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--problem-and-slash-mode-syntax.md) | chat-ui, daemon | current |
| [slot-state-machine-and-handler-protocol](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol.md) | chat-ui, daemon, eventual-send | current |
| [daemon-changes-makeretainedvalue-and-captp-bounded-pin](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin.md) | daemon, eventual-send, captp, persistence | current |
| [chat-ui-slot-input-component-and-submission](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission.md) | chat-ui, daemon, eventual-send | current |
| [security-phases-decisions-and-known-gaps](../sections/endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps.md) | chat-ui, daemon, capability-security, eventual-send | current |

## See also

- `chat-command-bar.md` — slash syntax and modeline completeness invariant; the slot's slash mode mirrors the main command bar with the same Cmd-Enter-to-Monaco affordance.
- `chat-pending-commands.md` — slot slash commands are *not* pending commands; this design clarifies the boundary (slot in-flight state is owned by the form it fills).
- `chat-edit-message-ui.md` / `chat-view-edit-commands.md` — sibling slash-command designs at different surfaces (message envelope, blob inspector); together they form the Chat UI's *slash-command-everywhere* gesture.
- `daemon-form-request.md` — forms with slots are the primary consumer.
- `daemon-guest-eval-simplification.md` — `/js` inside a guest's slot relies on direct `formulateEval` without proposal review.
- `daemon-commands-as-messages.md` — if commands become messages, the outer form's message can absorb retained inputs as its formula inputs.
- `daemon-cross-peer-gc.md` — retained pins interact with the cross-peer GC protocol only through ordinary retention edges.
