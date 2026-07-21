---
title: Flow directives — line/paragraph breaks, goto, labels, and loops
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: The directives that shape non-linear flow through the graph: the solidus `/` (line break) and double-solidus `//` (paragraph break); the goto arrow `->label` (jump elsewhere) and the return arrow `<-` (exit / go to the end); labels `@name` that name transitions so they can be targeted; and the special loop label `@...` under which everything at that indentation returns to the label after the level ends. Together these are the edge-forming vocabulary of a kni decision graph — every narrative implicitly starts at the `start` label, and named transitions plus arrows are how the author wires arbitrary topology.

**Solidus.** A single solidus `/` indicates a line break (poetry, not paragraphs). A double solidus `//` indicates a paragraph break.

**Goto and return.** The forward arrow `->` followed by a label sends the narrative to another part of the story. The return arrow `<-` exits (goes to the end). Every narrative implicitly starts with the `start` label.

```
{Three... |Two.. |One. |Liftoff! <-} /
->start
```

**Labels.** A story is a collection of transitions, each with a name. The first transition is implicitly called `start`; its first child is `start.0.1` and its first sibling is `start.1`. To go to other transitions, they must have labels. A label is the symbol `@` followed by a name, appearing anywhere in a narrative. The "99 bottles" song returns to a `@refrain` label until it exhausts:

```
! bottle = 99
@refrain
{(bottle)||1 bottle|{(bottle)} bottles} of beer on the wall. /
{(bottle)||1 bottle|{(bottle)} bottles} of beer. /
You take one down and pass it around. {-bottle} /
{(bottle)|No more bottles|1 bottle|{(bottle)} bottles} of beer on the wall. //
{(bottle)||->refrain}
```

**Loops.** The special label `@...` begins a loop. Everything that follows at that level of indentation returns to this label after the level ends.

```
Do a loop: @...

+ [You c[C]ontinue... ]
+ [You e[E]xit the loop. ] <-
>
```

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
