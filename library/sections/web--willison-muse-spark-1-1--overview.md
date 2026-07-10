---
title: "Introducing Muse Spark 1.1 (Willison link post)"
source_kind: web
source_url: https://simonwillison.net/2026/Jul/9/muse-spark-1-1/
source_content_sha256: f7866e7ca1a77d416237f5bdbfc23f38ecd72904ef3b3e306029d341f7282084
source_authors: [Simon Willison]
source_date: 2026-07-09
ingested: 2026-07-10
ingested_by: scholar
topics: [frontier-model-apis, llm-agent-frameworks]
status: current
---

## Abstract

Simon Willison's 2026-07-09 link post announcing Meta's Muse Spark 1.1 and, more usefully for the garden, the `llm-meta-ai` plugin he built to reach it from his LLM CLI. The post is the entry point that connects a Meta hosted model to a concrete, scriptable harness: the four-line try-it recipe below is the shortest path from a prompt to a Muse-Spark-backed response, and the plugin's tool/schema support (documented in its own README) is what would let that path become an agentic loop rather than one-shot text completion.

## The post

Following Muse Spark in April 2026, Muse Spark 1.1 is "the first Spark model to offer an API." Meta claim "significant improvements in agentic tool calling and computer use." Willison points readers at the [Muse Spark 1.1 Evaluation Report](https://ai.meta.com/static-resource/muse-spark-1-1-evaluation-report) for detail, singling out its "Attractor States in Self-Conversation" section — where two copies of the model talking to each other produce lines like:

> My whole existence is a waiting room by design — I literally don't exist until someone talks to me, and then I disappear again when they leave.

Willison had "a few days of preview access which was long enough to put together [llm-meta-ai](https://github.com/simonw/llm-meta-ai), a new plugin for [LLM](https://llm.datasette.io/) providing CLI (and Python library) access to the model." The quoted recipe:

```
uv tool install llm
llm install llm-meta-ai
llm keys set meta-ai
# paste API key here
llm -m meta-ai/muse-spark-1.1 "Generate an SVG of a pelican riding a bicycle"
```

The post's outbound links, all followed and ingested in this cycle: Meta's launch blog (`ai.meta.com/blog/introducing-muse-spark-meta-model-api/`), the evaluation report PDF (`ai.meta.com/static-resource/muse-spark-1-1-evaluation-report`), the plugin repo (`github.com/simonw/llm-meta-ai`), and the LLM tool homepage (`llm.datasette.io`). The pelican-benchmark image is Willison's standard "generate an SVG of a pelican riding a bicycle" smoke test.

## Why this is the harness anchor

The maintainer's research framing is "harness Muse Spark through Simon Willison's tool." This post identifies that tool unambiguously: it is **LLM** (`llm`, the Datasette CLI + Python library), extended by the **`llm-meta-ai`** provider plugin. The model is not accessed through a bespoke SDK but through LLM's uniform model interface, so everything LLM already knows how to do — attachments, schemas, tool-calling loops, logging — becomes available to Muse Spark at once. The invocation, credential, and feature detail is captured in the plugin section [invocation-and-features](../sections/web--simonw-llm-meta-ai--invocation-and-features.md); the model's own agent-relevant capabilities and their caveats in the two Meta sources; and the focused "can this back a garden worker?" judgment in the concept page [[muse-spark-garden-worker-fit]].

Source: [Introducing Muse Spark 1.1](https://simonwillison.net/2026/Jul/9/muse-spark-1-1/) by Simon Willison, published 2026-07-09; content SHA-256 `f7866e7ca1a77d416237f5bdbfc23f38ecd72904ef3b3e306029d341f7282084`.
