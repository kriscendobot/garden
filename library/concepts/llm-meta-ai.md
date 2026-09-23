---
id: llm-meta-ai
aliases: ["llm-meta-ai", "Simon Willison llm plugin", "LLM CLI", "llm CLI", "Datasette LLM", "llm.datasette.io", "llm install llm-meta-ai", "META_AI_TOKEN", "llm keys set meta-ai", "llm tools loop", "llm -T"]
topics: [llm-agent-frameworks]
status: current
---

# llm-meta-ai

**`llm-meta-ai`** is Simon Willison's plugin (Apache-2.0, PyPI) for his **LLM** CLI + Python library (`llm.datasette.io`) that exposes models hosted by the **Meta AI API**, including [[muse-spark]] 1.1. It is "Simon Willison's tool" in the garden's Muse-Spark research question. Install with `llm install llm-meta-ai`; authenticate with `llm keys set meta-ai` (or the `META_AI_TOKEN` env var); invoke with `llm -m meta-ai/muse-spark-1.1 "…"`. Models are `meta-ai/`-prefixed, API-fetched and cached an hour. Decisively for agentic use, Meta AI models support LLM's **tool calling** (`-T <tool>`, `--td` for tools-debug) and **schemas** (`--schema`), plus image/PDF attachments; they are reasoning models whose reasoning tokens count against a per-model output-token budget (`reasoning_effort`, `max_tokens`; 429 can mean "not enabled for your team"). Because LLM itself runs registered Python tools in an automatic request/execute loop (CLI `-T`; Python `chain()`), this plugin makes an **agentic loop** — not just text completion — reachable for Muse Spark. It is a *thinner* harness than Claude Code, however: it supplies the tool loop but none of Claude Code's built-in file-edit/bash/subagent/permission/hook substrate.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [invocation-and-features](../sections/web--simonw-llm-meta-ai--invocation-and-features.md) | Full harness path: install, auth, model discovery, reasoning-token budget, rate limits, attachments, tools, schemas, and the tool-loop consequence. |
| [overview (Willison)](../sections/web--willison-muse-spark-1-1--overview.md) | The link post that identifies LLM + `llm-meta-ai` as the harness and gives the try-it recipe. |

## See also

- [[muse-spark]] — the Meta model this plugin wraps.
- [[muse-spark-garden-worker-fit]] — why this harness is thinner than Claude Code and what a Spark worker would need built on top.
- [[athanor]] — a sibling tool at the model-serving layer (local runtimes) rather than the provider-plugin layer.
