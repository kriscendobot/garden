---
title: Awaited agent loop and persistence barrier
source: plans/pi-impl.md
source_repo: cloudflare/cloudflare-os
source_commit: bdb6dc75560e8fa3833e99c9399cae90446d12e1
source_date: 2026-08-03
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, agent-workspaces]
status: current
---

The awaited pi event sink makes `turn_end` the durable persistence barrier: a successful assistant message and its tool results are converted and recorded before another turn may begin.

Streaming message updates map text, thinking, tool-call JSON fragments, and execution completion into the existing client events and preview managers. Each successful turn persists concatenated response text and reasoning, typed tool calls merged with result details, captured actions, connection requests, token usage, and AI Gateway log route. Error or aborted messages persist nothing; aborts surface as cancellation, while provider failures become an `AgentTurnError` for the Overseer's existing reporting policy. A 30-turn cap and existing request, callback, and decision latches govern stopping.

Source: [plans/pi-impl.md](https://github.com/cloudflare/cloudflare-os/blob/bdb6dc75560e8fa3833e99c9399cae90446d12e1/plans/pi-impl.md) at commit `bdb6dc75`.
