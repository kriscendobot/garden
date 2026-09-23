---
title: "Submission: how the slot value reaches the formula"
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

Slot-bearing forms in Chat today either:

- Collect `Record<string, PetNamePath>` and hand it to
  `E(powers).endow(messageNumber, bindings, workerName, resultName)`
  (see `inbox-component.js` definition rendering and `host.js`
  `endow`); or
- Collect `Record<string, unknown>` of form values and hand it to
  `E(powers).submit(messageNumber, values)` (see `mail.js`
  `submit`).

Both daemon entry points already accept either a pet name (or
pet name path), or in the case of `submit` an arbitrary Passable,
which includes capability references. We extend them to accept a
**formula identifier** in any slot position as well:

- `endow` already resolves bindings by calling
  `petStore.identifyLocal` when the binding is a bare pet name
  or by returning the name path otherwise, producing a
  `(FormulaIdentifier | NamePath)[]` passed into `formulateEval`.
  We add a third branch: if the binding is a string that matches
  the `formula:` scheme (or an object carrying a tagged
  `FormulaIdentifier`), pass it through directly.
- `submit` marshals its `values` record through
  `formulateMarshalValue` already, which emits a formula whose
  inputs retain every capability reference mentioned in the
  record. The Chat UI packages a retained formula ID as a
  `Remotable` or as a tagged reference object that
  `formulateMarshalValue` can capture as an input edge.

The submission payload thus crosses the daemon boundary carrying
formula IDs that the Chat UI is currently retaining via release
capabilities. The daemon's formulation persists the new formula
to disk (per the daemon's "disk before graph" rule), at which
point the dependency graph records a retention edge from the new
formula to the previously-retained formula. Only then does Chat
call `E(release).release()`.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
