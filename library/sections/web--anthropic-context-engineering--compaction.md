---
title: "Compaction"
source_kind: web-essay
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_content_sha256: 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2
source_author: "Anthropic Applied AI team (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
source_date: 2025-09-29
ingested: 2026-07-25
ingested_by: scholar
topics: [context-engineering]
status: current
---

## Abstract

**Compaction** — the first lever for long-horizon coherence — is the practice of taking a conversation nearing the context-window limit, summarizing its contents, and reinitiating a new context window with the summary. It distills the window in a high-fidelity manner so the agent continues with minimal performance degradation. In Claude Code the message history is passed to the model to summarize and compress the most critical details — preserving architectural decisions, unresolved bugs, and implementation details while discarding redundant tool outputs and messages — after which the agent continues with the compressed context plus the five most recently accessed files, giving users continuity without worrying about window limits. The art lies in **what to keep versus discard**: over-aggressive compaction loses subtle context whose importance surfaces only later. The recommended tuning method is to maximize recall first (capture every relevant piece from the trace) and then iterate on precision (eliminate superfluous content). The safest, lightest-touch form is **tool-result clearing** — once a tool has been called deep in the history, the agent rarely needs the raw result again — most recently launched as a feature on the Claude Developer Platform.

## Compaction

Compaction is the practice of taking a conversation nearing the context window limit, summarizing its contents, and reinitiating a new context window with the summary. Compaction typically serves as the first lever in context engineering to drive better long-term coherence. At its core, compaction distills the contents of a context window in a high-fidelity manner, enabling the agent to continue with minimal performance degradation.

In Claude Code, for example, we implement this by passing the message history to the model to summarize and compress the most critical details. The model preserves architectural decisions, unresolved bugs, and implementation details while discarding redundant tool outputs or messages. The agent can then continue with this compressed context plus the five most recently accessed files. Users get continuity without worrying about context window limitations.

The art of compaction lies in the selection of what to keep versus what to discard, as overly aggressive compaction can result in the loss of subtle but critical context whose importance only becomes apparent later. For engineers implementing compaction systems, we recommend carefully tuning your prompt on complex agent traces. Start by maximizing recall to ensure your compaction prompt captures every relevant piece of information from the trace, then iterate to improve precision by eliminating superfluous content.

An example of low-hanging superfluous content is clearing tool calls and results — once a tool has been called deep in the message history, why would the agent need to see the raw result again? One of the safest lightest touch forms of compaction is tool result clearing, most recently launched as a feature on the Claude Developer Platform.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
