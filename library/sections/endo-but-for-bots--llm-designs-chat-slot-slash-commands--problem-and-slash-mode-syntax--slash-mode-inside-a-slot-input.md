---
title: Slash mode inside a slot input
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

A slot input enters **slash mode** the instant its buffer starts
with a `/` character and nothing else has been committed yet. In
slash mode, the input behaves like a miniature command bar:

- The first whitespace-delimited token after `/` is the verb
  (`js`, `json`, `locator`, ...).
- The remainder, if any, is the verb's argument text.
- The input's modeline switches from "pet name" hints to
  "slash command: &lt;verb&gt;" hints.

Because pet names cannot contain `/`, the prefix is a reliable
discriminator. If the user types `//` or `/ ` the input rejects
the second character with a modeline error. These sequences are
reserved for future escapes.

### Initial verb set

| Verb       | Argument            | Produces                                                |
|------------|---------------------|---------------------------------------------------------|
| `/js`      | single-line expr    | Evaluated expression in the default worker (`@main`). Cmd-Enter (or Ctrl-Enter) expands the input to a Monaco popover for multi-line editing, mirroring the main command line. |
| `/json`    | JSON literal        | Marshalled Passable from `JSON.parse(arg)`. |
| `/locator` | Endo locator URL    | Result of `E(powers).provideLocator(url)`. |
| `/ref`     | pet name path       | Explicit pet name path (pass-through; useful for clarity). |

Verb registration is extensible; the initial set is chosen to
cover the majority of observed "I just want to inline a small
value" cases. `/eval` is accepted as an alias for `/js`,
mirroring the command bar.

There is intentionally **no separate `/js-block` verb**. The
Cmd-Enter (Ctrl-Enter on non-Mac) expansion of `/js` to Monaco is
the same affordance the main command line offers, so the slot's
slash mode and the command bar share one mental model for
multi-line eval.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
