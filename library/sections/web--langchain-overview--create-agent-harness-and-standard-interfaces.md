---
title: "LangChain: create_agent harness and standard model interface"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/overview
source_content_sha256: c477dc31488cfda7077e42e8150ce3063df0c1b85da712e3a2d8d8ba6bc410bf
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA; the canonical source_date is an era approximation. Re-fetch the `.md` form to re-check freshness."
---

Abstract: LangChain frames an agent as **model plus harness**. Its central API, `create_agent(model, tools, system_prompt, ...)`, is a minimal, highly configurable harness: everything around the model loop (the prompt, the tools, and any middleware that shapes behavior). The framework's value proposition is a **standard interface** across providers (chat models, embeddings) so an application can switch models with minimal code changes, plus a composable middleware layer for incremental capabilities (guardrails, retries, routing, tool policies). LangChain's agents are built on top of LangGraph, inheriting its durable execution, human-in-the-loop, and persistence.

## Agent = Model + Harness

LangChain provides `create_agent`: a minimal, highly configurable harness. The harness is everything around the model loop: the prompt, the tools, and any middleware that shapes behavior. The recommendation is to start with the primitives and compose exactly what a use case needs. A minimal agent:

```python
from langchain.agents import create_agent

def get_weather(city: str) -> str:
    """Get weather for a given city."""
    return f"It's always sunny in {city}!"

agent = create_agent(
    model="claude-sonnet-4-6",
    tools=[get_weather],
    system_prompt="You are a helpful assistant",
)
result = agent.invoke(
    {"messages": [{"role": "user", "content": "What's the weather in San Francisco?"}]}
)
```

The same call works across providers (OpenAI, Anthropic, Google Gemini, AWS Bedrock, Azure, Ollama, HuggingFace, and more) by changing only the `model` string and the provider extra installed.

## Where it sits in the product family

- **Deep Agents** is a "batteries-included" agent harness (automatic context compression, a virtual filesystem, subagent-spawning) built on LangChain agents.
- **LangChain** (`create_agent`) is the customizable harness, tailored to a use case and its data.
- **LangGraph** is the low-level orchestration framework for advanced needs combining deterministic and agentic workflows.
- **LangSmith** traces, debugs, and evaluates agents built with any of these frameworks.

## Core benefits as stated

- **Standard model interface.** One interface for chat models, embeddings, and more across providers; switch models with minimal code changes and keep the application portable.
- **Highly configurable harness.** Start with `create_agent` as a minimal harness and add capabilities incrementally through middleware: compose only what the use case needs, from guardrails and retries to routing and custom tool policies.
- **Built on LangGraph.** Agents inherit LangGraph's durable execution, human-in-the-loop support, and persistence.
- **Debug with LangSmith.** Inspect traces, tool calls, state transitions, and latency in one place.

Source: [LangChain overview](https://docs.langchain.com/oss/python/langchain/overview) retrieved 2026-06-30, content hash `c477dc31`.
