---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware/custom
source_content_sha256: 7313334a4204f63b0804d6c77c82e3f2d4218960555d0e846e159d8be0ebf0e9
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

How to build custom middleware: the two hook styles (node-style `before_agent`/`before_model`/`after_model`/`after_agent`; wrap-style `wrap_model_call`/`wrap_tool_call`), how each style updates state (dict-through-reducers vs `ExtendedModelResponse`+`Command`), creation via decorators vs `AgentMiddleware` classes, custom state schema, custom stream transformers, the before/after/wrap execution order, agent jumps (`jump_to`), and five worked examples (dynamic prompt, dynamic model selection, dynamic tool selection, tool-call monitoring, Anthropic prompt caching).

| Section | Topics | Status |
|---------|--------|--------|
| [hooks, state updates, creation, and execution order](../sections/web--langchain-middleware-custom--hooks-state-and-execution-order.md) | llm-agent-frameworks, patterns, agent-conventions | current |
| [worked examples](../sections/web--langchain-middleware-custom--examples.md) | llm-agent-frameworks, patterns, agent-conventions | current |
