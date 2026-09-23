---
title: "Collections: Tables, Coordinate Spaces, and the for loop"
source_kind: web
source_url: http://erights.org/elang/collect/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/collect/index.html
source_fetched_via: mirror
source_content_sha256: 63352d3dba12d6ec7c40b0a01e31457744b1add626383fcc7971369bbf6b36ae
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, pass-style]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The landing page
  of E's *Primitive Data Types / Collections* chapter. Captures the constant /
  flexible by list / map 2-by-2 of E's Table types (ConstList, ConstMap, FlexList,
  FlexMap over the EList / EMap interfaces), the Coordinate Spaces sub-chapter
  pointer, the "other objects that act like collections" framing (directories as
  name-to-file maps), and the single operation all collections share — the `for`
  loop in its iterate-over-values and iterate-over-key-value-pairs forms. The
  per-type child chapters (String-ref, tables.html, coord/) are navigable from the
  source page and not separately ingested.
---

## Abstract

E's **Collections** chapter organizes E's aggregate data types. The core are the
**Tables**: a constant-versus-flexible by list-versus-map two-by-two over the
`EList` and `EMap` interfaces — `ConstList` / `ConstMap` (immutable, the selfless
pass-by-copy members) and `FlexList` / `FlexMap` (mutable, the selfish members),
"E's variations on the traditional array and hashtable". Beyond Tables, the
chapter names **Coordinate Spaces** (abstract geometry for symbolic spaces with
locality: positions, regions, twisters) and the open category of "other objects
that also act in some ways like collections" (a directory is a map from local file
name to file). The one operation E collections generally share is the **`for`
loop**, in both its iterate-over-values and iterate-over-key-value-pairs forms.
This is the ancestor of the four-collection vocabulary the E quick-reference card
records (`erights--elang-quick-ref--idioms-quick-reference`) and, downstream,
Endo's `CopyArray` / `CopyRecord` pass-by-copy aggregates versus the mutable
stores.

## Tables: lists and maps

Tables are E's array-and-hashtable family, a constant/flexible by list/map
two-by-two over the `EList` and `EMap` interfaces:

| | `EList` | `EMap` |
|---|---------|--------|
| **constant** | `ConstList` (and `String`, a ConstList of char) | `ConstMap` |
| **flexible** | `FlexList` | `FlexMap` |

These are "E's variations on the traditional array and hashtable". The constant
forms (`ConstList`, `ConstMap`) are immutable and selfless — they are the
pass-by-copy-between-vats members of E's data model (see
`selfless-and-selfish-objects`); the flexible forms (`FlexList`, `FlexMap`) are
mutable and therefore selfish (identity-compared, pass-by-reference). `String` is
specifically a `ConstList` of `char`.

## Coordinate Spaces and other collections

**Coordinate Spaces** are a separate sub-chapter: abstract geometry for symbolic
spaces with locality (positions, regions, twisters). Tables and Spaces exist
solely in order to be collections.

Other objects exist for other purposes but **also act in some ways like
collections**. The chapter's example is a directory: a `File`-object that
represents a directory maps from local file names to the files or directories
found by those names in that directory. The interactive transcript shows indexing
a directory `File`-object by a property name and reading a contained file's
length:

```
? pragma.syntax("0.8")

? def ehomeDir := <file>[interp.getProps()["e.home"]]
# value: <file:c:/Program Files/erights.org/>

? ehomeDir["eprops-template.txt"].length()
# value: 13845
```

Further documentation on collections other than Tables and Spaces (like
directories) lives in their respective sections (directories under
`elang/io/text-file-io.html`).

## The shared operation: the for loop

The one operation E collections generally have in common is the **`for` loop**, in
both the iterate-over-values form and the iterate-over-key-value-pairs form. The
key-value form iterating a directory:

```
? for name => file in ehomeDir {
>     println(`$name is ${file.length()} bytes`)
> }
# example stdout: bin is 0 bytes
#                 e.jar is 2246185 bytes
#                 README.txt is 8106 bytes
#                 ...
```

The `name => file` head is the iterate-over-key-value-pairs form; dropping `name =>`
gives the iterate-over-values form. Both are E expressions (E has no statements;
see `erights--elang-blocks--block-structure-and-control-flow`).

## Translation

| E term | Endo / Hardened JavaScript equivalent |
|--------|----------------------------------------|
| `ConstList` | `CopyArray` (pass-by-copy array) |
| `ConstMap` | `CopyRecord` / copy collection (pass-by-copy) |
| `FlexList` | mutable array / a store's list |
| `FlexMap` | `MapStore` / mutable map (selfish, pass-by-reference) |
| `String` (ConstList of char) | `string` pass-style |
| `for k => v in coll` | `for (const [k, v] of entries(coll))` idiom |

Source: [elang/collect/index.html](https://erights.github.io/erights-org-website/elang/collect/index.html) (erights.org GitHub Pages mirror), content SHA-256 `63352d3d`, last modified 1998-10-03.
