---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/use-functional-api
source_content_sha256: b0b673a401421eab5664b46d5feba365c4c07b61da6f4c6011f5b5f68f86a4b6
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 4
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. The functional API (`@entrypoint` / `@task`) is the decorator-based alternative to the StateGraph graph API (web--langgraph-use-graph-api); both share the same LangGraph runtime. Part of the LangChain/LangGraph focused-ingest batch (the LangGraph remainder, 2026-06-30)."
---

LangGraph's functional API how-to guide: the `@entrypoint` / `@task` programming model that adds LangGraph's features (persistence, memory, human-in-the-loop, streaming) to ordinary Python control flow with minimal restructuring, as an alternative to the StateGraph graph API. Covers the core decorators and composition (single-input entrypoints, task futures and `.result()`, parallel execution, calling compiled graphs and other entrypoints over the shared runtime), per-task/entrypoint execution policy (`RetryPolicy`, async timeouts and `NodeTimeoutError`, `CachePolicy`/`InMemoryCache`), checkpointer-backed persistence (resume-without-rerun, `get_state`/`get_state_history`, `entrypoint.final` to decouple returned from saved value, the `previous` parameter), and human-in-the-loop (the `interrupt()` / `Command(resume=)` pause-resume cycle and the accept/revise/feedback tool-call review pattern).

| Section | Topics | Status |
|---------|--------|--------|
| [the @entrypoint / @task programming model](../sections/web--langgraph-use-functional-api--programming-model-entrypoint-and-task.md) | llm-agent-frameworks, patterns | current |
| [retry policy, timeouts, and task caching](../sections/web--langgraph-use-functional-api--retries-timeouts-and-caching.md) | llm-agent-frameworks, patterns | current |
| [persistence, error resume, and short-term memory](../sections/web--langgraph-use-functional-api--persistence-resume-and-short-term-memory.md) | llm-agent-frameworks, persistence, change-propagation | current |
| [human-in-the-loop with interrupt and tool-call review](../sections/web--langgraph-use-functional-api--human-in-the-loop-interrupt-and-review.md) | llm-agent-frameworks, patterns | current |
