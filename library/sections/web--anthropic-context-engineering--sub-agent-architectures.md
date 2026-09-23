---
title: "Sub-agent architectures"
source_kind: web-essay
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_content_sha256: 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2
source_author: "Anthropic Applied AI team (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
source_date: 2025-09-29
ingested: 2026-07-25
ingested_by: scholar
topics: [context-engineering, agent-fleet-orchestration]
status: current
---

## Abstract

**Sub-agent architectures** are the third route around context limitations: rather than one agent maintaining state across an entire project, specialized sub-agents handle focused tasks with **clean context windows**. A main agent coordinates from a high-level plan while sub-agents perform deep technical work or use tools to find relevant information; each sub-agent may explore extensively (tens of thousands of tokens or more) but returns only a condensed, distilled summary of its work — often 1,000 to 2,000 tokens. The payoff is a clear **separation of concerns**: the detailed search context stays isolated within the sub-agents while the lead agent focuses on synthesizing and analyzing results. Anthropic reports this pattern (detailed in *How we built our multi-agent research system*) delivered a substantial improvement over single-agent systems on complex research tasks. This is the same summarize-and-return-condensed shape the garden's own fleet uses when it dispatches sub-agents and keeps only their final report; see the `agent-fleet-orchestration` topic for the operational multi-agent layer.

## Sub-agent architectures

Sub-agent architectures provide another way around context limitations. Rather than one agent attempting to maintain state across an entire project, specialized sub-agents can handle focused tasks with clean context windows. The main agent coordinates with a high-level plan while subagents perform deep technical work or use tools to find relevant information. Each subagent might explore extensively, using tens of thousands of tokens or more, but returns only a condensed, distilled summary of its work (often 1,000-2,000 tokens).

This approach achieves a clear separation of concerns — the detailed search context remains isolated within sub-agents, while the lead agent focuses on synthesizing and analyzing the results. This pattern, discussed in *How we built our multi-agent research system*, showed a substantial improvement over single-agent systems on complex research tasks.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
