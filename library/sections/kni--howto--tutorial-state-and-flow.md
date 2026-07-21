---
title: HOWTO tutorial — variables, conditional options, procedures, and loops
source: HOWTO.md
source_repo: kriskowal/kni
source_commit: 5e66290e78575af7b55d9a5db5393788cd1f070c
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
notes: Tutorial-shape; overlaps the reference MANUAL sections at a gentler abstraction level — soft cross-reference, not a contradiction.
---

Abstract: The stateful half of the tutorial: remembering choices with variables (`{=1 hasKey}`), showing values (`{(gold)}`), the modify forms (`{+gold}`/`{-5 gold}`/`{=10 gold}`), conditional options gated on state (`+ {gold >= 10} [...]`), the condition-and-consequence operators (`{-arrow}`, `{!doorOpen}`, `{?doorOpen}`) that both guard and mutate, a full locked-door worked example, question/answer menu-vs-narrative text, random events `{~...}`, sequences `{first|second|}`, simple loops `@...`, and callable procedures `->inventory()`. Tutorial-shape restatement of the manual's state/expression/flow model, ending with the "write a three-room story with a locked door" exercise.

**Remembering things with variables.** Set with `{=value variable}`; test with `{(hasKey)? then | else }`:

```
You find a rusty key.
{=1 hasKey}
+ [Try the locked door. ]
  {(hasKey)? The key fits! The door swings open.
  | The door is locked. You need a key.}
>
```

**Showing and changing values.** Display with `{(gold)}`; declare with `! gold = 10`; modify with `{+gold}`, `{+5 gold}`, `{-gold}`, `{-5 gold}`, `{=10 gold}`.

**Conditional options.** A condition in braces before the option text makes it appear only when met: `+ {gold >= 10} [Buy the expensive hat. ] {-10 gold}`. **Conditions with consequences** both check and mutate: `{-arrow}` (shows only with an arrow, uses one), `{!doorOpen}` (shows only if closed, opens), `{?doorOpen}` (shows only if open, closes) — the key to inventory and state management.

**A complete example — the locked door:** the reader must find the key, unlock the door, open it, and walk through, driven entirely by `hasKey`/`doorOpen`/`doorLocked` state and the conditional options over them.

**Questions and answers.** The `[...]` text is the menu question; text after is the narrative answer (`+ [Open the door. ] You swing the heavy door open.`). Nested brackets give second-person forms (`+ [You o[O]pen the door. ]`).

**Random events, sequences, loops, procedures.** `{~a|b|c}` picks at random; `{first|second|third|}` shows different text each visit (final empty variant disappears); `@...` auto-loops back after each choice; a procedure with `()` is callable and returns to its call site:

```
- @inventory()
  You are carrying
  {(gold)|nothing|{(gold)} gold{(arrows)| and {(arrows)} arrows|}}.

You enter the shop.
->inventory()
```

The tutorial closes with an exercise: write a three-room story with a locked door, an item to find, and consequences that follow the reader — and points to [MANUAL.md](kni--manual--overview.md) for the complete reference.

Source: [HOWTO.md](https://github.com/kriskowal/kni/blob/5e66290e78575af7b55d9a5db5393788cd1f070c/HOWTO.md) at commit `5e66290e`.
