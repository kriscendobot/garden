---
id: multi-agent-handoff
aliases: [handoffs, agent handoff, agent handoffs, multi-agent, multi-agent system, supervisor, transfer_to, transfer_to_sales, active_agent, current_step, Command.PARENT, control transfer, subagent handoff, context engineering]
topics: [llm-agent-frameworks, patterns, agent-conventions]
---

# multi-agent-handoff

In LangChain, a **handoff** (term coined by OpenAI) is state-driven control transfer in a multi-agent or multi-step system: a tool updates a persistent state variable (`current_step` or `active_agent`) by returning a `Command`, and the system reads that variable to either reconfigure one agent (system prompt + tools) or route to a different agent. Two implementations: **single agent with middleware** (recommended) uses `@wrap_model_call` middleware to swap prompt/tools per `current_step` while message history flows naturally; **multiple agent subgraphs** make each agent a graph node and navigate between them with `Command(goto=..., graph=Command.PARENT)`. Subgraph handoffs require deliberate **context engineering**: every `Command.PARENT` handoff must pair the triggering `AIMessage` (the tool call) with an artificial `ToolMessage` response, and should pass only that pair — not the full subagent history — to avoid confusing the receiver and bloating tokens. This is distinct from the CapTP [[three-party-handoff]] (capability transfer across sessions); here "handoff" means transferring conversational control between LLM agents.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [state-driven control transfer](../sections/web--langchain-handoffs--state-driven-control-transfer.md) | The handoffs architecture, characteristics, when to use, and the basic Command-based transition. |
| [single-agent vs. subgraph approaches](../sections/web--langchain-handoffs--single-agent-vs-subgraph-approaches.md) | Middleware single-agent vs. Command.PARENT subgraphs; context engineering; considerations. |
| [configuring the harness via middleware](../sections/web--langchain-agents--configure-the-harness-via-middleware.md) | Planning and delegation: subagents in isolated contexts. |

## See also

- [[langchain]] — the agent framework; `create_agent` agents are the units that hand off.
- [[langgraph]] — supplies `Command`, `Command.PARENT`, and the subgraph node model handoffs use.
- [[human-in-the-loop]] — the other `Command`-resumed pattern, for human input rather than control transfer.
- [[three-party-handoff]] — the CapTP "handoff" (capability transfer), a different sense of the word.
- [[marketplace-of-mind]] — the 1988 intellectual ancestor of multi-agent LLM ecosystems.
