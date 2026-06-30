---
id: human-in-the-loop
aliases: [human-in-the-loop, HITL, interrupt, interrupts, interrupt(), Command(resume=...), resume, approve or reject, review and edit state, static interrupt, breakpoint, interrupt_before, interrupt_after, HumanInTheLoopMiddleware, steering]
topics: [llm-agent-frameworks, persistence, patterns]
---

# human-in-the-loop

In LangGraph, **human-in-the-loop** (HITL) is the ability to pause graph execution at a chosen point, surface a value to a human, wait indefinitely, and resume with the human's response. The mechanism is the `interrupt(payload)` function called inside a node: it suspends execution by raising a special exception, saves the graph state through the [[langgraph-checkpointer]] persistence layer keyed by `thread_id`, and surfaces the JSON-serializable payload to the caller (on `stream.interrupts` with event streaming, or `result["__interrupt__"]` with `invoke()`). You resume by re-invoking the graph with `Command(resume=value)`, which becomes the return value of the `interrupt()` call. Because the node **restarts from the beginning** on resume, four rules apply: do not wrap `interrupt` in a bare try/except, do not reorder/conditionally-skip interrupts within a node (resume matching is index-based), pass only JSON-serializable payloads, and keep pre-interrupt side effects idempotent. Common patterns: approve/reject, review-and-edit-state, interrupts-in-tools, and validating-input via a conditional-edge loop. In LangChain agents the same capability is packaged as `HumanInTheLoopMiddleware` ("steering"). Static interrupts (`interrupt_before`/`interrupt_after`) are debugging breakpoints, not for production HITL.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [pause and resume mechanics](../sections/web--langgraph-interrupts--interrupt-and-resume-mechanics.md) | interrupt(), checkpointer + thread_id, Command(resume=), node restart, subgraphs. |
| [human-in-the-loop patterns](../sections/web--langgraph-interrupts--human-in-the-loop-patterns.md) | HITL streaming, multiple interrupts, approve/reject, review/edit, interrupts in tools, validating input. |
| [rules and static breakpoints](../sections/web--langgraph-interrupts--rules-and-static-breakpoints.md) | The four rules; static interrupt_before/after for debugging. |
| [configuring the harness via middleware](../sections/web--langchain-agents--configure-the-harness-via-middleware.md) | "Steering" / HumanInTheLoopMiddleware as one harness support area. |
| [built-in middleware: tools, safety, and capabilities](../sections/web--langchain-middleware-built-in--tools-safety-and-capabilities.md) | `HumanInTheLoopMiddleware(interrupt_on={...})` approve/edit/reject of named tool calls; requires a checkpointer. |
| [streaming: reasoning, tool calls, HITL, sub-agents](../sections/web--langchain-streaming--common-patterns-reasoning-tool-calls-hitl-subagents.md) | Collecting `__interrupt__` from the updates stream and resuming with `Command(resume=...)` inside the streaming loop. |

## See also

- [[langgraph]] — the orchestration runtime interrupts run on.
- [[langgraph-checkpointer]] — the persistence layer that saves state at the pause and restores it on resume.
- [[middleware]] — `HumanInTheLoopMiddleware` packages this capability as one prebuilt middleware.
- [[agent-streaming]] — interrupts are surfaced and resumed inside the streaming loop.
- [[multi-agent-handoff]] — also resumes graphs with `Command`, but for control transfer rather than human input.
