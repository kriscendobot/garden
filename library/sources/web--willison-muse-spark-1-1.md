---
source_kind: web
source_url: https://simonwillison.net/2026/Jul/9/muse-spark-1-1/
source_content_sha256: f7866e7ca1a77d416237f5bdbfc23f38ecd72904ef3b3e306029d341f7282084
source_authors: [Simon Willison]
source_date: 2026-07-09
retrieved: 2026-07-10
ingested: 2026-07-10
ingested_by: scholar
section_count: 1
status: current
notes: "Simon Willison link-blog post announcing Meta's Muse Spark 1.1 and his llm-meta-ai plugin. Fetched live via direct curl (source_fetched_via=direct); idempotency anchor is source_content_sha256 over the live response body, not a git SHA. The transient-web caveat applies: a link post is short and its permalink is stable, but re-fetch and re-hash if freshness matters. This is the RESEARCH-step primary source for orchestration orch-spark-gardeners (scholar -> designer). The model's own detail (capabilities, API, safety) lives in the two Meta sources it links; the harness detail lives in the llm-meta-ai plugin source. The synthesis 'can this back a garden worker?' assessment is the concept page [[muse-spark-garden-worker-fit]]."
---

## Abstract

*Introducing Muse Spark 1.1* (Simon Willison, 2026-07-09, link blog) is the maintainer-chosen entry point for researching how one would harness **Meta's Muse Spark 1.1** through a Willison tool. The post itself is short: it notes that Muse Spark 1.1 (following the April 2026 Muse Spark) is "the first Spark model to offer an API," that Meta claims "significant improvements in agentic tool calling and computer use," and points at the [Muse Spark 1.1 Evaluation Report](https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report) (Willison highlights its playful "Attractor States in Self-Conversation" section, e.g. *"My whole existence is a waiting room by design — I literally don't exist until someone talks to me"*). The post's substantive contribution is the **harness path**: during a few days of preview access Willison built **`llm-meta-ai`**, a plugin for his [LLM](https://llm.datasette.io/) CLI + Python library, giving command-line and library access to the model. The quoted try-it recipe is `uv tool install llm; llm install llm-meta-ai; llm keys set meta-ai; llm -m meta-ai/muse-spark-1.1 "Generate an SVG of a pelican riding a bicycle"`. This source-index files the post's overview section; the model's capability/access/safety detail is captured under the two linked Meta sources, and the plugin's invocation surface under the `llm-meta-ai` plugin source.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--willison-muse-spark-1-1--overview.md) | frontier-model-apis, llm-agent-frameworks | current |
