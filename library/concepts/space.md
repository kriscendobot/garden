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

## `SpaceConfig` shape (canonical, from source)

The canonical shape is **the typedef in `packages/chat/spaces-gutter.js`** (the implementation), not any single design. The `SpaceConfig` source-of-truth has **14 properties** as of upstream commit `3b031592` (6 required, 8 optional), plus a separate `ColorScheme` typedef the `scheme` field references:

```js
/**
 * @typedef {'auto' | 'light' | 'dark' | 'high-contrast-light' | 'high-contrast-dark'} ColorScheme
 */

/**
 * @typedef {object} SpaceConfig
 * @property {string} id              // unique identifier (sequential integer as string, e.g., "1", "2"); 'home' for Space 0
 * @property {string} name            // display name (shown on hover)
 * @property {string} icon            // emoji character
 * @property {string[]} profilePath   // pet-name path to the agent; [] for Space 0
 * @property {'inbox' | 'channel' | 'whylip' | 'graph' | 'peers'} mode  // interaction mode
 * @property {ColorScheme} [scheme]                          // color scheme preference (default: 'auto')
 * @property {string} [channelPetName]                       // pet name of the channel object (for channel mode)
 * @property {string} [proposedName]                         // display name for the channel creator
 * @property {string} [whylipSystemPrompt]                   // optional system prompt override (for whylip mode)
 * @property {'chat' | 'forum' | 'outliner' | 'microblog'} [viewMode]  // channel view mode (default: 'chat')
 * @property {boolean} [ownedPersona]                        // whether the space owns the persona (for cleanup on delete)
 * @property {string} [lastChannelPetName]                   // last viewed channel in this space (restored on re-entry)
 * @property {string[]} [channelOrder]                       // persisted channel display order in sidebar
 * @property {Array<{key: string, channelPetName: string, label: string}>} [bookmarks]  // bookmarked threads
 */
```

**`HOME_SPACE_DEFAULTS`** (source `packages/chat/spaces-gutter.js`):

```js
const HOME_SPACE_DEFAULTS = harden({
  id: 'home',
  name: 'Home',
  icon: '🐈‍⬛',
  profilePath: [],
  mode: 'inbox',
  scheme: 'auto',
});
```

### Fragmentation across the chat-spaces sub-cluster

The `SpaceConfig` typedef appears across **three** chat-spaces designs, each design contributing only the fields its scope introduces:

| Design | Fields the design's typedef lists |
|---|---|
| [chat-spaces-gutter / space-model-and-persistence](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence.md) | `id`, `name`, `icon`, `profilePath`, `mode: 'inbox'`, `order` (6 fields; `id` typed as `crypto.randomUUID`; `mode` typed as `'inbox'` literal only) |
| [chat-spaces-home / indelible-space-zero-and-numbering](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering.md) | References `scheme` for the home space but does not detail the type |
| [chat-per-space-color-scheme / spaceconfig-extension-persistence-and-monaco](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco.md) | Adds `scheme: ColorScheme` with the 5-value enum and default `'auto'` |

**Sources where this concept page differs from the design typedefs:**

1. The gutter design lists a `mode: 'inbox'` literal and an `order: number` field; source has neither of those exact shapes — `mode` is a 5-value union (`'inbox' | 'channel' | 'whylip' | 'graph' | 'peers'`) and source has no `order` field on `SpaceConfig` (sorting is by `parseInt(id, 10)` instead).
2. The gutter design types `id` as `crypto.randomUUID`; source comments it as a *sequential integer as string* (`"1"`, `"2"`, etc.).
3. The 8 optional fields (`channelPetName`, `proposedName`, `whylipSystemPrompt`, `viewMode`, `ownedPersona`, `lastChannelPetName`, `channelOrder`, `bookmarks`) are nowhere in the chat-spaces design typedefs; they emerged from `channel`, `whylip`, and persistence work after the designs were authored.

This page is the **cumulative source of truth**. Cycle 62 logged a [`message`](../../entries/2026/05/15/) to `boatman` proposing an upstream PR that consolidates the typedef in one place to eliminate the fragmentation; until that lands, readers consulting any single chat-spaces design get a partial picture and should land here for the full shape.

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

There are **two** numbering schemes, currently out of step:

| | Config key (storage) | Keyboard shortcut |
|---|---|---|
| Home space | `spaces/0` ✓ source | `Cmd+1` ✓ source — but `Cmd+0` per the chat-spaces-home design's target |
| First user space | `spaces/1` ✓ source | `Cmd+2` ✓ source — but `Cmd+1` per the design's target |
| ... | ... | ... |
| Eighth user space | `spaces/8` ✓ source | `Cmd+9` ✓ source — design's target is `Cmd+8`; `Cmd+9` would be the ninth |

The **config-key column** (where each space's JSON is stored under
`['spaces', N]`) matches both designs and the source. The **shortcut
column** is where source and design disagree — chat-spaces-home's
*Numbering Scheme* table lists `Cmd+N → spaces/N` but the source
implements `Cmd+(N+1) → spaces/N` (with no `Cmd+0`). The
chat-spaces-gutter handler shows the source behavior; the
chat-spaces-home table shows the target.

The mismatch is the first instance of the scholar's expanded
*notice-investigate-propose* discipline (cycle 58, 2026-05-15);
see that cycle's result entry for the upstream PR proposal.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [chat-spaces-gutter/motivation-and-architecture](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture.md) | Introduces spaces as the multi-agent context-switch affordance; *no new daemon APIs*. |
| [chat-spaces-gutter/space-model-and-persistence](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence.md) | `SpaceConfig` typedef; pet-store CRUD via `write`/`list`/`lookup`/`remove`/`storeValue`. |
| [chat-spaces-gutter/interactions-keyboard-and-future](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future.md) | 5 user interactions; component-factory API; future-enhancements roadmap (3/6 shipped). |
| [chat-spaces-home/indelible-space-zero-and-numbering](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering.md) | The home space: 4 indelible invariants + 2 configurable fields; `HOME_SPACE_DEFAULTS`; merge-on-load + normalize-on-save; numbering scheme (Cmd+0 table is aspirational; source uses Cmd+1 = home). |
| [chat-spaces-home/context-menu-scope-modal-reuse-and-shared-affordances](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances.md) | `data-menu-scope` attribute system; `showName`-parameterized modal reuse; shared `icon-selector.js` extraction; watcher integration. |
| [chat-spaces-inbox/mode-flow-and-power-resolution](../sections/endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution.md) | `mode: 'inbox'` selects existing `inboxComponent` over the resolved-powers walk through `profilePath`; **zero new files** added — pure composition. |
| [chat-spaces-inbox/badges-message-context-and-future](../sections/endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future.md) | Proposed unread-count badges flag the daemon-API tradeoff; in-space message context: send-target defaults to space's agent; commands scoped to space's capabilities. |
| [chat-components/file-structure-and-component-map](../sections/endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map.md) | Component files: `spaces-gutter.js`, `add-space-modal.js`, `edit-space-modal.js`, `scheme-picker.js`, `icon-selector.js`. |
| [chat-per-space-color-scheme/scheme-values-and-css-application](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application.md) | 5 scheme values; `data-scheme` attribute; dual-selector CSS pattern. |
| [chat-per-space-color-scheme/scheme-picker-component](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component.md) | Standalone `scheme-picker.js`; eager-preview + lazy-commit + restore-on-cancel. |
| [chat-per-space-color-scheme/spaceconfig-extension-persistence-and-monaco](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco.md) | `scheme` added to `SpaceConfig`; whitelist-with-default migration; Monaco-iframe `set-theme` bridge. |
| [chat-high-contrast-mode/scheme-extension-and-css-structure](../sections/endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure.md) | 5-value `ColorScheme` enum; combined `(prefers-color-scheme: dark) and (prefers-contrast: more)` media query; shadows-to-borders substitution. |
| [chat-high-contrast-mode/scheme-picker-integration-and-followups](../sections/endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups.md) | Scheme picker grows to 5 options in 2x2 grid; 4 implementation steps; 3 acknowledged follow-up gaps. |

## See also

- [[token-chip]] — sibling chat-UI concept; the two together cover the chat client's main visual abstractions.
- [[producer-typed-shape-consumer-rendering]] — the `SpaceConfig` typed shape vs. its rendered gutter button is a worked example of this convention applied to UI state.
- [[per-agent-keypair]] — each space's `profilePath` resolves to an agent that has its own `@keypair`; spaces are user-facing handles for those agents.

## Common confusions

- *"Home is `Cmd+0` because chat-spaces-home says so"* — the design says so but the source does not (yet). Current source: `Cmd+1` = home, `Cmd+2..9` = user spaces. The design's Numbering Scheme table is aspirational.
- *"chat-spaces-home corrects chat-spaces-gutter on numbering"* — earlier framing in this concept page's history; it is actually closer to the inverse: chat-spaces-gutter's keyboard handler matches source; chat-spaces-home's *Numbering Scheme* table proposes a change that has not landed.
- *"Spaces are stored in the daemon"* — partially. Storage is in the host's pet-store (which the daemon manages), but the *concept of a space* is purely client-side; no daemon code knows what a space is. The pet-store sees a `spaces` directory of JSON value formulas like any other directory.
- *"The chat-spaces-gutter typedef is the canonical SpaceConfig shape"* — it is **not** as of cycle 62 / commit `3b031592`. The gutter design's typedef predates the addition of `scheme`, `channelPetName`, `proposedName`, `whylipSystemPrompt`, `viewMode`, `ownedPersona`, `lastChannelPetName`, `channelOrder`, and `bookmarks`. The canonical typedef is in `packages/chat/spaces-gutter.js`; **this concept page collects the cumulative shape** that no single design holds.
- *"`SpaceConfig.id` is `crypto.randomUUID`"* — the chat-spaces-gutter design says so, but the source comment names *sequential integer as string* (`"1"`, `"2"`, etc.). The home space is the literal string `'home'`. Sorting is by `parseInt(id, 10)`, which would not produce useful ordering on UUIDs.
- *"`SpaceConfig` has an `order: number` field"* — the chat-spaces-gutter design's typedef lists `order` but the source has no such field. Display order comes from `parseInt(id, 10)` (sequential-integer ids serve as both identity and order key).
- *"`mode` is `'inbox'` only"* — the chat-spaces-gutter design types `mode` as the literal `'inbox'`; source widened it to a 5-value union `'inbox' | 'channel' | 'whylip' | 'graph' | 'peers'` as later modes shipped.

## Provenance note

Concept added cycle 57 at the threshold (after `chat-spaces-home` landed, becoming the third source that uses the term). Cycle 61 added the `chat-per-space-color-scheme` sections. Cycle 62 (this entry) added the chat-color-schemes and chat-high-contrast-mode sections and rewrote the `SpaceConfig` shape block to be the **canonical-from-source** cumulative typedef rather than a copy of any single design's typedef. The cycle 62 *notice-investigate-propose* draft routed to `boatman` proposes an upstream PR to consolidate the typedef in one place; the page will simplify once that lands.
