---
title: "A coordinate-addressed variable grid"
source: examples/paint.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A grid of rooms stored as **dynamically-named variables**: the current room's colour lives in the variable whose name is the interpolated coordinate `{x}.{y}`, read back as a switch `{({x}.{y})|red|green|blue}`. Paint options assign it (`{=red {x}.{y}}` sets the `x.y` variable to the `red` constant); walk options mutate `x` / `y` to address a different variable; `->start` re-renders the newly-addressed room. kni has one flat global variable dictionary, so an unbounded 2-D grid is emulated by composing the key from coordinates.

The initializer `! red = 0 / green = 1 / blue = 2` names the colour constants. The room description reads the *value* of a variable whose *name* is computed: `{x}.{y}` interpolates the two coordinate variables into a dotted key (e.g. `3.2`), the enclosing `(…)` makes that a switch selector, and `|red|green|blue` maps the stored colour index to a word. Painting is the mirror operation: `{=red {x}.{y}}` is the assignment form `{=VALUE NAME}` — store the value `red` (0) in the variable named `{x}.{y}`. The walk options simply `{-x}` / `{+x}` / `{-y}` / `{+y}` to move the addressing cursor, and `->start` re-enters to describe wherever the cursor now points. Nothing bounds the grid; a room exists as soon as it is painted.

For authoring, `paint` is the reference for **interpolated (dynamic) variable names as addressable storage** — composing a key from state to get array/grid semantics out of a flat namespace. It is the 2-D counterpart to `list` (which composes `shapes.{i}` for a 1-D array and tracks `shapes.length`), and the concrete companion to the comment-only namespace sketch in `stars` (a `sector.$x.$y.…` coordinate-keyed schema). The MANUAL expressions-conditions-consequences section documents the interpolated-name syntax abstractly.

Source: [examples/paint.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/paint.kni) at commit `435ec3cf`.
