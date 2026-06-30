---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/interrupts
source_content_sha256: 2b8b11d645f16c019d434392733a54d7be5d16fce0cdf70d4e2392e4383656b5
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 3
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is the content hash over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch (2026-06-30)."
---

LangGraph's interrupts page: the in-depth human-in-the-loop treatment. The `interrupt()` pause-and-resume mechanics (checkpointer + `thread_id`, `Command(resume=...)`, node-restarts-from-the-beginning), the catalog of HITL patterns (streaming, multiple interrupts, approve/reject, review-and-edit, interrupts in tools, validating input), and the rules of interrupts (no try/except, no reorder, JSON-serializable payloads, idempotent pre-interrupt side effects) plus static breakpoints for debugging.

| Section | Topics | Status |
|---------|--------|--------|
| [pause and resume mechanics](../sections/web--langgraph-interrupts--interrupt-and-resume-mechanics.md) | llm-agent-frameworks, persistence, patterns | current |
| [human-in-the-loop patterns](../sections/web--langgraph-interrupts--human-in-the-loop-patterns.md) | llm-agent-frameworks, patterns | current |
| [rules and static breakpoints](../sections/web--langgraph-interrupts--rules-and-static-breakpoints.md) | llm-agent-frameworks, patterns | current |
