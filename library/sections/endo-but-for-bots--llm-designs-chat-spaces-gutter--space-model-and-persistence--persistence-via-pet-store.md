---
title: Persistence via pet-store
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
