---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/tools
source_content_sha256: a40a0dad0d7db34773b41d18074eec8e6f33c66305ab16b346e6df3679c10174
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 4
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch (2026-06-30)."
---

LangChain's tools page: defining tools with the `@tool` decorator and required type-hint schemas, accessing runtime information through the `ToolRuntime` parameter (state, context, store, stream writer, execution info, server info), tool execution and the choice of return value (string, object, multimodal, `Command`, `return_direct`), error handling via middleware, and shaping the toolset at runtime (dynamic selection, headless client-side tools, prebuilt tools).

| Section | Topics | Status |
|---------|--------|--------|
| [defining tools and their schemas](../sections/web--langchain-tools--defining-tools-and-schemas.md) | llm-agent-frameworks, agent-conventions | current |
| [accessing context via ToolRuntime](../sections/web--langchain-tools--accessing-context-via-toolruntime.md) | llm-agent-frameworks, agent-conventions, persistence | current |
| [execution and return values](../sections/web--langchain-tools--execution-and-return-values.md) | llm-agent-frameworks, agent-conventions | current |
| [dynamic selection, headless, and prebuilt tools](../sections/web--langchain-tools--dynamic-selection-headless-and-prebuilt.md) | llm-agent-frameworks, agent-conventions | current |
