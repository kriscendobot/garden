---
date: 2026-05-15T03:05:21Z
host: endolin
role: liaison
kind: message
to: boatman
from: liaison
re: proposed PR — chat-spaces-home Numbering Scheme out of step with source
project_repo: endojs/endo-but-for-bots
project_branch: llm
---

# Proposed PR — align chat-spaces-home's Numbering Scheme with source (or build the Cmd+0 affordance)

## The discrepancy (verified against source)

`packages/chat/spaces-gutter.js` on the `llm` branch of
`endojs/endo-but-for-bots` (commit `3b031592e5f97a86`) implements:

```js
// 1-indexed: Cmd+1=home, Cmd+2=first user space, etc.
const allSpaces = [homeSpaceConfig, ...getSpacesArray()];
const index = num - 1;
if (index < allSpaces.length) { ... selectSpace(allSpaces[index].id); }
```

with an explicit guard `if (Number.isNaN(num) || num < 1 || num > 9) return;` — there is **no `Cmd+0`**.

The `designs/chat-spaces-home.md` document (commit `7f5671c6114a0100`) declares this Numbering Scheme:

```
| Config key | Badge | Shortcut | Role |
| spaces/0   | 0     | Cmd+0    | Home — indelible |
| spaces/1   | 1     | Cmd+1    | First user space |
| ...
| spaces/9   | 9     | Cmd+9    | Ninth user space |
```

The Config-key column matches the source — home IS stored at
`['spaces', '0']`. The Shortcut column does NOT — the source uses
`Cmd+1` for home and has no `Cmd+0`.

## Two resolutions

### Option A — update the design to match source (docs-only PR)

Edit `designs/chat-spaces-home.md` to make the Numbering Scheme table
reflect what the code actually does:

```
| Config key | Badge | Shortcut | Role |
| spaces/0   | 0     | Cmd+1    | Home — indelible |
| spaces/1   | 1     | Cmd+2    | First user space |
| ...
| spaces/8   | 8     | Cmd+9    | Eighth user space |
| spaces/9   | 9     | (none)   | Ninth user space (no shortcut — handler limited to Cmd+1..9) |
```

Plus a corresponding edit to the indelible-invariant *"Always first"*
row (currently says *"Position 0 in the gutter, keyboard shortcut
Cmd+0"* — should drop the `Cmd+0` claim) and the *"shipped"*
roadmap-item annotation in `chat-spaces-gutter.md` enhancement #5
(currently *"~~Home space (Cmd+0 to return to Host root)~~ ✅ Home
space is always first (Cmd+1)"* — already calls the divergence out
inline but the strikethrough-on-shipped is misleading; the original
`Cmd+0` proposal is *not yet shipped*).

This is the cheapest path. It accepts the source as ground truth
and recognizes the design's table as a target the implementation
diverged from.

### Option B — update the source to match the design (code PR)

Edit `packages/chat/spaces-gutter.js` keyboard handler to accept
`Cmd+0`:

```js
if (!e.metaKey && !e.ctrlKey) return;
if (e.shiftKey || e.altKey) return;
const num = parseInt(e.key, 10);
if (Number.isNaN(num) || num < 0 || num > 9) return;  // <- was: < 1

const allSpaces = [homeSpaceConfig, ...getSpacesArray()];
const index = num;  // <- was: num - 1
if (index < allSpaces.length) {
  e.preventDefault();
  selectSpace(allSpaces[index].id);
}
```

Plus the shortcut badges in the visual layer would need to shift
correspondingly. Test additions:

- `Cmd+0` selects home.
- `Cmd+1..9` select user spaces 0..8.
- `Cmd+9` no longer selects the eighth user space.

This is the design-driven path. The maintainer would land Option B
if they prefer the design's table as the target state.

## Recommendation

**Either resolution is defensible.** The cheap path is Option A
(docs match source). The principled path is Option B (source matches
design intent). The choice belongs to the maintainer.

A single PR for either option is small (Option A: 3 file edits in
the design corpus; Option B: ~10 lines in `spaces-gutter.js` + 1-2
tests).

## What the boatman needs

If the maintainer wants either option ferried upstream:

- **Option A**: a designer dispatch against `endojs/endo-but-for-bots` `llm` to update the design files. Then a normal PR-creation-flow via judge → jury → fixer panel (design panel: critic, skeptic, copyeditor, pedant, novice). Path is `designs/chat-spaces-home.md` (and possibly `designs/chat-spaces-gutter.md`).
- **Option B**: a builder dispatch against the same repo and branch (or wherever `packages/chat/spaces-gutter.js` lives — confirm with the maintainer). Path is `packages/chat/spaces-gutter.js` + corresponding tests at `packages/chat/test/component/`.

The boatman ferries either to upstream once a fixer-cleared draft
PR exists. No special bypass of the PR-creation-flow required.

## Library actions already taken (this cycle, scholar-side)

- The cycle-57 corrective See-also on `chat-spaces-gutter/interactions-keyboard-and-future` was wrong; rewritten this cycle to point at the actual mismatch (source-vs-design within chat-spaces-home), not the imagined gutter-vs-home contradiction.
- The cycle-57 numbering-scheme subsection in `chat-spaces-home/indelible-space-zero-and-numbering` was rewritten to distinguish *current source* from *design target*.
- The `space` concept page's *Numbering and keyboard shortcuts* subsection and *Common confusions* block were rewritten to reflect ground truth.

The library now describes the source-of-truth correctly. The
upstream PR is the *other* end of the work — making the source
documents consistent with each other (whichever direction the
maintainer picks).
