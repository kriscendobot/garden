---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware
source_content_sha256: e64b2d082c97d6e8b86de69192dd4c6220a0158ffcaac0095935b86c8721381c
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 1
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Thin overview page (~5.7 KB) that links onward to the built-in and custom child pages, which carry the depth. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

The middleware overview: what middleware controls inside an agent (logging/analytics, prompt and tool-selection transforms, retries/fallbacks/early-termination, rate limits, guardrails, PII), how it is added (`middleware=[...]` on `create_agent`), and the key fact that middleware hooks run *inside* the compiled LangGraph `create_agent` returns — so the whole agent (middleware and all) can be dropped into a larger `StateGraph` as a node or subgraph. Depth lives in the built-in (catalog) and custom (hooks) child pages.

| Section | Topics | Status |
|---------|--------|--------|
| [overview and graph composition](../sections/web--langchain-middleware--overview-and-graph-composition.md) | llm-agent-frameworks, agent-conventions, patterns | current |
