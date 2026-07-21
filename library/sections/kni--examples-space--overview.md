---
title: "Procedural star-system generation"
source: examples/space.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A `@system` label that renders a star system whose name and contents are a pure hash of the `(x, y)` sector coordinate: the `#` consistent-hash operator picks a planet count and, through nested `@name()`/`@number()` procedures, assembles pronounceable names from coordinate-hashed syllable tables. The only interaction is a `[Jump]` option that adds a random delta to `x` and `y` and re-enters `@system`, so the map is deterministic per coordinate yet endless.

The generation is entirely coordinate-derived: `{#(x#y)+1 | ... ||}` uses the inner binary `#` (a Hilbert-curve hash) to choose how many worlds a system has, and `@name()` layers several `{#x#y|...}` switches to build a name with no repeating structure. Nothing is stored per system; revisiting the same `(x, y)` regenerates the identical system because the hash is a function of position alone — the "consistent hash gives free, stable procedural content" idiom.

Read alongside `forest`, `maze`, and `paint`, `space` is the richest coordinate-hash example: it composes procedures, nested hash switches, and a jump-to-neighbor loop into a self-contained generator, showing how far kni's deterministic-hash-of-state pattern scales without any external storage.

Source: [examples/space.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/space.kni) at commit `435ec3cf`.
