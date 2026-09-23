---
title: "Emulating arrays with dynamic variable names"
source: examples/list.kni
source_repo: kriskowal/kni
source_commit: 7f0653dc46f3be60610bcf6d33b234f020fdacde
source_date: 2016-08-01
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A dynamic array built from kni's single flat variable dictionary: `shapes.{i}` composes an indexed variable name and `shapes.length` tracks the count, so *add* options write `{=1 shapes.{shapes.length}}` then `{+shapes.length}` (append) and *pop* decrements the length under a `{shapes.length}` non-zero guard. The `@shapes` render loop walks `i` from 0, prints each element via a switch on `shapes.{i}`, applies Oxford-comma-ish delimiters with `{(shapes.length-i-1)|| and |, }`, and exits to `@options` when `{(i >= shapes.length)?->options}`.

The example is the array counterpart to `paint`'s grid. Storage is emulated by *interpolating an index into a variable name*: `shapes.{i}` is the element at position `i`, and a separate `shapes.length` variable is the count — together they are the whole array ADT over a namespace that has no arrays. Appending is two mutations: assign the element at the current length (`{=1 shapes.{shapes.length}}` for a square, `2` for a circle) then bump the length (`{+shapes.length}`); popping is one guarded mutation — the `+ {shapes.length} [Pop a shape. ] {-shapes.length}` option only appears when the length is non-zero (the leading `{shapes.length}` is a thread-skipping guard). The render `@shapes` loop is the readout: it initializes `i=0`, jumps to `@options` once `i` reaches the length (`{(i >= shapes.length)?->options}`, the conditional-jump form), otherwise prints `{(shapes.{i})||square|circle}` and a delimiter chosen by how many elements remain — `{(shapes.length-i-1)|| and |, }` yields " and " before the last item and ", " otherwise. The comment notes the trick "isn't as pretty with the affordance for an Oxford comma."

For authoring, `list` is the reference for **arrays over a flat namespace**: index interpolation plus a length variable, with append/pop and an indexed render loop. It is the 1-D sibling of `paint`'s 2-D grid and uses the same interpolated-variable-name mechanism the MANUAL expressions-conditions-consequences section documents.

Source: [examples/list.kni](https://github.com/kriskowal/kni/blob/7f0653dc46f3be60610bcf6d33b234f020fdacde/examples/list.kni) at commit `7f0653dc`.
