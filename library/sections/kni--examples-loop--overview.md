---
title: "The anonymous loop label"
source: examples/loop.kni
source_repo: kriskowal/kni
source_commit: aaf798b724fb8db639fd9303376b16ef6e96fc8c
source_date: 2018-03-09
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Four lines that isolate one construct: the `@...` anonymous loop label. Text `Do a loop: @...` marks a loop point; a "continue" option (no jump) falls through and re-enters the loop, while an "exit" option carries `<-` to return out of it. There is no variable and no counter — the example exists purely to show the loop-back-to-here primitive and the `<-` escape.

The `@...` sugar names the current position as an implicit loop target so an option that does not jump elsewhere naturally repeats it, and `<-` is the explicit break. This is the control-flow skeleton underneath the stateful loops (`calc`, `door`, `maze`): those add a variable and a guard, but the "menu that either repeats the current node or exits" shape is exactly this.

For authoring, `loop` is the reference for the two loop verbs — re-enter the anonymous label to continue, `<-` to break — before any state is layered on.

Source: [examples/loop.kni](https://github.com/kriskowal/kni/blob/aaf798b724fb8db639fd9303376b16ef6e96fc8c/examples/loop.kni) at commit `aaf798b7`.
