---
title: "Context engineering for long-horizon tasks"
source_kind: web-essay
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_content_sha256: 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2
source_author: "Anthropic Applied AI team (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
source_date: 2025-09-29
ingested: 2026-07-25
ingested_by: scholar
topics: [context-engineering]
status: current
notes: "Section intro; the three named techniques each have their own section — see web--anthropic-context-engineering--compaction, --structured-note-taking, and --sub-agent-architectures."
---

## Abstract

The problem statement for long-horizon tasks and the three techniques that address it. Long-horizon tasks — large codebase migrations, comprehensive research projects, anything spanning tens of minutes to hours of continuous work — require the agent to maintain coherence, context, and goal-directed behavior over a sequence of actions whose total token count exceeds the context window. Waiting for larger context windows is not the answer: for the foreseeable future, windows of all sizes remain subject to context pollution and relevance concerns where the strongest performance is desired. Anthropic names three techniques that address the context-pollution constraint directly — **compaction**, **structured note-taking** (agentic memory), and **multi-agent (sub-agent) architectures** — each developed in its own section. The choice among them depends on task shape: compaction maintains conversational flow for back-and-forth tasks; note-taking excels for iterative development with clear milestones; multi-agent architectures handle complex research and analysis where parallel exploration pays dividends. Maintaining coherence across extended interactions remains central even as models improve.

## Context engineering for long-horizon tasks

Long-horizon tasks require agents to maintain coherence, context, and goal-directed behavior over sequences of actions where the token count exceeds the LLM's context window. For tasks that span tens of minutes to multiple hours of continuous work, like large codebase migrations or comprehensive research projects, agents require specialized techniques to work around the context window size limitation.

Waiting for larger context windows might seem like an obvious tactic. But it's likely that for the foreseeable future, context windows of all sizes will be subject to context pollution and information relevance concerns — at least for situations where the strongest agent performance is desired. To enable agents to work effectively across extended time horizons, we've developed a few techniques that address these context pollution constraints directly: compaction, structured note-taking, and multi-agent architectures.

The choice between these approaches depends on task characteristics. For example:

- **Compaction** maintains conversational flow for tasks requiring extensive back-and-forth;
- **Note-taking** excels for iterative development with clear milestones;
- **Multi-agent architectures** handle complex research and analysis where parallel exploration pays dividends.

Even as models continue to improve, the challenge of maintaining coherence across extended interactions will remain central to building more effective agents.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
