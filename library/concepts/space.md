---
id: space
aliases: ["space (chat)", "spaces", "home space", "Space 0", "spaces gutter", "Cmd+0", "Cmd+1..9", "indelible space", "user space"]
topics: [chat-ui, agent-conventions]
---

# space

A **space** is the Familiar Chat client's bookmark into the daemon's
capability graph — a one-click navigation target with a persistent
icon, name, and `profilePath` (the pet-name path to the agent the
space addresses). The spaces gutter is a 48px left-edge sidebar of
spaces; selecting a space navigates the inventory + inbox to that
agent's perspective. Spaces are stored as JSON value formulas under
a `spaces` directory in the host's pet-store — **client-side
convention over an existing daemon API; no new formula types
required**.

## `SpaceConfig` shape

```js
{
  id: string,             // crypto.randomUUID for user spaces; 'home' for Space 0
  name: string,           // display name; 'Home' enforced for Space 0
  icon: string,           // emoji or 2-letter icon
  profilePath: string[],  // pet-name path; [] for Space 0
  mode: 'inbox',          // future: 'conversations', 'channels'
  order: number,          // position in the gutter (0-indexed)
}
```

## Two kinds of space

| Kind | Position | `profilePath` | `id` | Deletable? |
|---|---|---|---|---|
| **Home space** | Always `spaces/0` | `[]` (root agent) | `'home'` | No — indelible |
| **User space** | `spaces/1..9` (and beyond) | Arbitrary | `crypto.randomUUID()` | Yes |

The home space is *configurable* in `icon` and `scheme` only; its
`name`, `profilePath`, `id`, and `mode` are enforced on save and
re-merged from defaults on load — so even if external code wrote a
malformed entry at `['spaces', '0']`, the chat client's view of home
remains consistent (the *belt-and-suspenders* discipline).

## Numbering and keyboard shortcuts

Config keys, badges, and shortcuts are aligned 1:1:

| Config key | Badge | Shortcut | Role |
|---|---|---|---|
| `spaces/0` | `0` | Cmd+0 | Home — indelible |
| `spaces/1` | `1` | Cmd+1 | First user space |
| ... | ... | ... | ... |
| `spaces/9` | `9` | Cmd+9 | Ninth user space |

This is the authoritative numbering as of `chat-spaces-home`; the
earlier `chat-spaces-gutter` keyboard handler (which dispatched
`Cmd+1..9` to positions 0..8) is out of date and should be aligned.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [chat-spaces-gutter/motivation-and-architecture](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture.md) | Introduces spaces as the multi-agent context-switch affordance; *no new daemon APIs*. |
| [chat-spaces-gutter/space-model-and-persistence](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence.md) | `SpaceConfig` typedef; pet-store CRUD via `write`/`list`/`lookup`/`remove`/`storeValue`. |
| [chat-spaces-gutter/interactions-keyboard-and-future](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future.md) | 5 user interactions; component-factory API; future-enhancements roadmap (3/6 shipped). |
| [chat-spaces-home/indelible-space-zero-and-numbering](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering.md) | The home space: 4 indelible invariants + 2 configurable fields; `HOME_SPACE_DEFAULTS`; merge-on-load + normalize-on-save; corrected numbering scheme. |
| [chat-spaces-home/context-menu-scope-modal-reuse-and-shared-affordances](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances.md) | `data-menu-scope` attribute system; `showName`-parameterized modal reuse; shared `icon-selector.js` extraction; watcher integration. |
| [chat-components/file-structure-and-component-map](../sections/endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map.md) | Component files: `spaces-gutter.js`, `add-space-modal.js`, `edit-space-modal.js`, `scheme-picker.js`, `icon-selector.js`. |

## See also

- [[token-chip]] — sibling chat-UI concept; the two together cover the chat client's main visual abstractions.
- [[producer-typed-shape-consumer-rendering]] — the `SpaceConfig` typed shape vs. its rendered gutter button is a worked example of this convention applied to UI state.
- [[per-agent-keypair]] — each space's `profilePath` resolves to an agent that has its own `@keypair`; spaces are user-facing handles for those agents.

## Common confusions

- *"Home is space 1"* — only in the earlier chat-spaces-gutter description; the corrected numbering is **home = space 0 = Cmd+0**.
- *"Spaces are stored in the daemon"* — partially. Storage is in the host's pet-store (which the daemon manages), but the *concept of a space* is purely client-side; no daemon code knows what a space is. The pet-store sees a `spaces` directory of JSON value formulas like any other directory.

## Provenance note

Concept added cycle 57 at the threshold (after `chat-spaces-home`
landed, becoming the third source that uses the term). Future
chat-spaces-* designs (`chat-spaces-inbox.md`,
`chat-per-space-color-scheme.md`) will extend the section table.
