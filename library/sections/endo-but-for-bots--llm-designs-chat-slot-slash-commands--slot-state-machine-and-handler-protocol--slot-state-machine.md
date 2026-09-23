---
title: Slot state machine
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, eventual-send]
status: current
notes: Second of five sections for chat-slot-slash-commands. Captures the slot's state machine (empty → slashCompose → evaluating → chipRetained, with a parallel petNameCompose path) and the per-verb handler retained-value protocol (handler returns `{ id, release }` where `release` is an exo capability). The state machine grows two states beyond the existing pet-name autocomplete + committed-chip pair.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol
---

```
   empty ──'/'──▶ slashCompose ──Enter──▶ evaluating
     ▲                                       │
     │                                       ├── success ──▶ chipRetained
     │                                       └── failure ──▶ slashComposeWithError
     │
     └── any other char ──▶ petNameCompose (existing)
```

- **`slashCompose`**: the input renders the verb as a non-editable
  chip at its left edge, followed by a free-text editor for the
  argument. Backspacing through the argument back to the chip
  removes the chip and returns to `empty`. `Esc` also returns to
  `empty`. Cmd-Enter (Ctrl-Enter) on a `/js` argument expands the
  editor to a Monaco popover.
- **`evaluating`**: the component calls the per-verb handler,
  which returns
  `Promise<{ id: FormulaIdentifier, release: ERef<Releaser> }>`.
  During evaluation the chip shows an indeterminate spinner. The
  outer form's submit button is disabled while any slot is
  `evaluating`.
- **`chipRetained`**: the filled slot renders as a dashed-border
  chip labelled with the verb and a truncated argument preview
  (e.g., `/js x => x+1`). The chip carries the formula
  identifier internally; the daemon retains the underlying value
  via the release capability. The chip exposes a "show value"
  affordance: clicking it opens the same value-inspection modal
  the user would see if the identifier had been resolved through
  the pet store. `Backspace` clears the chip (which triggers the
  release callback); the outer form treats the slot as unfilled.

If the handler rejects, the spinner is replaced by an error
glyph and the argument text is restored to the input for
editing. The modeline shows the error message (truncated, with
hover to expand).

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
