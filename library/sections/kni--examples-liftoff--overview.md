---
title: "The stateful sequence block"
source: examples/liftoff.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: `{Three… |Two… |One… |Liftoff! <-}` is a bare **sequence block** — no `(cond)`, `@`, or `~` selector — so each time control reaches it, it emits the *next* item and remembers its position, and successive visits count down `Three… / Two… / One… / Liftoff!`. `-> start` re-enters the block each tick, and the final item carries `<-` to exit once the sequence is exhausted. The minimal illustration that a brace block with no selector is *stateful in visit order*.

The whole program is two lines: the sequence block followed by a `/` line break, then `-> start`. The selector face of a brace block is what distinguishes the block families: a leading `(expr)` makes it a switch indexed by state (`bottles`, `paint`), a leading `@` makes it a cyclic switch that wraps (`hilbert`, `tetrominoes`), a leading `~` makes it a random shuffle (`troll`), and *no* leading selector makes it a **sequence** that advances one step per visit and holds on (or, here, exits from) its last item. The `-> start` self-loop is what turns "advance one step" into a running countdown.

For authoring, `liftoff` is the reference for the unselected sequence block — the mechanism behind show-once narrative and one-time options — paired with the `<-` exit and `-> start` re-entry that `loop` isolates for control flow. It is the sequence-family counterpart to `bottles` (a counter switch that loops) and `troll` (a random block that does not advance).

Source: [examples/liftoff.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/liftoff.kni) at commit `435ec3cf`.
