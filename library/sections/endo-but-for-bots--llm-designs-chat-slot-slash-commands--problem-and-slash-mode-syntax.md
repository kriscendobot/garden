---
title: Problem framing and slash-mode syntax inside a slot input
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon]
status: current
notes: First of five sections for the chat-slot-slash-commands design. Captures the problem framing (4-step pet-store round-trip for one-off values) and the slash-mode syntax inside a slot input. Three observations make the design possible without ambiguity (pet names cannot start with `/`; the daemon already supports transient-pin eval; slot submission re-expresses pet names as formula inputs). Verb table covers `/js`, `/json`, `/locator`, `/ref`.
kind: index
section_count: 3
---

Slot-local slash commands let a Chat user fill a form slot (a field
that expects a capability reference) with a *throwaway* value
(e.g. a tiny `x => x + 1` function, a JSON literal, a locator
provision) without first naming the value in the pet store. The
slot input itself recognises a `/` prefix, dispatches to a slash
command, evaluates the expression, and fills the slot with the
resulting capability. If the enclosing request is submitted, the
request retains the value through its own formula inputs. If the
request is cancelled, the value is garbage-collected.

Sections:

- [The problem this design solves](endo-but-for-bots--llm-designs-chat-slot-slash-commands--problem-and-slash-mode-syntax--the-problem-this-design-solves.md)
- [Three observations that make the design possible](endo-but-for-bots--llm-designs-chat-slot-slash-commands--problem-and-slash-mode-syntax--three-observations-that-make-the-design-possible.md)
- [Slash mode inside a slot input](endo-but-for-bots--llm-designs-chat-slot-slash-commands--problem-and-slash-mode-syntax--slash-mode-inside-a-slot-input.md)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
