---
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/checkpointers
source_content_sha256: 8bd026823683f5a976fd7b1e9cbd52f96dac555ff5dac77526426f08d576c36d
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
section_count: 2
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is the content hash over the page's `.md` rendering. Part of the LangChain/LangGraph focused-ingest batch (2026-06-30). The custom-checkpointer authoring guide (base contract, row-key/index design, delta channels, conformance suite) deferred to follow-on scholar-ingest job."
---

LangGraph's checkpointer guide: the short-term persistence mechanism. Covers threads, checkpoints as super-step state snapshots, pending-writes fault tolerance, the `BaseCheckpointSaver` interface and backends, and the durability modes / replay / update_state / time-travel surface.

| Section | Topics | Status |
|---------|--------|--------|
| [threads, checkpoints, super-step snapshots, fault tolerance](../sections/web--langgraph-checkpointers--threads-checkpoints-and-fault-tolerance.md) | llm-agent-frameworks, persistence | current |
| [durability modes, replay, update_state and time travel](../sections/web--langgraph-checkpointers--durability-modes-and-time-travel.md) | llm-agent-frameworks, persistence | current |
