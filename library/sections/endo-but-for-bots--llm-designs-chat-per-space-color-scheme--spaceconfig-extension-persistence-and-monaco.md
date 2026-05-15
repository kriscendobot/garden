---
title: SpaceConfig extension, persistence with migration, and Monaco-iframe theme handling
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## `SpaceConfig` gains a `scheme` field

```js
/**
 * @typedef {object} SpaceConfig
 * @property {string} id
 * @property {string} name
 * @property {string} icon
 * @property {string[]} profilePath
 * @property {'inbox'} mode
 * @property {ColorScheme} [scheme] - Color scheme preference (default: 'auto')
 */
```

The `scheme` property is **optional** — `undefined` and `'auto'`
both mean *follow system preference*. Existing persisted configs
without the field are valid.

### Note: SpaceConfig is fragmented across three designs

The current authoritative `SpaceConfig` shape is the union of
fields named across three designs:

| Field | Where introduced |
|---|---|
| `id`, `name`, `icon`, `profilePath`, `mode`, `order` | [[endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence]] |
| (`scheme` *referenced* for home space, not detailed) | [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] |
| `scheme` (defined with 5 values + default) | This design |

A reader looking at the *gutter* design's typedef alone gets an
incomplete picture. The complete typedef has **seven fields** —
six required, one optional. Future chat-design ingests should
treat the typedef as cumulative across the chat-spaces sub-cluster,
or surface the merged definition in a shared place. The
[[space]] concept page is the natural shared definition; that page
should be the source of truth for the cumulative shape, with each
design contributing the fields its scope introduces.

## Home space is special

The home space (`id: 'home'`) **is not persisted in the pet-store**
(see [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]]).
Its scheme is always `'auto'` — the user cannot per-space override
the system preference for home. If the user wants home in a
specific scheme, they change the system preference (or set a
different scheme on every other space, which is unergonomic).

This is a small but deliberate UX choice: home is the *default*
view, and a default that ignores system preference would surprise
users who change OS-level dark mode.

## Persistence and migration

The scheme rides on the existing `SpaceConfig` JSON value in the
pet-store (no new daemon API; same *client-side convention over a
complete daemon API* discipline as
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]]):

```js
const spaceConfig = {
  id, name, icon, profilePath,
  mode: 'inbox',
  scheme: 'dark', // or 'light' or 'auto' or one of the high-contrast values
};
```

### Backward compatibility

`validateSpaceConfig` treats a missing or unrecognized `scheme` as
`'auto'`:

```js
const validSchemes = ['auto', 'light', 'dark', 'high-contrast-light', 'high-contrast-dark'];
const scheme =
  typeof obj.scheme === 'string' && validSchemes.includes(obj.scheme)
    ? obj.scheme
    : 'auto';
```

This is the **whitelist-with-default** pattern: known values pass
through, everything else (missing, mistyped, or maliciously crafted)
becomes the safe default. It applies whenever an enumerated field
must be added to a persisted shape without breaking previously-
written records.

## Monaco-iframe theme handling

The chat client embeds Monaco in a sandboxed iframe
([[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]]).
The iframe is its own document with its own `data-scheme`. The
parent's `applyScheme` posts a `set-theme` message to the iframe
so Monaco's editor theme matches the rest of the UI:

```js
// In monaco-iframe-main.js
// Detects data-scheme on parent document.
// Listens for `set-theme` messages posted by applyScheme().
```

This is the **post-message bridge for sandboxed-iframe theming**
pattern. The iframe can't read the parent's `data-scheme` attribute
directly (cross-origin if the iframe is sandboxed for capability
reasons); the parent posts the theme name, the iframe applies it
locally. The iframe is also documented to *check the initial
`data-scheme` on mount* — covers the case where the user picks a
scheme before the editor is opened.

## Seven shipped implementation steps

The design records seven steps, all marked complete (`✅`):

| Step | What |
|---|---|
| 1 | Restructure CSS for attribute-based override (the dual-selector pattern from the sibling section) |
| 2 | Add `scheme` to `SpaceConfig` (typedef + `validateSpaceConfig` + `applyScheme` in the selection handler) |
| 3 | Factor out scheme-picker component (the standalone factory described in the sibling section) |
| 4 | Add scheme picker to add-space modal |
| 5 | Add edit-space modal (a new modal; see [[endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances]]) |
| 6 | Add `updateSpace(id, updates)` to spaces gutter API |
| 7 | Monaco editor theme updates via post-message bridge |

The seven steps were sequenced so each could ship independently
(restructure CSS first; everything else can ride on the restructure).

## Files created and modified

### Created

- `packages/chat/scheme-picker.js` — the picker component.
- `packages/chat/edit-space-modal.js` — the edit-space modal.

### Modified

- `packages/chat/index.css` — the dual-selector restructure.
- `packages/chat/spaces-gutter.js` — typedef extension; `validateSpaceConfig` update; `applyScheme` integration; `updateSpace` addition; Edit Space context-menu item; `editSpaceModal` initialization.
- `packages/chat/add-space-modal.js` — mount the picker via shared slot.
- `packages/chat/monaco-iframe-main.js` — `data-scheme` detection + `set-theme` listener.

The diff is moderate — one CSS restructure, two new modules, and
adjustments to four existing modules.

## Follow-up work the design names

> **Live preview for Monaco**: the scheme picker applies a live
> preview to the document via `data-scheme`, but does not post
> `set-theme` to Monaco iframes. If the eval form is open while
> changing schemes in the picker, Monaco won't update until the
> space is actually selected.

Acknowledged minor edge case — eval form is typically closed
during space creation / editing. Not blocking; recorded for
future polish.
