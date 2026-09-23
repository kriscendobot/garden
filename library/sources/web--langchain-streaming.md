---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/streaming
source_content_sha256: 7f967e5c4d677bc8e40fc1fac8d8e52adef8c7ac08a56897c7edb56f5bc3e02b
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 3
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30). The page recommends the newer typed-projection event-streaming API (`langchain/event-streaming`, v1.3) for new applications; that page is a separate deferred ingest."
---

LangChain's streaming system surfaces real-time updates from agent runs. Covers the three stream modes (`updates` for agent progress, `messages` for LLM tokens, `custom` for user data emitted via the stream writer), requesting multiple modes (each chunk a `StreamPart` dict), the common patterns (reasoning/thinking tokens, partial+completed tool calls, human-in-the-loop, sub-agent disambiguation via `lc_agent_name`/`subgraphs`), disabling per-model streaming, and the `version="v2"` unified-chunk format.

| Section | Topics | Status |
|---------|--------|--------|
| [stream modes and agent progress](../sections/web--langchain-streaming--stream-modes-and-agent-progress.md) | llm-agent-frameworks, agent-conventions | current |
| [common patterns: reasoning, tool calls, HITL, sub-agents](../sections/web--langchain-streaming--common-patterns-reasoning-tool-calls-hitl-subagents.md) | llm-agent-frameworks, patterns, human-in-the-loop | current |
| [disable streaming and the v2 format](../sections/web--langchain-streaming--disable-streaming-and-v2-format.md) | llm-agent-frameworks, agent-conventions | current |
