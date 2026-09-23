---
title: "A recursive spatial procedure with a parameter"
source: examples/tree.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: `@notch(side)` is a procedure that renders its description from its `side` argument (`{not side}` = the trunk fork, `{side}` = a notch leaning `{(side)||northward|southward}`), offers *climb north* / *climb south* (each `->notch(1)` / `->notch(2)`, a recursive call that pushes a frame) and *climb down* (`<-`, returning up one frame), then re-presents itself with `->notch`. Because each climb is a call and each descent a return, the call stack *is* the tree position — a spatial structure encoded entirely as procedure recursion, with the parameter selecting the local description.

The top level plants the reader at the base with two options: *climb up* enters the tree via `->notch(0)`, and *walk away* exits with `<-`. Inside `@notch(side)`, the description branches on the argument — `{not side}` renders the initial fork, `{side}` renders a leaning notch whose direction comes from `{(side)||northward|southward}`. Climbing north or south is `->notch(1)` / `->notch(2)`, each a fresh call that deepens the stack; climbing down is `<-`, which pops back to the caller's `>` prompt and its trailing `->notch` re-presents the menu one level up. There is no coordinate variable at all — depth and orientation live purely in the stack of active procedure frames. The `[You c[C]limb north. ]` options use the second-person question/answer bracket sugar (the capital initial is the keyword-addressable letter).

For authoring, `tree` is the reference for *recursion as spatial structure*: a parameterized, returning procedure whose call/return discipline models a navigable hierarchy without explicit state. It sits between `subroutine` (procedures that build a menu) and `nominal` (a recursive procedure that peels a number), and shares its guarded-option, second-person-bracket surface with `door` and `tetrominoes`.

Source: [examples/tree.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/tree.kni) at commit `435ec3cf`.
