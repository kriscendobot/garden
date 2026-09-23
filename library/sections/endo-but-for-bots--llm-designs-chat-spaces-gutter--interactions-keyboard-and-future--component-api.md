---
title: Component API
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future
---

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
