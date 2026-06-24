---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §single most structurally interesting move — §stat-reconciled-rename-events
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

The §Node-side adapter is the most technically interesting
piece. `fs.watch` emits `'rename'` *for both adds and removes*
— the OS-level notification doesn't tell you which. The
handler must reconcile via `stat`:

```js
for await (const event of watcher.events) {
  const childPath = filePowers.joinPath(target, event.name);
  const present = await filePowers.exists(childPath);
  if (present && !snapshotSet.has(event.name)) {
    // discovered: an add
    const isDir = await filePowers.isDirectory(childPath);
    if (await isConfinedPath(...)) {
      snapshotSet.add(event.name);
      yield { add: event.name, type: isDir ? 'directory' : 'file' };
    }
  } else if (!present && snapshotSet.has(event.name)) {
    // discovered: a remove
    snapshotSet.delete(event.name);
    yield { remove: event.name };
  }
}
```

The §stat-reconciled-rename-events discipline: the OS-level
event is *direction-agnostic*; the handler uses *stat* to
discover which direction. The §in-memory-set-as-truth pattern:
`snapshotSet` tracks *what we've already emitted*; comparing
current existence to that set yields the diff.

The §editor-save-dance-coalescing observation: editor patterns
(write-tmp + rename) generate `remove` + `add` pairs that
*shouldn't* be visible as such. The 50ms debounce window
collapses them. The §bookkeeping-over-in-memory-entry-set-not-
timer-per-event approach makes coalescing cheap.

The §rename-events-mean-something-changed observation: the OS
notifies "the directory's name table changed for some entry";
the user wants the *direction* of change. The reconciliation
step bridges the gap.
