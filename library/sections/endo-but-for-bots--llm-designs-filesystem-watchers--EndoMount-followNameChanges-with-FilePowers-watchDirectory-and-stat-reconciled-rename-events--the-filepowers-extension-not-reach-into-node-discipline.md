---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §FilePowers-extension-not-reach-into-Node discipline
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

The new primitive sits on `FilePowers`:

```ts
watchDirectory: (path: string) => {
  events: AsyncIterable<{ kind: 'add' | 'remove' | 'replace'; name: string }>;
  cancel: () => void;
};
```

The §minimal-platform-seam discipline: `EndoMount`'s body
calls `filePowers.watchDirectory(target)` — it doesn't reach
into Node's `fs.watch` directly. The §platform-agnostic-body
property: the same `EndoMount` body works on any platform
that provides `FilePowers`.

The §polling-fallback-inside-FilePowers observation: where
`fs.watch` is unavailable or unreliable (some network
filesystems on Linux where inotify fires inconsistently), the
`FilePowers` adapter falls back to *polling diff*. The
`EndoMount` body doesn't know or care.

The §interface-shaped-to-allow-future-implementations
discipline: the `events / cancel` return shape is intentionally
generic; a polling implementation can provide the same
contract.
