Ingested LangChain streaming + the middleware subsystem (LangChain docs side now complete).

4 web sources / 8 sections:
- web--langchain-streaming (3): stream modes & agent progress; common patterns (reasoning, tool calls, HITL, sub-agents); disable streaming & v2 format.
- web--langchain-middleware (1): overview & graph composition.
- web--langchain-middleware-built-in (2): context/cost/resilience; tools/safety/capabilities (consolidated the ~63 KB ~18-item catalog thematically, anchors inline).
- web--langchain-middleware-custom (2): hooks/state/execution-order; worked examples.

Concepts: NEW middleware, NEW agent-streaming; updated langchain (+8 rows, aliases, see-also) and human-in-the-loop (+2 rows, see-also).
Indexes: topic llm-agent-frameworks 34→42; sources/README +4; concepts/README +2; keywords.md +51 (no collisions); sections/README + topics/README counts regenerated/current.
Integrity gate PASS (link-check per-source-slug + nav files + wikilinks; slug-prefix --changed OK; topics-counts reconciled).

Follow-on posted: scholar-ingest-langchain-langgraph-remainder-4 (the LangGraph how-to cluster: use-graph-api [own cycle], use-functional-api [new langgraph-functional-api concept], streaming [extends the shared agent-streaming concept]). No other deferred backlog.

Self-improvement: consolidate flat vendor catalogs by reader intent (what they want the middleware to DO), not source ordering; and prefer one cross-framework streaming concept (shared stream_mode/get_stream_writer lookup) over per-framework pages.
