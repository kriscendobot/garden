---
title: HOWTO tutorial — getting started, first choices, labels, and endings
source: HOWTO.md
source_repo: kriskowal/kni
source_commit: 5e66290e78575af7b55d9a5db5393788cd1f070c
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
notes: Tutorial-shape; overlaps the reference MANUAL sections at a gentler abstraction level — soft cross-reference, not a contradiction.
---

Abstract: The gentle on-ramp half of the "How to Write Kni" tutorial: install and run a one-line story, emit a standalone HTML page, add the first branching choice with `+ [...]` and a prompt `>`, understand that indentation binds a branch's body, make choices disappear with `*`, wire locations together with `@label`/`->label`, and end (or return) with `<-`. Tutorial-shape and intentionally overlapping the reference manual's Options/Threads/Flow sections at a beginner altitude; read this for a worked walkthrough, the manual for the exhaustive rules.

This is the first half of the graduated tutorial (the reference is [MANUAL.md](kni--manual--overview.md)).

**Getting started.** Install with `npm install kni`; write `Hello, World!` in `hello.kni`; run `npx kni hello.kni`. A story becomes interactive when it offers choices. **Stand-alone page:** `npx kni hello.kni --html hello.html` produces a self-contained playable page, customizable with `--html-title` and `--html-background-color`.

**Your first choice.** Add options with `+` and end the choice with a prompt `>`:

```
You stand at a crossroads.

+ [Go left. ]
  The path leads to a meadow.
+ [Go right. ]
  The path leads to a forest.
>

Your journey continues.
```

Each option starts with `+`, its menu text in brackets `[...]`; everything indented under the option happens when it is chosen. The indentation matters — kni uses whitespace to know what belongs to each option.

**Making choices disappear.** Use `*` instead of `+` for options that vanish after being chosen; `->start` loops back:

```
@start
* [Open the mysterious box. ]
  Inside you find a golden key!
+ [Look around. ]
  The room is dusty and old.
>
->start
```

**Labels and jumping.** `@label` marks a spot; `->label` jumps there, connecting locations (a kitchen and a garden) into a graph.

**Ending the story.** `<-` ends the story (or returns from a procedure):

```
+ [Continue your adventure. ]
+ [Quit. ] <-
>
```

Source: [HOWTO.md](https://github.com/kriskowal/kni/blob/5e66290e78575af7b55d9a5db5393788cd1f070c/HOWTO.md) at commit `5e66290e`.
