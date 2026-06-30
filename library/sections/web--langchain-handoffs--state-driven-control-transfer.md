---
title: "LangChain handoffs: state-driven control transfer"
source_kind: web
source_url: https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs
source_content_sha256: e54b80f70a2b1deb30727009e450eaa41bcda7d16065786ca7fe3672370a5a4e
source_authors: [LangChain Inc.]
source_date: 2026-06-30
retrieved: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [llm-agent-frameworks, patterns, agent-conventions]
status: current
notes: "Living vendor docs (docs.langchain.com, Mintlify). Idempotency anchor is source_content_sha256 over the page's `.md` rendering, not a git SHA. Re-fetch the `.md` form to re-check freshness."
---

Abstract: In the **handoffs** architecture (a term coined by OpenAI for using tool calls like `transfer_to_sales_agent` to transfer control), an agent's behavior changes dynamically based on state. The core mechanism: a tool updates a state variable (e.g. `current_step` or `active_agent`) that persists across turns, and the system reads that variable to adjust behavior — either applying different configuration (system prompt, tools) within one agent or routing to a different agent. The defining characteristics are state-driven behavior, tool-based transitions, direct user interaction in each state, and persistent state surviving across conversation turns. Use handoffs to enforce sequential constraints (unlock capabilities only after preconditions are met), let the agent converse directly with the user across states, or build multi-stage conversational flows — the canonical example being customer support that collects information in a required sequence (a warranty ID before a refund). The basic implementation is a tool that returns a `Command(update={...})` setting the state variable; it must include a `ToolMessage` with the matching `tool_call_id` so the LLM's request/response cycle stays well-formed.

## The handoffs architecture

In the handoffs architecture, behavior changes dynamically based on state. The core mechanism: tools update a state variable (e.g. `current_step` or `active_agent`) that persists across turns, and the system reads this variable to adjust behavior — either applying different configuration (system prompt, tools) or routing to a different agent. The pattern supports both handoffs between distinct agents and dynamic configuration changes within a single agent. The term *handoffs* was coined by OpenAI for using tool calls (e.g. `transfer_to_sales_agent`) to transfer control between agents or states.

## Key characteristics

- **State-driven behavior** — behavior changes based on a state variable.
- **Tool-based transitions** — tools update the state variable to move between states.
- **Direct user interaction** — each state's configuration handles user messages directly.
- **Persistent state** — state survives across conversation turns.

## When to use

Use handoffs when you need to enforce sequential constraints (unlock capabilities only after preconditions are met), when the agent needs to converse directly with the user across different states, or when building multi-stage conversational flows. It is particularly valuable for customer support that collects information in a specific sequence — for example, collecting a warranty ID before processing a refund.

## Basic implementation

The core mechanism is a tool that returns a `Command` to update state, triggering a transition to a new step or agent:

```python
@tool
def transfer_to_specialist(runtime) -> Command:
    """Transfer to the specialist agent."""
    return Command(update={
        "messages": [ToolMessage(content="Transferred to specialist", tool_call_id=runtime.tool_call_id)],
        "current_step": "specialist"  # Triggers behavior change
    })
```

**Why include a `ToolMessage`?** When an LLM calls a tool it expects a response; the `ToolMessage` with matching `tool_call_id` completes the request/response cycle. Without it the conversation history becomes malformed. This is required whenever a handoff tool updates messages.

Source: [LangChain handoffs](https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs) retrieved 2026-06-30, content hash `e54b80f7`.
