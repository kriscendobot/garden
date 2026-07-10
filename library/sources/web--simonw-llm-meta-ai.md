---
source_kind: web
source_url: https://github.com/simonw/llm-meta-ai
source_content_sha256: 18f2be952b0d7dbf477dda9189414b11598440ac18a2e0a1b47c288725671147
source_authors: [Simon Willison]
source_date: 2026-07-09
retrieved: 2026-07-10
ingested: 2026-07-10
ingested_by: scholar
section_count: 1
status: current
notes: "The README of Simon Willison's llm-meta-ai plugin (Apache-2.0, on PyPI), which wraps Meta's Muse Spark family for his LLM CLI + Python library. Fetched live via direct curl. The source_content_sha256 recorded here is over the rendered GitHub project page (286028B) captured by fetch-source.sh; the section body quotes the canonical README.md text fetched from raw.githubusercontent.com/simonw/llm-meta-ai/main/README.md (3413B). This is a rendered-web / repo-README hybrid ingested one-off as source_kind: web rather than a bare-clone repo source (no bare clone of the plugin exists in worktrees/), so the idempotency anchor is the content hash, not a per-file git commit; re-fetch the raw README to re-check freshness. Establishes the harness path for [[muse-spark-garden-worker-fit]]."
---

## Abstract

`llm-meta-ai` is Simon Willison's **plugin for the [LLM](https://llm.datasette.io/) CLI and Python library** that exposes models "hosted by the [Meta AI API](https://developer.meta.com/ai/)," Muse Spark 1.1 among them. It is the concrete tool the maintainer's research question ("harness Muse Spark through Simon Willison's tool") points at. The README establishes the full invocation surface: installation (`llm install llm-meta-ai`), credential mechanics (`llm keys set meta-ai`, or the `META_AI_TOKEN` environment variable), model discovery (`llm models` / `llm meta-ai models` / `llm meta-ai refresh`; models are prefixed `meta-ai/` and the list is API-fetched and cached for an hour), and — decisively for agentic use — that **Meta AI models support LLM's tool-calling and schema (structured-output) features** (`-T llm_time … --td`, `--schema 'name, age int, breed'`), take image and PDF attachments, are reasoning models whose reasoning tokens count against the output-token budget (`reasoning_effort` one of none/minimal/low/medium/high/xhigh), and are rate-limited per model against an output-token budget charged *before* a request runs (`max_tokens` to conserve quota; a persistent 429 can mean the model is not enabled for your team). Because LLM itself executes registered Python tools in an automatic call/execute loop, tool support is what makes an agentic loop possible through this harness rather than mere text completion.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [invocation-and-features](../sections/web--simonw-llm-meta-ai--invocation-and-features.md) | llm-agent-frameworks | current |
