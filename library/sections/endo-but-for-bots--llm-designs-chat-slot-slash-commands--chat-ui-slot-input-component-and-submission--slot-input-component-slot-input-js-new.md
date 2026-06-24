---
title: Slot input component (`slot-input.js`, new)
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

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
