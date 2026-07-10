---
title: "llm-meta-ai: invocation, credentials, and feature surface"
source_kind: web
source_url: https://github.com/simonw/llm-meta-ai
source_content_sha256: 18f2be952b0d7dbf477dda9189414b11598440ac18a2e0a1b47c288725671147
source_authors: [Simon Willison]
source_date: 2026-07-09
ingested: 2026-07-10
ingested_by: scholar
topics: [llm-agent-frameworks]
status: current
---

## Abstract

The complete harness path from a prompt to a Muse-Spark-backed response through Simon Willison's LLM CLI, distilled from the `llm-meta-ai` README. This is the operative "how do I invoke it" reference: install, auth, model discovery, the reasoning-token budget model, per-model rate limits, attachments, and — the load-bearing fact for agentic use — that Meta AI models support LLM's **tool-calling** and **schema** features, which is what turns `llm` from a text-completion front-end into a tool-executing agent loop for this model.

## Installation and credentials

`llm-meta-ai` is an [LLM](https://llm.datasette.io/) plugin (Apache-2.0, on PyPI) for "models hosted by the [Meta AI API](https://developer.meta.com/ai/)." Install it into the same environment as LLM:

```bash
llm install llm-meta-ai
```

Obtain a Meta AI API key and store it under the key name `meta-ai`:

```bash
llm keys set meta-ai
# Paste key here
```

The key can also be supplied via the `META_AI_TOKEN` environment variable.

## Model discovery and invocation

Models are prefixed `meta-ai/`. The model list is fetched from the API and cached for an hour (`llm meta-ai refresh` to force a refetch); `llm models` lists all providers' models, `llm meta-ai models` just Meta's (`--json` for full definitions). A prompt:

```bash
llm -m meta-ai/muse-spark-1.1 "What is the capital of France?"
```

## Reasoning-token budget

These are reasoning models — "they think before they answer, and the reasoning tokens count towards your output token budget" (reported in `completion_tokens_details.reasoning_tokens` in `llm logs --json`). The `reasoning_effort` option takes one of `none`, `minimal`, `low`, `medium`, `high`, `xhigh` (not every model supports every value):

```bash
llm -m meta-ai/muse-spark-1.1 'What is the capital of France?' -o reasoning_effort low
```

## Rate limits and max_tokens

"Requests count against an output token rate limit *before* they run." Setting `max_tokens` conserves quota (leave room for reasoning tokens). Rate limits are per model: a model that returns 429 "even after a long wait may not be enabled for your team, even if it shows up in the models list."

```bash
llm -m meta-ai/muse-spark-1.1 'A short poem about a pelican' -o max_tokens 2000
```

## Attachments, tools, and schemas

- **Attachments:** images (PNG, JPEG, WebP, GIF, ICO) and PDFs via `-a`. MP4 video is supported by the API's Files API but the plugin does not yet use it.
- **Tools:** "Meta AI models support [tools](https://llm.datasette.io/en/stable/tools.html)" — LLM registers Python (or plugin) tools with `-T` and runs the request/execute loop automatically; `--td` (tools-debug) shows the calls:

  ```bash
  llm -m meta-ai/muse-spark-1.1 -T llm_time 'What time is it?' --td
  ```
- **Schemas:** structured output via `--schema`:

  ```bash
  llm -m meta-ai/muse-spark-1.1 'Invent a dog' --schema 'name, age int, breed'
  ```

## The harness consequence

Because LLM itself executes registered tools in an automatic call/execute/feed-back loop (CLI `-T`/`--td`; Python `model.chain(...)` / `conversation.chain(...)` over a tools list), and because Muse Spark 1.1 exposes tool calling through this plugin, an agentic loop is reachable: the model can request a tool, LLM runs the Python function and returns the result, and the exchange repeats until the model emits a final answer. That is the mechanism a Spark-backed worker would be built on — but it is a thinner harness than Claude Code, a gap the concept page [[muse-spark-garden-worker-fit]] examines. Meta AI models are reasoning models, so tool loops also consume reasoning tokens against the output-token budget.

Source: [llm-meta-ai README](https://github.com/simonw/llm-meta-ai) by Simon Willison, captured 2026-07-10 (canonical README from `raw.githubusercontent.com/simonw/llm-meta-ai/main/README.md`); project-page content SHA-256 `18f2be952b0d7dbf477dda9189414b11598440ac18a2e0a1b47c288725671147`.
