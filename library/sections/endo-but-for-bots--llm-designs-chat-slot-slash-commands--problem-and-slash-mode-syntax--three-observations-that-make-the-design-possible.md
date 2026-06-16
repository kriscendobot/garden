---
title: Three observations that make the design possible
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon]
status: current
notes: First of five sections for the chat-slot-slash-commands design. Captures the problem framing (4-step pet-store round-trip for one-off values) and the slash-mode syntax inside a slot input. Three observations make the design possible without ambiguity (pet names cannot start with `/`; the daemon already supports transient-pin eval; slot submission re-expresses pet names as formula inputs). Verb table covers `/js`, `/json`, `/locator`, `/ref`.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--problem-and-slash-mode-syntax
---

- Pet names cannot start with `/` (pet-name regex forbids `/`), so
  `/verb ...` is unambiguous against any legal pet name path.
- The daemon already supports anonymous eval formulas via
  `pinTransient` / `unpinTransient` in `formulateEval`. The host's
  own `/js` without a `resultName` uses this path: the value is
  pinned inside the formula-graph lock, the caller holds it across
  the `await value`, then unpins in a `finally`.
- A slot submission re-expresses pet names as formula inputs on
  the downstream formula. The host's `endow` reduces `bindings` to
  `endowmentFormulaIdsOrPaths`, then calls `formulateEval`, which
  records those inputs as graph edges. If the slot value is a
  formula identifier that the daemon is currently retaining on
  the caller's behalf, the downstream formula's inputs retain it
  the moment the outer formula is persisted to disk.

Taken together, a slot filler that does not pollute the pet store
needs exactly one extra piece of machinery: a **temporary pin that
survives from the moment the slash command produces a value until
the outer request either absorbs it or aborts**. The Chat UI
holds that pin via a release capability; the daemon enforces its
lifetime, including automatic release if the captp connection
severs.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
