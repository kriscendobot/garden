---
title: "Muse Spark 1.1 capabilities (agentic, computer use, coding, multimodal, context)"
source_kind: web
source_url: https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/
source_content_sha256: 12f0e1c902b8a95460949f264882179027144bd527b6cb17f59c01413722cc03
source_authors: [Meta Superintelligence Labs]
source_date: 2026-07-09
ingested: 2026-07-10
ingested_by: scholar
topics: [frontier-model-apis]
status: current
---

## Abstract

The agent-relevant capability profile Meta claims for Muse Spark 1.1: a multimodal reasoning model built for agentic tasks, with tool/function calling that zero-shot-generalizes to new native tools, MCP servers, and custom skills; computer use across applications; strong coding on large codebases; text/image/video/PDF input; a 1-million-token context window with active compaction; and parallel tool calling plus structured output. These are the properties an agent harness needs, stated by the vendor; the evaluation-report section carries the third-party-style benchmark numbers and the caveats.

## What kind of model it is

Muse Spark 1.1 is "a multimodal reasoning model built for agentic tasks" from Meta Superintelligence Labs — an upgrade over Muse Spark 1.0 (April 2026) focused on tool use, coding, and multimodal understanding.

## Agentic tasks

The model targets "personal agentic workflows" requiring "planning and orchestration across a range of external apps and services." Meta claim it can "zero-shot generalize to new native tools, MCP servers, and custom skills" and orchestrate multi-agent systems to optimize latency. It supports **parallel tool calling** and **structured output**.

## Computer use

Muse Spark 1.1 handles computer-use workflows spanning multiple applications. Rather than processing "every desktop step one click at a time," it chooses between automation (writing scripts) and direct interface interaction, "generating batches of actions at each step."

## Coding

Meta report "substantial" improvements on real-world tasks over large, complex codebases: diagnosing bugs, implementing features, executing code migrations, and performing well on Meta's Internal Coding Bench. (The evaluation report's SWE-Bench / Terminal-Bench numbers, and where the model trails Claude 4.8 Opus and GPT, are captured in the [safety-and-agentic-robustness](../sections/web--meta-muse-spark-1-1-eval-report--safety-and-agentic-robustness.md) section.)

## Multimodal

Input modalities are text, images, video, and PDFs, with visual-to-code generation, descriptive captioning, and perception-action integration for agentic workflows.

## Context window

**1 million tokens**, with active context management — the model can "remember actions, retrieve information from much earlier work, and compact in a way that keeps critical steps." (The evaluation report tests an 8-needle retrieval variant at 1M context length.)

Source: [Introducing Muse Spark 1.1 and the Meta Model API](https://ai.meta.com/blog/introducing-muse-spark-meta-model-api/) by Meta Superintelligence Labs, published 2026-07-09; content SHA-256 `12f0e1c902b8a95460949f264882179027144bd527b6cb17f59c01413722cc03`. Vendor claims; unverified by third parties.
