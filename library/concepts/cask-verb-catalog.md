---
id: cask-verb-catalog
aliases: ["cask verbs", "verbs.md", "four-letter verb", "verb code", "verb catalog", "read verb", "reduce verb", "verb dispatch", "verb applicability", "out-of-band type designator", "in-band type designator", "in-band schema hash", "mode field type designator", "size verb", "getv", "getk", "find verb", "walk verb", "list verb", "each verb", "peek verb", "have verb", "read verb code", "setv", "putk", "delk", "delv", "push verb", "popv", "insv", "swap verb", "spli", "fixv", "aloc", "free verb", "updv", "init verb", "writ", "pack verb", "copy verb", "unified operation layer"]
topics: [content-addressed-storage]
status: current
---

# cask-verb-catalog

CASK's vocabulary of **four-letter verb codes** for data-structure operations, where each verb is one abstract signature shape shared across every type that supports it. The unifying convention: every verb operates on a 32-byte **root hash** with the store implicit; **reads** are `(store, root, args...) → value` (no state change) and **reduces** are `(store, root, args...) → root'` (a new root hash for the updated state), the same `(state_hash, args) → new_state_hash` reducer shape the rest of CASK uses. The catalog has **10 reads** (`size`, `getv`, `getk`, `find`, `walk`, `list`, `each`, `peek`, `have`, `read`) and **17 reduces** (`setv`, `putk`, `delk`, `delv`, `push`, `popv`, `insv`, `swap`, `spli`, `fixv`, `aloc`, `free`, `updv`, `init`, `writ`, `pack`, `copy`) for 27 total, of which 6 are structural lifecycle/encoding infrastructure (`init`, `writ`, `pack`, `copy`, `aloc`, `free`) and 21 are data verbs that would generalize over cells and directory entries reached through a path or capability. Which verbs are valid on a value is fixed by **two type designators**: the **out-of-band** 2-byte mode in the cell record or directory entry ("what kind of thing is this?") and the **in-band** schema hash in Links[0] of the root block ("what version, and how are its fields arranged?"). A unified operation layer resolves the target, reads the mode, loads the schema, dispatches the type-specific implementation, and for reduces writes the new root back (a cell CAS or a directory-tree rebuild). A verb applied to an incompatible type is an error, and the same code can carry different semantics across types (`putk` is membership on a set, a key-value pair on a map).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--verbs--verb-catalog](../sections/cask--verbs--verb-catalog.md) | The full catalog: read/reduce signature conventions, type abbreviations, all 27 verbs with per-type function mappings, and the summary table. |
| [cask--verbs--verb-dispatch-and-type-designators](../sections/cask--verbs--verb-dispatch-and-type-designators.md) | The out-of-band mode + in-band schema designators, the five-step dispatch, and verb applicability (incompatible-type errors). |

## See also

- [[cask-reducer-pattern]] — the `(state_hash, args) → new_state_hash` shape every reduce verb instantiates.
- [[cask-named-typed-pointer]] — the 2-byte mode (out-of-band designator) on cells and directory entries that begins verb dispatch.
- [[cask-nursery]] — the `verb` packet command names a verb code from this catalog in its CBOR body.
- [[cask-operational-transform]] — `spli`'s generalized form (`array.Transform` over keep/skip/inject).
- [[cask-block-backbones]] — the array/hashtree/ht→uN types many of these verbs operate over.
