---
title: User interactions, keyboard shortcuts, component API, and roadmap
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## User interactions

| Action | Affordance | Result |
|---|---|---|
| **Click space icon** | Mouse | Navigate to that space's profile path. |
| **Right-click space icon** | Mouse | Context menu — Edit Space / Delete Space. |
| **Click "+" button** | Mouse | Dialog to add new space (name, icon, profile path, scheme). |
| **`Cmd+1` … `Cmd+9`** | Keyboard | Quick switch to space by position (per the keyboard-first navigation principle). |
| **Hover over icon** | Mouse | Tooltip shows space name + shortcut. |

The table is the literal expression of the **keyboard-manual parity
invariant** from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]:
every keyboard-accessible action (`Cmd+1..9`) has a corresponding
manual action (click), and every manual action (right-click context
menu) is also reachable through the keyboard (Tab focus + Menu key,
per the platform's standard accessibility path).

## Keyboard shortcut handler

```js
document.addEventListener('keydown', e => {
  if (!e.metaKey && !e.ctrlKey) return;
  if (e.shiftKey || e.altKey) return;

  const num = parseInt(e.key, 10);
  if (num >= 1 && num <= 9) {
    const sortedSpaces = [...spaces].sort((a, b) => a.order - b.order);
    if (num - 1 < sortedSpaces.length) {
      e.preventDefault();
      selectSpace(sortedSpaces[num - 1].id);
    }
  }
});
```

Two design notes:

1. **Cmd-vs-Ctrl across platforms** is handled by accepting either
   (`e.metaKey || e.ctrlKey`); the platform-appropriate-modifier-key
   principle from
   [[endo-but-for-bots--llm-designs-chat-invariants--principles]]
   applies to the *display* layer (`⌘Enter` vs `Ctrl+Enter`), not
   to the *handler* layer, which accepts both.
2. **Shift / Alt explicitly excluded** — these slots are reserved
   for future per-space actions (`Shift+Cmd+N` might mean "rename
   space N"). Defending the namespace by explicit exclusion is the
   discipline that preserves the modeline-completeness invariant:
   no modifier-combination silently does something unexpected.

## Component API

```js
/**
 * @typedef {object} SpacesGutterAPI
 * @property {() => Promise<void>} refresh
 * @property {(id: string) => void} selectSpace
 * @property {() => SpaceConfig[]} getSpaces
 * @property {(config: Omit<SpaceConfig, 'id'>) => Promise<string>} addSpace
 * @property {(id: string, updates: Partial<Pick<SpaceConfig, 'name' | 'icon' | 'scheme'>>) => Promise<void>} updateSpace
 * @property {(id: string) => Promise<void>} removeSpace
 * @property {() => string} getActiveSpaceId
 */

export const createSpacesGutter = ({
  $container,
  $modalContainer,
  powers,
  currentProfilePath,
  onNavigate,
}) => { /* ... */ };
```

The factory pattern (single function returning a typed API object)
is the chat client's *component shape* convention from
[[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]:
no classes; closed-over state; explicit API surface.

## Visual design

| Element | Style |
|---|---|
| Gutter background | `var(--bg-active)` — slightly darker than sidebar |
| Space icons | 40 × 40 px buttons with emoji |
| Active space | Blue highlight (`var(--accent-primary)`) |
| Badge | Red pill for unread count (future) |
| Add button | Dashed border, "+" character |

The visual-feedback principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] is
visible at the *active-space-highlight* step: a user always knows
which space is current.

## Files

### Created

- `packages/chat/spaces-gutter.js` — gutter component factory.
- `packages/chat/add-space-modal.js` — add space modal (new-agent and existing-profile flows).
- `packages/chat/edit-space-modal.js` — edit space modal (name, icon, scheme).
- `packages/chat/scheme-picker.js` — standalone color scheme picker component.

### Modified

- `packages/chat/chat.js` — import `createSpacesGutter`; add `--gutter-width` CSS variable; add `#spaces-gutter` styles; shift `#pets`, `#messages`, `#chat-bar` right by `--gutter-width`; add `<div id="spaces-gutter"></div>` and `<div id="add-space-modal-container"></div>` to template; initialize gutter in `bodyComponent`.
- `packages/chat/index.css` — scheme picker grid and cell styles.

## Future enhancements

The design records six items, three of which were shipped during
the design's iteration (struck-through inline) and three still
pending:

| # | Item | Status |
|---|---|---|
| 1 | Drag-and-drop reordering | Pending |
| 2 | Unread badges (poll/subscribe to inbox counts) | Pending |
| 3 | Space editing (rename, change icon) | **Shipped** via context menu → Edit Space modal |
| 4 | Space modes beyond inbox (conversations, channels) | Pending |
| 5 | Home space (Cmd+0 to return to Host root) | **Shipped** — Home space is always first (Cmd+1) |
| 6 | Configurable home space (custom icon + color scheme for space 0) | **Shipped** — see `chat-spaces-home.md` (not yet ingested) |

The inline-strikethrough-on-shipped pattern is itself worth noting:
the design document is treated as a *living* record where shipped
items are not deleted but visibly closed. This matches the
shape-not-content principle in reverse — the *shape* of the roadmap
table is preserved, with status replacing absence.

## See also

- [[space]] — concept page collecting all sections that touch the space concept.
- [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] — refines the home space (Space 0). The chat-spaces-home design's *Numbering Scheme* table shows `Cmd+0 = Home` and `Cmd+1..9 = user spaces`, but that is **aspirational** — the current source `packages/chat/spaces-gutter.js` (verified cycle 58) implements the handler shown above: `Cmd+1..9 → allSpaces[num - 1]` where `allSpaces = [homeSpaceConfig, ...userSpaces]` and there is no `Cmd+0`. The handler shown in *this* section is the **current source-of-truth**. Aligning the design table to source, or building `Cmd+0` to align source to design, is open work; see cycle-58 result for the investigation and PR proposal.
