---
title: "LangChain handoffs: single-agent vs. subgraph approaches"
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

Abstract: There are two ways to implement handoffs, and the docs recommend the simpler one for most cases. **Single agent with middleware** (recommended default): one agent changes behavior based on state — `@wrap_model_call` middleware intercepts each model call and dynamically sets the system prompt and available tools from a `current_step` map, while tools update `current_step` via `Command` to trigger transitions; message history flows naturally. **Multiple agent subgraphs**: distinct agents exist as separate graph nodes, and handoff tools navigate between them using `Command(goto=..., graph=Command.PARENT)`; reserved for bespoke agents (a node that is itself a complex graph with reflection or retrieval). The subgraph approach demands careful **context engineering**: because you control exactly what messages flow between agents, you must pair the triggering `AIMessage` (the tool call) with an artificial `ToolMessage` response on every `Command.PARENT` handoff — passing only that pair rather than the full subagent history avoids confusing the receiving agent and bloating tokens — and ensure the final message returned to the user is an `AIMessage`. Design considerations: context filtering strategy, tool semantics (routing-only vs. side effects), and token efficiency.

## Two implementation approaches

### Single agent with middleware

A single agent changes its behavior based on state. Middleware intercepts each model call and dynamically adjusts the system prompt and available tools; tools update the state variable to trigger transitions. A `@wrap_model_call` middleware reads `current_step` from state, looks up a per-step config (prompt + tools), and calls `request.override(system_prompt=..., tools=...)`. Tools return `Command(update={..., "current_step": "..."})` to advance. This is recommended for most handoffs use cases — it is simpler, and message history flows naturally.

### Multiple agent subgraphs

Multiple distinct agents exist as separate nodes in a graph. Handoff tools navigate between agent nodes using `Command.PARENT` to specify which node to execute next:

```python
@tool
def transfer_to_sales(runtime: ToolRuntime) -> Command:
    """Transfer to the sales agent."""
    last_ai_message = next(m for m in reversed(runtime.state["messages"]) if isinstance(m, AIMessage))
    transfer_message = ToolMessage(content="Transferred to sales agent", tool_call_id=runtime.tool_call_id)
    return Command(goto="sales_agent", update={"active_agent": "sales_agent",
        "messages": [last_ai_message, transfer_message]}, graph=Command.PARENT)
```

Use multiple agent subgraphs only when you need bespoke agent implementations (e.g. a node that is itself a complex graph with reflection or retrieval steps).

## Context engineering for subgraph handoffs

With subgraph handoffs you control exactly what messages flow between agents — this precision is essential for valid conversation history and avoiding context bloat. LLMs expect tool calls to be paired with their responses, so when using `Command.PARENT` to hand off you must include both (1) the `AIMessage` containing the tool call (the message that triggered the handoff) and (2) a `ToolMessage` acknowledging the handoff (the artificial response to that tool call). Without this pairing the receiving agent sees an incomplete conversation and may error.

**Why not pass all subagent messages?** Including the full subagent conversation often confuses the receiving agent with irrelevant internal reasoning and increases token cost. Pass only the handoff pair to keep the parent graph's context focused on high-level coordination; if the receiving agent needs more, summarize the subagent's work in the `ToolMessage` content rather than passing raw history. When returning control to the user, ensure the final message is an `AIMessage` to keep history valid and signal the UI that the agent finished.

## Implementation considerations

- **Context filtering strategy** — will each agent receive full history, filtered portions, or summaries? Different roles may need different context.
- **Tool semantics** — clarify whether handoff tools only update routing state or also perform side effects (e.g. should `transfer_to_sales()` also create a ticket, or is that separate?).
- **Token efficiency** — balance context completeness against token cost; summarization and selective context passing matter more as conversations grow.

Source: [LangChain handoffs](https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs) retrieved 2026-06-30, content hash `e54b80f7`.
