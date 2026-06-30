---
title: "LangChain short-term memory: thread persistence via the checkpointer"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/short-term-memory
source_content_sha256: a874692dcd9ad3be3705bb19a22e0a13a3ec816fb23ae61930a2cbf3aded5529
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Part of the LangChain/LangGraph remainder-ingest batch 2 (2026-06-30)."
---

Abstract: Short-term memory lets an agent remember previous interactions **within a single thread** (one conversation or session). Conversation history is its most common form. You enable it by passing a `checkpointer` to `create_agent`; LangChain then manages short-term memory as part of the agent's [LangGraph] State, persisting it to a database (or memory) so any thread can be resumed by its `thread_id`. State updates when the agent is invoked or a step (such as a tool call) completes, and is read at the start of each step. By storing history in graph state, the agent accesses the full context for a conversation while keeping different threads separated. A thread organizes multiple interactions in a session — analogous to how email groups messages into a conversation.

## Usage

To add short-term (thread-level) memory, specify a `checkpointer` when creating the agent and pass a `thread_id` in the config:

```python
from langchain.agents import create_agent
from langgraph.checkpoint.memory import InMemorySaver

agent = create_agent(model="gpt-5.5", tools=[get_user_info], checkpointer=InMemorySaver())

thread_config = {"configurable": {"thread_id": "1"}}
agent.invoke({"messages": [{"role": "user", "content": "Hi! My name is Bob."}]}, thread_config)
agent.invoke({"messages": [{"role": "user", "content": "What's my name?"}]}, thread_config)
# "You are Bob!"  — the second call recalls the first because both share thread_id "1"
```

### In production

Use a database-backed checkpointer instead of `InMemorySaver`. For example `PostgresSaver` (from `langgraph-checkpoint-postgres`):

```python
from langgraph.checkpoint.postgres import PostgresSaver

with PostgresSaver.from_conn_string(DB_URI) as checkpointer:
    checkpointer.setup()  # auto-create tables
    agent = create_agent("gpt-5.5", tools=[get_user_info], checkpointer=checkpointer)
```

Other backends (SQLite, Postgres, Azure Cosmos DB) are listed under the LangGraph persistence checkpointer libraries.

## Customizing agent memory

By default an agent uses `AgentState` to manage short-term memory — specifically the conversation history under a `messages` key. Extend `AgentState` to add fields, and pass the subclass as the `state_schema`:

```python
class CustomAgentState(AgentState):
    user_id: str
    preferences: dict

agent = create_agent("gpt-5.5", tools=[get_user_info],
                     state_schema=CustomAgentState, checkpointer=InMemorySaver())

result = agent.invoke(
    {"messages": [...], "user_id": "user_123", "preferences": {"theme": "dark"}},
    {"configurable": {"thread_id": "1"}},
)
```

This thread-scoped persistence is exactly the LangGraph checkpointer mechanism (see `langgraph-checkpointer`); the companion section covers managing the resulting context window and reading/writing state from tools and middleware.

Source: [LangChain short-term memory](https://docs.langchain.com/oss/python/langchain/short-term-memory) retrieved 2026-06-30, content hash `a874692d`.
