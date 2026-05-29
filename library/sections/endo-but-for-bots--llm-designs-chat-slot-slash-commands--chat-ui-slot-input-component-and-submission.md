---
title: Chat UI slot-input component, submission path, and modeline integration
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, eventual-send]
status: current
notes: Fourth of five sections for chat-slot-slash-commands. Consolidates the four bespoke slot-input call sites (`endow-modal.js`, `inbox-component.js`, `send-form.js`, `form-builder.js`, `counter-proposal-form.js`) into one `createSlotInput` component with a typed external API. The submission path: `endow` already resolves bindings to `(FormulaIdentifier | NamePath)[]` and `submit` already marshals `Record<string, unknown>` through `formulateMarshalValue`; the design extends both to accept formula identifiers in any slot position. Includes the two-stage picker drop-down (petname drop-down primary, command drop-down one step away via `/` shortcut), the show-value affordance reusing the existing value modal, error rendering, the form-record capture walk, and the modeline hint table for the four slot states.
---

The Chat UI side of slot slash commands consolidates today's
bespoke slot inputs into one component, wires the picker
drop-down so mouse users discover the affordance, and extends
the two submission entry points (`endow` and `submit`) to accept
formula identifiers alongside pet names. The modeline reuses the
chat-command-bar discipline (`chat-command-bar.md` modeline
completeness invariant) for the four slot-input states.

## Slot input component (`slot-input.js`, new)

Today, slot-like inputs are bespoke in each site that needs them:

- `endow-modal.js` builds slot inputs inline and attaches
  `petNamePathAutocomplete` to each.
- `inbox-component.js` does the same for definition messages.
- `send-form.js`, `form-builder.js`, and `counter-proposal-form.js`
  have their own variants.

We extract a single
`createSlotInput({ $container, E, powers, type, onChange })`
component whose internal state machine implements the states
above and whose external API is:

```ts
type SlotInputAPI = {
  getValue():
    | { kind: 'petName'; path: NamePath }
    | { kind: 'retained'; id: FormulaIdentifier; release: ERef<Releaser> }
    | undefined;
  clear(): Promise<void>;  // calls release() if retained
  focus(): void;
  dispose(): Promise<void>;  // releases any outstanding retained value
};
```

Call sites migrate to the new component. The `type` parameter
matches the form-request field type taxonomy (`petNamePath`,
`source`, etc.) and gates which verbs the slot offers. A
`source`-typed slot offers `/js` by default and does not need
slash mode to be triggered: it is slash mode from the start.

## Slot picker drop-down

For mouse-and-touch users, each slot exposes a picker affordance
(a small dropdown caret at the trailing edge of the input).
Opening the picker reveals the **petname drop-down**: a
scrollable list of pet names of the slot's accepted type, drawn
from the agent's namespace. The slot's modeline simultaneously
notes that typing `/` will start a command, which opens the
**next drop-down for commands**. Two-stage drop-down progression:
the petname drop-down is the primary surface, and the command
drop-down is one step away via the modeline-advertised `/`
shortcut. Keyboard users see the same modeline hint and can type
`/` to move directly into slash mode without going through the
picker.

## Show value

The retained chip's "show value" affordance dereferences the
formula identifier through `E(powers).provide(id)` (the daemon's
ordinary resolver) and renders the result in the same value-modal
the rest of Chat uses for pet-store entries. Because the slot
holds a real locator at all times, no special "ephemeral
inspector" is needed: the existing inspector works against the
retained formula identifier.

## Error rendering

When the verb handler rejects, the slot chip enters an error
substate: red border, argument text re-editable, error message
in the inline hint row beneath the slot. `Enter` re-runs the
handler with the current argument; `Esc` clears the slot.

## Submission: how the slot value reaches the formula

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

## Form record capture

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

## Modeline hints

Per `chat-command-bar.md`, add slot-local modeline entries:

| State             | Hint                                                    |
|-------------------|---------------------------------------------------------|
| `empty` (slot)    | `/ slash command · type pet name · ▾ pick from petnames` |
| `slashCompose`    | `Enter evaluate · ⌘⏎ Monaco · Esc cancel · ⌫ remove verb` |
| `evaluating`      | `running…`                                               |
| `chipRetained`    | `⌫ clear slot · 👁 show value · Enter submit form`        |

## Interaction with pending commands and command bar

`chat-pending-commands.md` describes the pending region for
top-level commands. Slot-local slash commands do **not** appear
in that region because they are not top-level commands: they are
parts of a larger form-in-progress. Their in-flight state is
owned by the form they fill. If the top-level form itself is
recorded as a pending command (per
`daemon-commands-as-messages.md`), the retained slot values are
captured as its inputs, and the pending entry naturally reflects
the composite operation.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
