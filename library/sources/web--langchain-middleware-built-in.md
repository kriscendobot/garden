---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware/built-in
source_content_sha256: 1009bcd409a8e5ec4993d8a8e934427d9c9f456a4dc482f5a8e29aaa4de33937
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. A reference-shaped catalog page (~63 KB, ~18 middleware); consolidated into 2 thematic sections per the conventions' reference-document rule, preserving each middleware's H3 anchor inline for grep. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

The prebuilt-middleware catalog: ~18 production-ready, configurable middleware from LangChain and Deep Agents that work with any provider, plus provider-specific middleware (Anthropic/AWS/OpenAI). Consolidated into two thematic sections: (1) context management + cost/resilience control (Summarization, Context editing, Model/Tool call limits, Model fallback, Tool/Model retry); (2) tool shaping + safety + agent capabilities (LLM tool selector, Provider tool search, LLM tool emulator, Human-in-the-loop, PII detection, To-do list, Shell tool, File search, Filesystem, Subagent).

| Section | Topics | Status |
|---------|--------|--------|
| [context management, cost limits, and resilience](../sections/web--langchain-middleware-built-in--context-cost-and-resilience.md) | llm-agent-frameworks, patterns, agent-conventions | current |
| [tool shaping, safety, and agent capabilities](../sections/web--langchain-middleware-built-in--tools-safety-and-capabilities.md) | llm-agent-frameworks, human-in-the-loop, agent-conventions | current |
