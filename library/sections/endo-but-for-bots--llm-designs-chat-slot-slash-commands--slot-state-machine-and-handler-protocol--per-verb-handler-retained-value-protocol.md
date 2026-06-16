---
title: Per-verb handler retained-value protocol
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

Each verb handler follows this shape:

```js
/** @returns {Promise<{ id: FormulaIdentifier, release: ERef<Releaser> }>} */
const handleJs = async (argument) => {
  const { id, release } = await E(powers).makeRetainedValue({
    type: 'eval',
    source: argument,
    codeNames: [],
    endowments: [],
    workerName: '@main',
  });
  return harden({ id, release });
};
```

`makeRetainedValue` is a new method on `EndoHost` and `EndoGuest`
that wraps the existing transient-pin code path but exposes the
pin / unpin lifecycle to the caller explicitly. (See the
daemon-changes section for the implementation shape.)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
