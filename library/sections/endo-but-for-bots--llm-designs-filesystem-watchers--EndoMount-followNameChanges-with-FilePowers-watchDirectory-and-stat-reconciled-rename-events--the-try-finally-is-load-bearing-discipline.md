---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §try-finally-is-load-bearing discipline
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

```js
async function* followNameChanges(...pathSegments) {
  const watcher = filePowers.watchDirectory(target);
  try {
    // snapshot loop
    // live event loop
  } finally {
    watcher.cancel();
  }
}
```

The §iterator-return-as-cleanup-trigger observation:

> *The `try / finally` is load-bearing: when the consumer
> calls `return()` on the iterator (the standard `for await
> … of` cleanup path, and what `makeIteratorRef` triggers
> when the remote subscription is dropped), `finally`
> releases the OS-level watcher handle.*

The §async-generator-finally-is-the-cleanup-hook idiom:
async generators *do* run their `finally` blocks when
`return()` is called on them — the JS spec guarantees it.
This makes `try / finally` *the* mechanism for releasing
resources.

The §remote-cleanup-via-CapTP-propagates-to-finally chain:
remote subscriber drops → `makeIteratorRef` releases →
iterator `return()` fires → `finally` runs → `watcher.cancel()`
releases the OS handle.
