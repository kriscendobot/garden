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
kind: index
section_count: 8
---

The Chat UI side of slot slash commands consolidates today's
bespoke slot inputs into one component, wires the picker
drop-down so mouse users discover the affordance, and extends
the two submission entry points (`endow` and `submit`) to accept
formula identifiers alongside pet names. The modeline reuses the
chat-command-bar discipline (`chat-command-bar.md` modeline
completeness invariant) for the four slot-input states.

Sections:

- [Slot input component (`slot-input.js`, new)](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--slot-input-component-slot-input-js-new.md)
- [Slot picker drop-down](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--slot-picker-drop-down.md)
- [Show value](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--show-value.md)
- [Error rendering](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--error-rendering.md)
- [Submission: how the slot value reaches the formula](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--submission-how-the-slot-value-reaches-the-formula.md)
- [Form record capture](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--form-record-capture.md)
- [Modeline hints](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--modeline-hints.md)
- [Interaction with pending commands and command bar](endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission--interaction-with-pending-commands-and-command-bar.md)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
