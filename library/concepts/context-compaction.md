---
id: context-compaction
aliases: ["compaction", "context compaction", "conversation summarization", "context window summarization", "tool result clearing", "reinitialize context window", "auto-compact", "context roll-forward"]
topics: [context-engineering]
---

# context-compaction

**Context compaction** is the practice of taking a conversation nearing the context-window limit, summarizing its contents, and reinitiating a new context window with the summary. It is typically the **first lever** for long-horizon coherence: it distills the window in a high-fidelity manner so the agent continues with minimal performance degradation. In Claude Code the message history is passed to the model to summarize and compress the most critical details — preserving architectural decisions, unresolved bugs, and implementation details while discarding redundant tool outputs — after which the agent continues with the compressed context plus the five most recently accessed files. The art is in **what to keep versus discard** (over-aggressive compaction loses subtle context whose importance surfaces later); the recommended tuning is maximize recall first, then iterate on precision. The safest, lightest-touch form is **tool-result clearing** — dropping raw results of tools called deep in the history — launched as a feature on the Claude Developer Platform. It is the same shape as the garden harness's context-summary roll-forward that lets a long job continue across a summarization boundary.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Compaction](../sections/web--anthropic-context-engineering--compaction.md) | Defines compaction, Claude Code's summarize-preserve-continue implementation, the recall-then-precision tuning, and tool-result clearing. |
| [Context engineering for long-horizon tasks](../sections/web--anthropic-context-engineering--long-horizon-tasks.md) | Lists compaction as one of three long-horizon techniques, best for tasks requiring extensive back-and-forth. |

## See also

- [[context-pruning]] — the coding-agent-economics "fewer tokens" lever; compaction is one concrete way to prune the window.
- [[context-engineering]] — the umbrella discipline.
- [[context-rot]] — the degradation compaction bounds by keeping the window small.
