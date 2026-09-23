---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/structured-output
source_content_sha256: de77c57a14a983fe045f403b1320e28a8ef1c5ae5c3f3c14ba22a2583f40dd6f
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. This is the agent-level (`create_agent`) structured-output page, deeper than the models-page treatment. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

LangChain's structured-output page (agent-level, `create_agent`): returning data in a predictable schema (Pydantic / dataclass / TypedDict / JSON Schema) in the `structured_response` state key. The `response_format` parameter and the two strategies (`ProviderStrategy` native vs `ToolStrategy` tool-calling, with auto-selection from model capabilities); and the `ToolStrategy` retry/error-handling machinery (multiple-output and validation errors, the six `handle_errors` shapes, custom tool-message content).

| Section | Topics | Status |
|---------|--------|--------|
| [response_format and the provider/tool strategies](../sections/web--langchain-structured-output--response-format-and-strategies.md) | llm-agent-frameworks, agent-conventions | current |
| [ToolStrategy error handling and retries](../sections/web--langchain-structured-output--tool-strategy-error-handling.md) | llm-agent-frameworks, patterns, agent-conventions | current |
