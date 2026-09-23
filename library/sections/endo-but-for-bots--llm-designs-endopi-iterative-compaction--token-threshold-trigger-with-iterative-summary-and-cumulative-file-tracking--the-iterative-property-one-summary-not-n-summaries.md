---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: The §Iterative property — *one summary, not N summaries*
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §Iterative property paragraph is the design's *single
structurally interesting claim*:

> *Each compaction's summary takes the *previous* summary as
> input, not the *original* messages. This means a long session
> accumulates one summary, not N summaries. Pi's structured format
> makes the summary parseable enough that the next compaction can
> merge cleanly.*

The implication: a session that has been compacted ten times has
*one* summary at the head of the in-memory window, not ten nested
summaries. The structured-summary format (*Goals / Decisions /
Files touched / Open threads / Code patterns established*) is
*parseable enough that the next compaction can merge cleanly* —
the structure is what makes the iterative merge tractable.

This is the *structured-summary-as-iteration-substrate* discipline.
Without the structure, each compaction would either restart fresh
(losing earlier context) or accumulate N summaries (consuming all
the tokens the compaction was meant to save).
