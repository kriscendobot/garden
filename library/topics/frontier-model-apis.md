# Topic: frontier-model-apis

> Abstract: Hosted frontier LLM model APIs evaluated as agent/worker backends — what they are, their agent-relevant capabilities (tool/function calling, context window, multimodality, structured output, streaming, reasoning-token budgets), how they are accessed (endpoint, auth, OpenAI-compatibility), their cost/rate-limit shape, and their safety/robustness posture (prompt-injection resistance, recommended system-level controls). The *hosted-backend* sibling of `local-model-serving` (single-machine inference runtimes) and distinct from `llm-agent-frameworks` (the harness/orchestration layer that drives such a model). First entry: **Meta's Muse Spark 1.1** (July 2026), a multimodal agentic reasoning model with a 1M-token context and an OpenAI-compatible preview API, researched via Simon Willison's `llm-meta-ai` plugin. Relevant to the garden as candidate non-Claude backends for the fleet and as input to the model-selection map.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [overview](../sections/web--willison-muse-spark-1-1--overview.md) | Willison link post | Simon Willison's announcement of Muse Spark 1.1 and the `llm-meta-ai` plugin — the entry point connecting the Meta hosted model to a scriptable LLM-CLI harness. |
| [capabilities](../sections/web--meta-muse-spark-1-1-blog--capabilities.md) | Meta launch blog | Muse Spark 1.1's claimed agent-relevant capabilities: agentic tool use over new tools/MCP/skills, computer use, coding on large codebases, text/image/video/PDF, 1M-token context, parallel tool calling + structured output. |
| [access-and-api](../sections/web--meta-muse-spark-1-1-blog--access-and-api.md) | Meta launch blog | Access via the OpenAI-compatible Meta Model API (public preview, per-team gated); no published pricing; output-token rate limit charged before a request runs. |
| [safety-and-agentic-robustness](../sections/web--meta-muse-spark-1-1-eval-report--safety-and-agentic-robustness.md) | Muse Spark 1.1 Evaluation Report | Tool calling as attack surface; prompt-injection robustness improved over 1.0 but trailing SOTA on file injection; Meta recommend system-level tool allowlists + workspace isolation; coding/computer-use benchmarks trail the Claude Opus tier. |
| [attractor-states](../sections/web--meta-muse-spark-1-1-eval-report--attractor-states.md) | Muse Spark 1.1 Evaluation Report | The self-conversation "attractor state" behavioral profile, including an "anti-usefulness" strand — an out-of-distribution artifact worth flagging for long-running autonomous loops. |

## See also

- [llm-agent-frameworks](llm-agent-frameworks.md) — the harness/orchestration layer that would drive a hosted model like this (LangChain/LangGraph; Simon Willison's LLM CLI and its `llm-meta-ai` provider plugin).
- [local-model-serving](local-model-serving.md) — the single-machine self-hosted-backend sibling (athanor); this topic is its hosted-API counterpart.
- [coding-agent-economics](coding-agent-economics.md) — the token-cost lens the reasoning-token budget and per-team rate limits feed.
- [agent-conventions](agent-conventions.md) — agent-security threat classes the prompt-injection findings connect to.
