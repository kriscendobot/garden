---
title: "LangChain agents: invocation, runtime context, and streaming"
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
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: An agent is invoked with a message, which behind the scenes applies an update to the agent's LangGraph **State** — every agent carries a sequence of messages (a `MessagesState`) in its state. Passing a `thread_id` in `config={"configurable": {"thread_id": ...}}` lets the agent persist and resume conversation history through a checkpointer (the same persistence mechanism LangGraph uses). Per-run data that is *not* conversational — user IDs, API keys, feature flags — is passed as `context` alongside `config`, its shape declared by `context_schema` and read inside tools and middleware through `runtime.context`. Token-by-token and step-by-step output is consumed by streaming.

## Invocation and thread-scoped state

You invoke an agent with a message; behind the scenes that passes an update to the agent's LangGraph State. All agents include a sequence of messages in their state (a `MessagesState`). To invoke the agent, pass a new message along with a `thread_id` so the agent can persist and resume conversation history:

```python
from langchain.agents import create_agent
from langchain_core.utils.uuid import uuid7
from langgraph.checkpoint.memory import InMemorySaver

agent = create_agent(model="...", tools=[], checkpointer=InMemorySaver())
config = {"configurable": {"thread_id": str(uuid7())}}
result = agent.invoke(
    {"messages": [{"role": "user", "content": "What's the weather in San Francisco?"}]},
    config=config,
)
```

Reusing the same `thread_id` resumes the same conversation; a new value starts a fresh one. This is the agent-level surface of LangGraph's checkpointer-and-threads persistence model.

## Runtime context vs. config

If you also need to pass per-run configuration (a user ID, API keys, feature flags) to tools and middleware, pass it as `context` alongside `config`. Define the shape of that data with `context_schema` and access it through `runtime.context`. Context is immutable per-run configuration, distinct from the mutable, thread-scoped State that flows through the message history.

## Streaming

The agent can stream its output rather than returning a single final result, surfacing model message chunks as they are produced and per-step state snapshots as the loop advances. (LangGraph's event streaming is the underlying mechanism; see the *interrupts* sections for how streaming surfaces human-in-the-loop pauses via `stream.interrupted` / `stream.interrupts`.)

Source: [LangChain agents](https://docs.langchain.com/oss/python/langchain/agents) retrieved 2026-06-30, content hash `b5c5c292`.
