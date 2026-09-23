---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: §Compaction is lossy — *the JSONL preserves what the in-memory
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

window prunes*

The §Compaction is lossy paragraph names the *two-layer-storage*
discipline:

> *The original messages remain in the JSONL file (per
> [endopi-jsonl-transcript-format](endopi-jsonl-transcript-format.md)).
> Compaction prunes the in-memory window the LLM sees, not the
> on-disk record. An operator or the agent itself can recover
> detail by re-reading the JSONL.*

This is the §architecture-of-two-readers cycle 117's
`endopi-jsonl-transcript-format` already laid down: *the agent
itself* (resumes a session by reading its own JSONL) + *the
operator* (`endo session list/show` CLI). Compaction *operates on
the agent's in-memory view*, leaving the operator's view (the
JSONL on disk) untouched.

The trade-off is explicit: in-memory window can be small and
fast-to-process; on-disk record can be long and full-fidelity.
*The compaction summary is what bridges them.*
