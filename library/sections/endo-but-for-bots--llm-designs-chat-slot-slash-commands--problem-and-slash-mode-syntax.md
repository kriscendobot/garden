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

## The problem this design solves

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

## Three observations that make the design possible

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

## Slash mode inside a slot input

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
