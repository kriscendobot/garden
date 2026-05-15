---
title: Context-menu scope, modal reuse via `showName`, shared icon-selector, watcher integration
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
---

The home-space affordances surface four reusable patterns the rest
of the chat client benefits from.

## Context-menu scope system

Menu items carry a `data-menu-scope` attribute that classifies them
along the indelible-vs-delible axis:

| Scope | Shown for |
|---|---|
| `"all"` | All spaces (indelible and delible) |
| `"delible"` | Only non-home spaces |

The runtime toggle:

```js
const isIndelible = spaceId === 'home';
for (const $item of $menu.querySelectorAll('[data-menu-scope]')) {
  const scope = $item.getAttribute('data-menu-scope');
  $item.style.display =
    (scope === 'all' || (!isIndelible && scope === 'delible'))
      ? '' : 'none';
}
```

Currently:

- **Edit Space** (`data-menu-scope="all"`) — shown for every space.
- **Delete Space** (`data-menu-scope="delible"`) — hidden for home.

The pattern generalizes: any future per-space action (Pin /
Duplicate / Mute / Rename) carries one of the two scope values and
the menu builder doesn't need to special-case the home id. This is
the **declarative scope** discipline applied to a context menu —
the data attribute is the *single point* where indelibility shapes
the surface, replacing what would otherwise be N conditional
branches.

## Modal reuse via `showName`

The `createEditSpaceModal` factory accepts an optional `showName`
boolean parameter:

| `showName` | Behavior |
|---|---|
| `true` (default) | Renders the Name field; validates name on submit |
| `false` | Omits the Name field; uses `editingSpace.name` on submit |

Two instances are created in `spaces-gutter.js`:

1. **`editSpaceModal`** — `showName: true`, for regular spaces.
2. **`homeEditModal`** — `showName: false`, for the home space.

The parameter-toggle approach (one factory, two configurations)
avoids two separate modal components with 95% shared code. The
**name is the only differentiating field** between regular-space
editing and home-space editing; everything else (icon picker,
scheme picker, OK / Cancel buttons, validation pipeline) is
identical.

## Shared icon-selector extraction

The icon-selector UI was previously duplicated between
`add-space-modal.js` and `edit-space-modal.js`. The design extracts
it to a new `icon-selector.js` module that exports:

| Export | Purpose |
|---|---|
| `ICON_CATEGORIES` | Hardened category-to-emoji map |
| `ALL_ICONS` | Hardened flat array of all icons |
| `letterIcon(letters)` | Truncates input to 2 uppercase chars (the letter-icon variant) |
| `renderIconSelector({ selectedIcon, useLetterIcon })` | Returns HTML string |

This is the *third extraction* in the chat client's recent
architectural history (the first two were the per-concern component
splits captured in
[[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]).
The shared-module-as-extraction pattern is the chat client's
canonical way to *remove duplication* without prematurely abstracting.

## Watcher integration

The spaces-directory watcher handles space `'0'` specially:

| Event | Handler |
|---|---|
| `handleSpaceAdded('0')` | Reload home config from store, re-render |
| `handleSpaceRemoved('0')` | Reset to `HOME_SPACE_DEFAULTS`, re-render |
| Other space IDs | Normal `spacesMap` add / remove behavior |

The remove-handler's behavior is the load-bearing one: **deleting
the `spaces/0` entry doesn't delete the home space; it resets it to
defaults**. Combined with the cannot-delete invariant from the
sibling section, the home space is structurally undeleteable —
even direct pet-store manipulation (e.g. by another agent) can't
remove home; the worst it can do is wipe the user's customizations
back to defaults.

## Files modified

| File | Change |
|---|---|
| `packages/chat/icon-selector.js` | **New** — shared icon selector module. |
| `packages/chat/add-space-modal.js` | Import shared icon selector; remove duplicates. |
| `packages/chat/edit-space-modal.js` | Import shared icon selector; add `showName` option. |
| `packages/chat/spaces-gutter.js` | Home config storage / loading; context menu; wiring. |
| `packages/chat/test/component/spaces-gutter-home.test.js` | **New** — component tests. |

## Test coverage matrix

| Test | What it validates |
|---|---|
| Right-click home shows Edit not Delete | Context-menu scope system |
| Right-click regular space shows both | Scope system for delible spaces |
| Edit home modal omits Name field | `showName: false` behavior |
| Change home icon/scheme stores correctly | Store at `['spaces', '0']` with enforced name/path |
| Home loads stored icon/scheme on refresh | Merge from stored config |

The matrix is **one row per design invariant** — every constraint
in the design has a corresponding test, and every test maps back to
one constraint. The 1:1 mapping is the testing-discipline
counterpart of the modeline-completeness invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] —
*every property has a visible affordance for verification*.
