---
title: Frozen Objects Only
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style, hardened-javascript]
status: current
---

> Abstract: Marshal refuses to serialize unfrozen objects; the caller must harden() values before passing them to toCapData. This guarantees that the serialized representation reflects the exact value sent, with no mutation race between serialization and inspection.

## Frozen Objects Only

The entire object graph must be "hardened" (recursively frozen), such as done
by the `harden` function installed when importing `@endo/init`. `toCapData` will
refuse to marshal any object graph that contains a non-frozen object.


Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
