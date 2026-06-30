---
title: "LangGraph: the low-level orchestration runtime and the product split"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langgraph/overview
source_content_sha256: ffbcb2f6c332278b477ec806b78053cad5fc1aa3057dbfbfa7174ad4f7824257
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks]
status: current
notes: "Living vendor docs (docs.langchain.com). Idempotency anchor is source_content_sha256 over the `.md` rendering."
---

Abstract: LangGraph is a low-level orchestration framework and runtime for building, managing, and deploying long-running, stateful agents. It is deliberately low-level and focused entirely on agent **orchestration**: it does not abstract prompts or architecture. Its central benefits are persistence (agents that survive failures and resume), human-in-the-loop (inspect and modify agent state at any point), comprehensive memory (short-term working memory plus long-term cross-session memory), debugging via LangSmith, and production deployment. It can be used standalone or with LangChain components for models and tools. Its graph algorithm is inspired by Google's Pregel and Apache Beam; its public interface draws on NetworkX.

## What LangGraph is for

LangGraph provides low-level supporting infrastructure for *any* long-running, stateful workflow or agent. It does not abstract prompts or architecture. The central benefits as listed:

- **Persistence**: build agents that persist through failures and can run for extended periods, resuming from where they left off.
- **Human-in-the-loop**: incorporate human oversight by inspecting and modifying agent state at any point.
- **Comprehensive memory**: stateful agents with both short-term working memory for ongoing reasoning and long-term memory across sessions.
- **Debugging with LangSmith**: visibility into complex agent behavior, tracing execution paths and capturing state transitions.
- **Production-ready deployment**: scalable infrastructure for stateful, long-running workflows.

A hello-world graph:

```python
from langgraph.graph import StateGraph, MessagesState, START, END

def mock_llm(state: MessagesState):
    return {"messages": [{"role": "ai", "content": "hello world"}]}

graph = StateGraph(MessagesState)
graph.add_node(mock_llm)
graph.add_edge(START, "mock_llm")
graph.add_edge("mock_llm", END)
graph = graph.compile()
graph.invoke({"messages": [{"role": "user", "content": "hi!"}]})
```

## How the products fit together

- **Deep Agents** is an agent harness (planning, subagents, filesystem tools, context management) on top of LangGraph.
- **LangChain** is the agent framework: abstractions and integrations for models, tools, and agent loops.
- **LangGraph** is the orchestration runtime: durable execution, streaming, human-in-the-loop, and persistence.
- **LangSmith** is the platform for tracing, evaluation, prompts, and deployment across frameworks.

LangGraph can be used without LangChain; if you want a higher-level abstraction, LangChain's `create_agent` provides prebuilt architectures for common LLM and tool-calling loops.

## Acknowledgements

LangGraph is inspired by [Pregel](https://research.google/pubs/pub37252/) and [Apache Beam](https://beam.apache.org/); its public interface draws inspiration from [NetworkX](https://networkx.org/). It is built by LangChain Inc.

Source: [LangGraph overview](https://docs.langchain.com/oss/python/langgraph/overview) retrieved 2026-06-30, content hash `ffbcb2f6`.
