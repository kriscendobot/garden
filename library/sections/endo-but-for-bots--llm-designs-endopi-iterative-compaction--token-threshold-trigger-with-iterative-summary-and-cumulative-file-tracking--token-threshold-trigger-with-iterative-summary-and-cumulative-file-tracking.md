---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: Token-threshold trigger with iterative summary and cumulative file tracking
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

> *Each compaction's summary takes the *previous* summary as input,
> not the *original* messages. This means a long session accumulates
> one summary, not N summaries.*
>
> — `designs/endopi-iterative-compaction.md` §Iterative property

`endopi-iterative-compaction.md` (152 lines, *Proposed (partially
satisfied)* status, created 2026-05-15) is the fifth endopi-* design
ingested and the *fourth spinout from cycle 121's family keystone*.
Parent: `endopi.md`. The design closes the §Compaction gap surfaced
in §Feature-by-Feature Mapping by *importing Pi's compaction
algorithm as the substrate that
[`lal-transcript-memory-management`](lal-transcript-memory-management.md)
already asks for, in algorithmic form*.
