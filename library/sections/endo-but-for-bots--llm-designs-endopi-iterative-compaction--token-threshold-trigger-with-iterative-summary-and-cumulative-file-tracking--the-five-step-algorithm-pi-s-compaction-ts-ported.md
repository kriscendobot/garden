---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: The five-step algorithm — Pi's compaction.ts ported
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §Algorithm section ports Pi's
`packages/coding-agent/src/core/compaction/compaction.ts`:

1. **Find cut point.** Walk backwards from the newest message,
   accumulating token-count estimates until `keepRecentTokens`
   (default *20000*) is reached. *This is the boundary between
   "summarize" and "keep verbatim".*
2. **Extract.** Collect messages from the previous compaction
   boundary (or session start) up to the cut point.
3. **Generate summary.** Call the same LLM the agent is using,
   with a structured prompt asking for:
   - Goals the user expressed
   - Decisions made
   - **Files touched (cumulative, even those modified before the
     previous compaction)**
   - Open threads
   - Code patterns established
   If a prior summary exists, *pass it as iterative context so the
   new summary builds on it rather than starting fresh*.
4. **Append entry.** Write a `compaction` entry to the JSONL
   session file (per cycle 117's
   `endopi-jsonl-transcript-format`) with `firstKeptEntryId`
   pointing at the cut point.
5. **Reload.** The in-memory transcript is rebuilt with the summary
   entry in place of the elided range.

The five steps mirror Pi's algorithm exactly. The §step-3 LLM
prompt structure is the only piece that admits configuration
(`compaction.customInstructions`); steps 1, 2, 4, 5 are mechanical.
