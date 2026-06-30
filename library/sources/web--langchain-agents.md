---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/agents
source_content_sha256: b5c5c292e41a272c72e0e5bbad2536433ccc6fe78c733c6cd7d4c2c3951423fc
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 3
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch (2026-06-30)."
---

LangChain's agents page: the in-depth treatment of the agent loop ("a model calling tools in a loop"), the model+harness framing, the four core components (model, tools, system prompt, structured output), agent invocation against the LangGraph State with thread-scoped persistence and runtime context, and the middleware catalog that configures the harness (execution environment, context management, planning/delegation, fault tolerance, guardrails, steering).

| Section | Topics | Status |
|---------|--------|--------|
| [the agent loop and core components](../sections/web--langchain-agents--agent-loop-and-core-components.md) | llm-agent-frameworks, agent-conventions | current |
| [invocation, runtime context, and streaming](../sections/web--langchain-agents--invocation-streaming-and-state.md) | llm-agent-frameworks, agent-conventions | current |
| [configuring the harness via middleware](../sections/web--langchain-agents--configure-the-harness-via-middleware.md) | llm-agent-frameworks, agent-conventions | current |
