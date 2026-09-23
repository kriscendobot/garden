---
title: The problem this design solves
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

Today, the only way to fill a slot is to type (or drop in) a pet
name path that already resolves to a value in the agent's
namespace. If the user wants to pass a throwaway value they must:

1. Open the command bar, type `/js x => x + 1`, and run it.
2. When the eval completes, open the resulting value modal and
   assign it a pet name (e.g., `tmp-inc`).
3. Switch back to the pending request, type `tmp-inc` into the
   slot, and submit.
4. Later, remember to remove `tmp-inc` from the pet store so it
   does not clutter the namespace or pin its subgraph
   indefinitely.

This three-step round-trip is tedious for one-off values and
pollutes the pet store with single-use names. The
`lal-fae-form-provisioning` experience, in particular, surfaces
forms with many slots where most fillers are literal JSON or small
anonymous functions that the user has no reason to name.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
