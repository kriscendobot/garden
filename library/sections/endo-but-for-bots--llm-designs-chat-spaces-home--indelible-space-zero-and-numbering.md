---
title: Indelible Space 0, configurable surface, and the corrected numbering scheme
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling refinement of [[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]] covering the *configurable home space*. The *config-key* numbering (`spaces/0` for home, `spaces/1..9` for user spaces) IS implemented in source. The *keyboard-shortcut* numbering shown in this section's table (`Cmd+0` for home) is **aspirational** — the current source implements `Cmd+1` = home, `Cmd+2..9` = first 8 user spaces, with no `Cmd+0`. The design's table and the source are out of step on this one point. See the section body for the resolution + cycle-58 result for the upstream PR proposal.
---

The spaces gutter has a *home space* — Space 0, bound to the root
agent — that the previous design ([[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]])
treated as a hardcoded constant. This design makes Space 0
**configurable in two fields (icon, scheme)** while keeping it
**indelible in four others (position, name, profile-path,
existence)**.

## Indelible invariants (four)

| Invariant | What it means |
|---|---|
| **Always first** | Position 0 in the gutter (in source, keyboard `Cmd+1`; the design's table claims `Cmd+0`, but that is aspirational — see *Numbering scheme* below) |
| **Always named "Home"** | Name is enforced on save regardless of stored config |
| **Always bound to root agent** | `profilePath` is always `[]` |
| **Cannot be deleted** | The Delete menu item is hidden for Home (see the sibling section on context-menu scope) |

## Configurable surface (two fields)

| Field | Values |
|---|---|
| `icon` | Any emoji from the icon grid, or a 2-letter icon |
| `scheme` | `'auto'`, `'light'`, `'dark'`, `'high-contrast-light'`, `'high-contrast-dark'` |

That's the entire configurable surface — name, profile-path, mode,
and id are all fixed.

## `HOME_SPACE_DEFAULTS`

```js
const HOME_SPACE_DEFAULTS = harden({
  id: 'home', name: 'Home', icon: '🐈‍⬛',
  profilePath: [], mode: 'inbox', scheme: 'auto',
});
```

Three discipline rules around defaults:

1. **On load (`refresh()`)**, only `icon` and `scheme` are merged
   from stored config. `name`, `profilePath`, `id`, and `mode` are
   always taken from defaults. *Storage is allowed to drift; the
   merged config is the source of truth.*
2. **On save (`updateSpace('home', updates)`)**, indelible fields are
   enforced before storing at `['spaces', '0']`. *Storage is
   normalized on write so that even if external code wrote a bad
   shape, the next save corrects it.*
3. **`harden()` on the defaults object**, per the hardened-JavaScript
   convention from the broader Endo ecosystem.

The two-sided enforcement (merge-on-load AND normalize-on-save) is
the *belt-and-suspenders* discipline: even if external code wrote
an unhardened or malformed entry at `['spaces', '0']`, the chat
client's view of home is always consistent.

## Numbering scheme — design intent vs. current source

The design records this table:

```
| Config key | Badge | Shortcut | Role |
|------------|-------|----------|------|
| spaces/0   | 0     | Cmd+0    | Home — indelible |
| spaces/1   | 1     | Cmd+1    | First user space |
| spaces/2   | 2     | Cmd+2    | Second user space |
| ...        | ...   | ...      | ... |
| spaces/9   | 9     | Cmd+9    | Ninth user space |
```

**The config-key column matches source**: the home space is stored
at `['spaces', '0']` (verified at `packages/chat/spaces-gutter.js`
line ~297), and user spaces use the keys above it.

**The Shortcut column does not match source.** The current keyboard
handler at `packages/chat/spaces-gutter.js` lines ~907-921 reads:

```js
if (Number.isNaN(num) || num < 1 || num > 9) return;
// 1-indexed: Cmd+1=home, Cmd+2=first user space, etc.
const allSpaces = [homeSpaceConfig, ...getSpacesArray()];
const index = num - 1;
```

So the source implements: `Cmd+1` = home, `Cmd+2` = first user
space, …, `Cmd+9` = eighth user space. There is **no `Cmd+0`**.
The Shortcut column in the table above is **aspirational** — the
design's target state, not the implemented state.

The mismatch is internal to chat-spaces-home: its `spaces/N`
storage scheme is implemented, but its corresponding `Cmd+N`
keyboard scheme is not. Two ways to resolve:

1. **Update the design** to match source (change the Shortcut
   column to show `Cmd+1` = home, `Cmd+2..9` = first 8 user spaces),
   acknowledging the mismatch between config-key index and shortcut
   number for home.
2. **Update the source** to implement `Cmd+0` = home and shift user-
   space shortcuts to `Cmd+1..9`, aligning source to the design's
   target.

The investigation and PR-proposal live in cycle-58's result entry.
The library shows the *current source-of-truth* in the
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future]]
section's keyboard handler.

This is the **first instance** of the scholar's expanded
*notice-investigate-propose* discipline (per the maintainer's
2026-05-15 directive). Future inter-source contradictions get
investigated against source the same way.
