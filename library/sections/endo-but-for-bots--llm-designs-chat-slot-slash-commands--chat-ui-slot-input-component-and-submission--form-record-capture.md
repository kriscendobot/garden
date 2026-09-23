---
title: Form record capture
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, eventual-send]
status: current
notes: Fourth of five sections for chat-slot-slash-commands. Consolidates the four bespoke slot-input call sites (`endow-modal.js`, `inbox-component.js`, `send-form.js`, `form-builder.js`, `counter-proposal-form.js`) into one `createSlotInput` component with a typed external API. The submission path: `endow` already resolves bindings to `(FormulaIdentifier | NamePath)[]` and `submit` already marshals `Record<string, unknown>` through `formulateMarshalValue`; the design extends both to accept formula identifiers in any slot position. Includes the two-stage picker drop-down (petname drop-down primary, command drop-down one step away via `/` shortcut), the show-value affordance reusing the existing value modal, error rendering, the form-record capture walk, and the modeline hint table for the four slot states.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission
---

The outer form's submit handler walks each slot's `getValue()`:

- `petName` → pass path through as today.
- `retained` → pass `id` through; remember `release` for
  post-submit cleanup.
- `undefined` → fail validation.

After a successful submit, the form calls
`Promise.all(releases.map(r => E(r).release()))`. On failure,
releases are retained on the form model so the user can resubmit
without re-evaluation. On form destruction (modal close,
navigation), all outstanding releases are fired regardless of
submit outcome: the form's `dispose` is the authoritative cleanup
point.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
