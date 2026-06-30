---
title: "LangChain agents: the agent loop and core components"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/agents
source_content_sha256: b5c5c292e41a272c72e0e5bbad2536433ccc6fe78c733c6cd7d4c2c3951423fc
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA; the canonical source_date is an era approximation. Re-fetch the `.md` form to re-check freshness."
---

Abstract: LangChain defines an **agent** as "a model calling tools in a loop until a given task is complete," framed as **model + harness** — the harness being everything around that loop (the model, its prompt, its tools, and any middleware that shapes behavior), whose job is to "get the model the right context at the right time for the given task." `create_agent(model, tools, system_prompt, response_format, ...)` is the highly configurable harness factory. Its four core components are the **model** (a `"provider:model"` string or model instance), **tools** (any Python callable, LangChain tool, or tool dict), the **system prompt** (a string or `SystemMessage`), and **structured output** (a `response_format=` schema that returns a validated `structured_response`).

## The agent loop

An agent is a model calling tools in a loop until a given task is complete. A harness is everything around that loop: the model, its prompt, its tools, and any middleware that shapes its behavior. The job of a harness is to get the model the right context at the right time for the given task.

`create_agent` is the harness factory. At its simplest:

```python
from langchain.agents import create_agent

agent = create_agent(model="anthropic:claude-sonnet-4-6", tools=tools)
```

You configure the basics directly with the `model=`, `tools=`, and `system_prompt=` parameters; for more advanced capabilities you extend the harness with middleware (see *configure the harness via middleware*).

## Core components

- **Model.** Pass a model identifier string (`"provider:model"`) or an initialized model instance to select the model. The same call works across providers (Google, OpenAI, Anthropic, OpenRouter, Fireworks, Baseten, Ollama, and more) by changing only the `model` string and installing the provider extra. See the *models* sections for parameters, provider setup, and dynamic selection.
- **Tools.** Provide tools by passing any Python callable, LangChain tool, or tool dict to `tools=`. See the *tools* sections for definition, context access, and dynamic selection.

  ```python
  from langchain.tools import tool

  @tool
  def search(query: str) -> str:
      """Search for information."""
      return f"Results for: {query}"

  agent = create_agent(model="anthropic:claude-sonnet-4-6", tools=[search])
  ```

- **System prompt.** Shapes how the agent approaches tasks. The `system_prompt` parameter accepts a string or `SystemMessage`. For dynamic prompts at runtime, use middleware.
- **Structured output.** Return a validated schema from the agent with `response_format=`. The validated value is available on `result["structured_response"]`.

  ```python
  from pydantic import BaseModel
  from langchain.agents import create_agent

  class Answer(BaseModel):
      summary: str
      confidence: float

  agent = create_agent(model="anthropic:claude-sonnet-4-6", tools=tools, response_format=Answer)
  result = agent.invoke({"messages": [{"role": "user", "content": "Summarize AI trends"}]})
  result["structured_response"]  # Answer(summary=..., confidence=...)
  ```

Source: [LangChain agents](https://docs.langchain.com/oss/python/langchain/agents) retrieved 2026-06-30, content hash `b5c5c292`.
