---
title: "The Hilbert-curve space filler"
source: examples/hilbert.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Two nested loops (`@outer` / `@inner`) sweep `x` and `y` across a `{=10 s}`-wide grid centred on the origin; each cell emits `{@(x-s/2)#(y-s/2)|A|B|…|Z}`, a **cyclic switch** (leading `@`) that indexes the alphabet by the **Hilbert-curve** value (`#`, the binary space-filling operator) of the centred coordinate. Because a Hilbert curve visits adjacent points with adjacent indices, neighbouring cells render adjacent-ish letters and the curve is visible in the printed field. The loops advance with `{+x}` / `{+y}` and re-enter under the guards `{(x <= s)||->inner}` / `{(y <= s)||->outer}`.

The mechanics are three composed primitives. The `#` operator, used here as a binary operator between the two coordinate expressions, produces the linear index a Hilbert space-filling curve assigns to a 2-D point — a mapping that keeps spatial neighbours numerically close. The leading `@` inside the brace makes the block a *cyclic* switch: it indexes the `|A|…|Z` list by the value modulo the list length, so the Hilbert index wraps around the 26 letters. The two `@outer` / `@inner` labels plus the `{+x}` / `{+y}` increments and the `{(cond)||->label}` guarded self-jumps (the same re-enter-a-label-under-a-guard idiom as `bottles`) form the row-major raster.

For authoring, `hilbert` is the reference for kni's space-filling-curve operator and for the cyclic-switch (`@`) selector as distinct from the plain switch (`(expr)`) and the random block (`~`). Its sibling `plane` uses the same grid sweep but wraps the Hilbert value in a consistent hash to *break* the visible curve into an axis-symmetry-free field; `space` and `forest` apply the coordinate-hash idea to procedural place generation rather than a raw raster.

Source: [examples/hilbert.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/hilbert.kni) at commit `435ec3cf`.
