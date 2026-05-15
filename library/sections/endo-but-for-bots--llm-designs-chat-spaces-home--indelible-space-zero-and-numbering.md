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
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]]; this design *corrects* the gutter design's keyboard-shortcut numbering — the gutter design said "Home space is always first (Cmd+1)" but this design moves home to `spaces/0` / **Cmd+0** with user spaces at `spaces/1..9` / **Cmd+1..9**.
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
| **Always first** | Position 0 in the gutter, keyboard shortcut Cmd+0 |
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

## Numbering scheme (and the correction to chat-spaces-gutter)

```
| Config key | Badge | Shortcut | Role |
|------------|-------|----------|------|
| spaces/0   | 0     | Cmd+0    | Home — indelible |
| spaces/1   | 1     | Cmd+1    | First user space |
| spaces/2   | 2     | Cmd+2    | Second user space |
| ...        | ...   | ...      | ... |
| spaces/9   | 9     | Cmd+9    | Ninth user space |
```

**This is the authoritative numbering**. The earlier
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future]]
keyboard-handler was written before this design landed — it
dispatched `Cmd+1..9` to positions 0..8 in the sorted-spaces array.
With the home space at position 0, the corrected mapping is:

- **Cmd+0** → position 0 (Home).
- **Cmd+1..9** → positions 1..9 (user spaces).

User-visible keyboard shortcuts and the badges displayed on each
space match the `spaces/N` config-key index exactly; the
chat-spaces-gutter handler must be updated to align.

This is the **first cluster-internal correction** the chat-spaces
sub-cluster surfaces. The chat-spaces-gutter source-index notes
should be updated with a forward-pointer to the corrected
numbering; for now the disambiguation lives here, on the
authoritative side.
