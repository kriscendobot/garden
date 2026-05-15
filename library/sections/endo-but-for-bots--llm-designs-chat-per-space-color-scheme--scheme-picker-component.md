---
title: Scheme-picker component — 2×2 grid + Auto button + live-preview with restore
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
---

## The picker layout

The scheme picker is a standalone component (`scheme-picker.js`)
constructed by `createSchemePicker({ $container, initialValue })`.
It presents an "Auto (follow system)" button above a 2×2 grid of
captioned preview cells. Each cell shows miniature chat bubbles
(received 👋, sent 🚀) rendered in the cell's own scheme colors —
giving the user a *visual preview* of each option rather than
abstract swatch chips.

```
  Color scheme
  [ Auto (follow system) ]
  ┌──────────────┐ ┌──────────────┐
  │  👋          │ │  👋          │
  │          🚀  │ │          🚀  │
  │    Light     │ │     Dark     │
  └──────────────┘ └──────────────┘
  ┌──────────────┐ ┌──────────────┐
  │  👋          │ │  👋          │
  │          🚀  │ │          🚀  │
  │ HC Light     │ │  HC Dark     │
  └──────────────┘ └──────────────┘
```

The preview-via-miniature-of-actual-content pattern is what makes
the picker self-documenting: the user does not need to know what
*"dark"* means in this UI's context because the cell shows it.
Compare to a hex-swatch picker or a labeled-button picker —
neither of those communicates "this is what your inbox will look
like."

## Defaults and selection

- **`Auto` is selected by default.**
- The selected cell is highlighted with a `--accent-primary` border
  (the same accent token used for active spaces in the gutter and
  selected items in the inventory; see
  [[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]]
  for the token list).

## Live-preview with cancellation-restore

The picker's interaction discipline is **eager-preview, lazy-commit**:

- **Selecting** a scheme cell **immediately applies** the preview
  to the entire application by setting `data-scheme` on the
  document element.
- **Cancelling** the modal calls `restoreScheme()` which puts the
  scheme back to its pre-picker state.
- **Submitting** the modal keeps the new scheme.

This is the **live-preview with restore** pattern — apply the
change so the user can *see* what they're choosing, but keep an
undo path until they commit. The chat-spaces-home design's
*belt-and-suspenders discipline*
([[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]])
is the same pattern applied to *load/save symmetry*; this is its
counterpart for *preview/cancel symmetry*.

## Component API

The hardened API:

| Method | Purpose |
|---|---|
| `getValue()` | Returns the current `ColorScheme`. |
| `setValue(scheme)` | Update selection programmatically. |
| `onChange(callback)` | Register a change listener (fires on cell selection). |
| `restoreScheme()` | Restore the scheme from before picker creation (undo all previews). |

The four-method API is deliberately small. There is no
`applyScheme()` on the API — that's a module-internal side effect
of `setValue` and the cell-click handler. The caller cannot ask
the picker to apply a scheme other than the one it's showing; if
the caller wants to apply a scheme independently, it imports
`applyScheme` from `spaces-gutter.js`.

## Mounted into two modals

The picker is mounted into both the add-space modal and the
edit-space modal via a `#scheme-picker-slot` div:

| Modal | Mount surface | Use |
|---|---|---|
| `add-space-modal.js` | `#scheme-picker-slot` inside the form | Picks a scheme for a *new* space |
| `edit-space-modal.js` | `#scheme-picker-slot` inside the form | Edits the scheme on an *existing* space |

The shared-slot-id discipline is what lets one picker factory serve
both modals — the picker doesn't know which modal hosts it; it
just mounts into whatever container is named.

This is the same shared-affordance discipline as the cycle-57
`icon-selector.js` extraction (see
[[endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances]]):
identify the duplicated UI element, extract to its own component,
mount via a slot. The chat client now has at least two such
extracted shared components (icon-selector + scheme-picker); a
*third* would warrant a `shared-affordances/` subdirectory.
