---
title: Space model and pet-store-based persistence
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## SpaceConfig typedef

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

## Persistence via pet-store

Spaces are stored under a `spaces` directory in the host's pet-
store. The three CRUD operations:

### Create a space

```js
const spaceConfig = { id, name, icon, profilePath, mode: 'inbox', order: 0 };
const valueRef = await E(powers).storeValue(JSON.stringify(spaceConfig));
await E(powers).write(['spaces', id], valueRef);
```

Two-step: serialize the config to a JSON value formula via
`storeValue`, then bind the resulting reference under the
`['spaces', id]` pet-name path.

### List spaces

```js
const spaceIds = await E(powers).list('spaces');
for (const id of spaceIds) {
  const ref = await E(powers).lookup(['spaces', id]);
  const json = await E(ref).text();
  const config = JSON.parse(json);
}
```

`list('spaces')` returns the keys directly under the `spaces`
directory; each key lookup yields the value reference; `text()`
realizes the JSON; `JSON.parse` recovers the typed `SpaceConfig`.

### Remove a space

```js
await E(powers).remove(['spaces', id]);
```

The value formula referenced from the pet name remains in the
formula graph until GC'd through normal daemon retention rules
([[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]]).
The pet-name removal is what makes it user-invisible.

## Why this works

The design's *"No new formula types, no new daemon APIs"* claim
rests on three properties of the existing daemon surface:

1. **`pet-store.write(path, value)`** accepts arbitrary path arrays — a `spaces` directory is one such path.
2. **`pet-store.list(dirPath)`** enumerates a directory's children — any directory, not a privileged one.
3. **`host.storeValue(string)`** is the daemon's primitive for *here is a value, persist it and give me a reference* — used internally for many things, now used for `JSON.stringify(spaceConfig)`.

Together these are sufficient to encode a *typed namespace* (the
`spaces` directory of `SpaceConfig` JSON values) on top of the
daemon's untyped name-resolution primitives. The design is in this
sense a worked example of the **client-side convention over a
complete daemon API** discipline.

The same shape recurs in other client-side conventions over the
existing pet-store — message storage, message-number bindings, and
host directory hierarchies all use the same write / list / lookup /
remove vocabulary.
