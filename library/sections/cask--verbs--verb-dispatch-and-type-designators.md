---
title: Verb Dispatch and Type Designators
source: doc/design/verbs.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: How a unified operation layer would decide which verb is valid on a value and run it, resting on the two type designators every CASK value reached through a cell or directory entry carries. The **out-of-band** designator is the 2-byte mode field in the cell record or directory entry (see `cells-and-entries.md`): it answers "what kind of thing is this?" (category and subtype) before the value is loaded. The **in-band** designator is the schema hash in Links[0] of a table or structured block: it answers "what version of that kind, and how are its fields arranged?" once the root block is loaded. Together they determine which verbs from the catalog are valid. Verb dispatch then proceeds: resolve the target (cell lookup or directory-path traversal via `walk`), read the out-of-band mode to get the category, load the root block and read the in-band schema if needed, dispatch the verb to the type-specific implementation, and for reduces write the new root hash back to the cell or directory entry (step 5 is a CAS on the cell for mutable targets, or a tree rebuild for an immutable directory entry that produces a new directory root). Verb applicability is type-checked: not every verb applies to every type, and a verb applied to an incompatible type is an error, with the mode and schema together fixing the valid verb set. Examples: `push` on a blob errors (blobs are not sequences of elements), `getk` on an array errors (arrays are indexed not keyed), `setv` on a set errors (sets have keys not indexed values), and `putk` on a set versus `putk` on a map share a code but differ in semantics (membership versus key-value pair).

## Out-of-Band and In-Band Type Designators

A CASK value reached through a cell or directory entry has two type designators:

1. **Out-of-band**: The 2-byte mode field in the cell record or directory entry (see `cells-and-entries.md`). This tells you the category and subtype before you load the value.
2. **In-band**: The schema hash in Links[0] of a table or structured block. This tells you the exact layout and which verbs are applicable once you have loaded the root block.

The out-of-band mode answers "what kind of thing is this?" The in-band schema answers "what version of that kind, and how are its fields arranged?" Together they determine which verbs from this catalog are valid operations on the value.

## Verb Dispatch

A unified operation layer would:

1. Resolve the target (cell lookup or directory path traversal via `walk`).
2. Read the out-of-band mode to determine the category.
3. Load the root block and read the in-band schema if needed.
4. Dispatch the verb with appropriate type-specific implementation.
5. For reduces: write the new root hash back to the cell or directory entry.

Step 5 is a CAS operation on the cell (for mutable targets) or a tree rebuild for the directory entry (for immutable targets that happen to be updated by producing a new directory root).

## Verb Applicability

Not every verb applies to every type. The summary table (see the verb-catalog section) shows which types support which verbs. A verb applied to an incompatible type is an error. The mode and schema together determine the valid verb set. For example:

- `push` on a blob is an error (blobs are not sequences of elements).
- `getk` on an array is an error (arrays are indexed, not keyed).
- `setv` on a set is an error (sets have keys, not indexed values).
- `putk` on a set and `putk` on a map have the same verb code but different value semantics (set membership versus key-value pair).

Source: [doc/design/verbs.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/verbs.md) at commit `cdb975d8`.
