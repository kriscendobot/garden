---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
title: Settings — four configurable knobs in the per-host store
parent: endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
---

The §Settings table specifies four configurable values:

| Setting | Default | Description |
|---------|---------|-------------|
| `compaction.enabled` | `true` | Auto-compaction on context overflow |
| `compaction.reserveTokens` | `16384` | Reserved for model response |
| `compaction.keepRecentTokens` | `20000` | Recent window kept verbatim |
| `compaction.customInstructions` | unset | Optional global instructions appended to the summary prompt |

The defaults are conservative: 16k reserved + 20k recent =
~36k-token in-memory window after compaction. For 200k-context
models this leaves ~164k for summaries and tool results.
