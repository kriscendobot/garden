---
title: "Middleware: what it controls and composing it inside a LangGraph workflow"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/middleware
source_content_sha256: e64b2d082c97d6e8b86de69192dd4c6220a0158ffcaac0095935b86c8721381c
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, agent-conventions, patterns]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering. The overview page is thin (~5.7 KB) and links onward; the depth lives in the built-in and custom child pages. Part of the LangChain/LangGraph remainder-ingest batch 3 (2026-06-30)."
---

Abstract: **Middleware** is LangChain's mechanism for tightly controlling what happens inside an agent. It is passed as a `middleware=[...]` list to `create_agent` and is useful for tracking behavior (logging, analytics, debugging), transforming prompts / tool selection / output formatting, and adding retries, fallbacks, early-termination, rate limits, guardrails, and PII detection. Crucially, **middleware is not a separate runtime**: its hooks run *inside* the compiled LangGraph that `create_agent` returns. The core agent loop is "call the model, let it choose tools, finish when it calls no more tools," and middleware exposes hooks before and after each of those steps. Because the whole agent is a compiled graph, you can drop it (middleware and all) into a larger `StateGraph` as a node or subgraph — every middleware hook keeps running — which is the right pattern when the surrounding topology is more than "loop until done": classify input before routing to one of several agents, fan out work in parallel, or stitch agent calls together with deterministic steps. `HumanInTheLoopMiddleware` matches against each tool's `.name` (in Python a `@tool` function takes its name from the function; in TypeScript the `name` passed to `tool({...}, { name })`).

## Adding middleware

```python
from langchain.agents import create_agent
from langchain.agents.middleware import SummarizationMiddleware, HumanInTheLoopMiddleware

agent = create_agent(
    model="gpt-5.5",
    tools=[...],
    middleware=[SummarizationMiddleware(...), HumanInTheLoopMiddleware(...)],
)
```

## The agent loop

The core loop calls a model, lets it choose tools to execute, and finishes when no more tools are called. Middleware exposes hooks before and after each step (see the custom-middleware section for the full hook set and execution order).

## Use middleware inside a LangGraph workflow

Hooks run inside the compiled LangGraph `create_agent` returns, so the whole agent can be a node in a larger `StateGraph`:

```python
email_agent = create_agent(
    model="claude-sonnet-4-6",
    tools=[read_email, send_email],
    middleware=[HumanInTheLoopMiddleware(interrupt_on={"send_email": True})],
)

graph = (
    StateGraph(AgentState)
    .add_node("classify", classify_node)
    .add_node("email_agent", email_agent)
    .add_edge(START, "classify")
    .add_conditional_edges("classify", route)
    .compile()
)
```

The HITL interrupt, summarization, PII redaction, retries, and any custom hooks all travel with the agent node. The two child pages carry the depth: **built-in middleware** (the prebuilt catalog) and **custom middleware** (hooks, decorators, and classes).

Source: [LangChain middleware overview](https://docs.langchain.com/oss/python/langchain/middleware) retrieved 2026-06-30, content hash `e64b2d08`.
