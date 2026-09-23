---
title: SpaceConfig typedef
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence
---

```js
/**
 * @typedef {object} SpaceConfig
 * @property {string} id - unique identifier (crypto.randomUUID)
 * @property {string} name - display name (shown on hover)
 * @property {string} icon - emoji character
 * @property {string[]} profilePath - pet-name path to the agent
 * @property {'inbox'} mode - interaction mode (future: 'conversations', 'channels')
 * @property {number} order - position in the gutter (0-indexed)
 */
```

The `profilePath` field carries a **pet-name path** of exactly the
shape the daemon's name-resolution machinery already consumes (the
same path that `E(agent).send(["bob", "slack"], ...)` resolves
through the agent's directory). A space is therefore a bookmark
*into the daemon's name graph*, not a separate addressing system —
selecting a space is the navigational equivalent of typing the same
path into the command bar.

The `mode: 'inbox'` literal type is the only currently-supported
mode; the design leaves room for `'conversations'` and `'channels'`
as future variants. Treating modes as a closed enum (literal-typed)
rather than a free string is the structured-input convention from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]
applied at the data-model layer.
