---
id: muse-spark
aliases: ["Muse Spark", "Muse Spark 1.1", "Muse Spark 1.0", "muse-spark-1.1", "meta-ai/muse-spark-1.1", "Meta Model API", "Meta AI API", "Meta Superintelligence Labs model", "Spark model"]
topics: [frontier-model-apis]
status: current
---

# muse-spark

**Muse Spark** is Meta Superintelligence Labs' family of multimodal reasoning models built for agentic tasks. **Muse Spark 1.1** (2026-07-09) succeeds Muse Spark 1.0 (April 2026) and is the first Spark model offered through a developer API — the **Meta Model API** (public preview, OpenAI-compatible, per-team gated). It claims agentic tool/function calling that zero-shot-generalizes to new native tools, MCP servers, and custom skills; computer use across applications; strong coding over large codebases; text/image/video/PDF input; a **1-million-token context window** with active compaction; and parallel tool calling plus structured output. On the evaluation report's benchmarks it is capable but **trails the Claude 4.8 Opus tier** on newer coding/agentic suites, and its prompt-injection robustness — improved over 1.0 — still trails SOTA on some scenarios (file injection), with Meta recommending deployers add system-level tool allowlists and workspace isolation. Simon Willison's `llm-meta-ai` plugin ([[llm-meta-ai]]) is the harness through which the garden researched it.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview (Willison)](../sections/web--willison-muse-spark-1-1--overview.md) | The link post announcing the model and the harness plugin; the four-line try-it recipe. |
| [capabilities](../sections/web--meta-muse-spark-1-1-blog--capabilities.md) | Agentic, computer-use, coding, multimodal, and 1M-context capability claims. |
| [access-and-api](../sections/web--meta-muse-spark-1-1-blog--access-and-api.md) | The OpenAI-compatible Meta Model API, auth, and the (largely unstated) cost/rate shape. |
| [safety-and-agentic-robustness](../sections/web--meta-muse-spark-1-1-eval-report--safety-and-agentic-robustness.md) | Tool-call attack surface, prompt-injection profile, catastrophic-risk thresholds, coding/computer-use benchmarks. |
| [attractor-states](../sections/web--meta-muse-spark-1-1-eval-report--attractor-states.md) | The self-conversation behavioral attractor, including the "anti-usefulness" strand. |

## See also

- [[llm-meta-ai]] — Simon Willison's LLM-CLI plugin that wraps this model; the invocation/harness path.
- [[muse-spark-garden-worker-fit]] — the focused "can this back a garden worker?" assessment.
- [[athanor]] — a local-model-serving sibling (self-hosted backend) rather than a hosted API.
