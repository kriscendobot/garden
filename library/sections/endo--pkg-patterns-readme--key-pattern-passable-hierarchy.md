---
title: Key, Pattern, and Passable Hierarchy
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns, pass-style]
status: current
---

> Abstract: The inclusion hierarchy: every Key is a Pattern (one that matches only itself), every Pattern is a Passable (one that classifies). Most Passables are Keys (those with a total order); some are not (records with non-key values). The hierarchy informs which constructs can appear where: only Keys can be CopySet elements; only Patterns can be method guards; all are Passables.

## Key, Pattern, and Passable Hierarchy

Understanding the type hierarchy:

```
Passable (everything that can pass)
├── Error
├── Promise
├── Key (stable, comparable)
│   ├── Primitives (null, undefined, boolean, number, bigint, string, symbol)
│   ├── Remotable
│   ├── CopyArray<Key>
│   ├── CopyRecord<Key>
│   ├── CopySet<Key>
│   ├── CopyBag<Key>
│   └── CopyMap<Key, Passable>
└── Pattern (describes a set of Passables)
    ├── Key (matches itself)
    └── Key-like with Matcher leaves
```

- **Passable**: Can cross vat boundaries (from @endo/pass-style)
- **Key**: Stable and comparable subset of Passable
- **Pattern**: Describes a subset of Passables for matching


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
