---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: §File tracking — *the cumulative record survives compactions*
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §File tracking paragraph is the most operationally interesting
move:

> *Pi maintains a cumulative file-operations record across
> compactions: even if a file was last touched ten compactions ago,
> the current summary still mentions it. The Endo equivalent
> observes the `Dir`/`File` capabilities the agent invokes and
> tracks which paths it touched. The list survives compactions
> because each summary carries it forward.*

The §carries-forward discipline is the structured-summary's
specific use: the *Files touched* field of one summary becomes the
seed of the next summary's *Files touched* field. The list grows
monotonically across compactions; an agent can know *every file
it has ever touched in this session* without reading the full
JSONL.

The Endo-specific extension — *observes the `Dir`/`File`
capabilities the agent invokes* — leverages the capability-bank
discipline cycle 105 ingested: the agent's authority is bounded by
the capability handles it holds, so the *Files touched* set is
exactly the set of paths the agent's `Dir`/`File` caps have been
asked to operate on. The compaction tool doesn't need to grep the
JSONL for paths — the capability traffic already names them.
