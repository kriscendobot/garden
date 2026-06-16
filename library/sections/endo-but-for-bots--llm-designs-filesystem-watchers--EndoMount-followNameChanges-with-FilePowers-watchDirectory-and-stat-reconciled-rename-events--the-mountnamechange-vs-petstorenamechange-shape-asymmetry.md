---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §MountNameChange-vs-PetStoreNameChange shape asymmetry
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

```ts
type MountNameChange =
  | { add: string; type: MountEntryType }
  | { remove: string };

type MountEntryType = 'file' | 'directory';
```

vs `PetStoreNameChange`:

```ts
type PetStoreNameChange =
  | { add: string; value: IdRecord }
  | { remove: string };
```

The §interface-asymmetry-tracks-ownership-asymmetry observation
(echoed from cycle 157's exo-zip-package):

> *An `EndoMount` does not have formula identifiers to publish
> (file contents are not capabilities), so the second field
> carries the `stat`-derived kind instead, which is the
> information a consumer needs to decide whether to recurse.*

The §minimum-shape-difference discipline: keep the `add` /
`remove` *discriminant* identical so consumers' switch-cases
work; differ only in what *additional info* each variant
carries. The §discriminant-stable-additional-fields-vary
pattern lets polymorphic code mostly work, while typed-
consumers can branch on the extra data.
