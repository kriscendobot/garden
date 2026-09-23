---
title: §Live-discovery via followNameChanges
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
---

```js
const changes = E(registry).followNameChanges();
for await (const change of changes) {
  if ('add' in change) { /* new skill */ }
  if ('remove' in change) { /* skill removed */ }
}
```

§The-same-mechanism-the-Chat-UI-uses-to-watch-inbox-changes. §Borrowable-pattern: §when-an-existing-primitive-already-provides-event-streaming, §use-it-everywhere — §don't-introduce-a-second-event-mechanism.

§Sibling to cycle 213 stream-node's §self-referential-asyncIterator (the §unified-iterator-shape across stream contexts).
