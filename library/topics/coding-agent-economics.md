# Topic: coding-agent-economics

## Abstract

The cost and economics of running LLM coding agents at scale: how spend accrues, where it explodes, and how to manage it without losing velocity. The organizing identity is that **coding cost is the multiplicand of token cost and token count**, giving two levers: cheaper tokens (right-sizing the model to the task, and the open problem of routing tasks by difficulty) and fewer tokens (agent-ready codebases, shifting verification left, active context pruning, context engines, and not doing needless work). A recurring theme is that **cloud coding** is where spend runs away, for the same reasons cloud compute does: it makes lots of work easy to launch at once, costs more per unit than a laptop, and lets wasteful work go unnoticed. This topic is distinct from `agent-payments` (machine-initiated payment over open rails, x402) and from `local-model-serving` (running inference runtimes on your own hardware); it is about the *spend-management discipline* for coding agents, not the payment rails or the serving layer. It cross-references the garden's own fleet-spend machinery (the deterministic weekly token meter and quota back-off in `scripts/jobs/usage-meter.sh`) where the measure-then-throttle discipline genuinely lines up.

## Sections

| Section | Topics | One-line |
|---------|--------|----------|
| [overview](../sections/web--allen-pike-coding-agent-spend--overview.md) | coding-agent-economics | The $10k/week discovery: a year of hill-climbing the coding loop until the overage emails reveal the spend. |
| [This is too much](../sections/web--allen-pike-coding-agent-spend--this-is-too-much.md) | coding-agent-economics | The industry shift from "use more agents" to "get the most out of the spend," visible across Altman, Armstrong, and Uber. |
| [Cloud coding costs](../sections/web--allen-pike-coding-agent-spend--cloud-coding-costs.md) | coding-agent-economics | Cloud coding gets expensive for the same reasons cloud compute does; "very cheaply" only holds if your tokens are free. |
| [Cheaper tokens](../sections/web--allen-pike-coding-agent-spend--cheaper-tokens.md) | coding-agent-economics | Right-size the model to the task; the mid-2026 price spread and the hard problem of routing tasks by difficulty. |
| [Fewer tokens](../sections/web--allen-pike-coding-agent-spend--fewer-tokens.md) | coding-agent-economics | Agent-ready codebases, shift verification left, prune context, watch cloud-harness behavior, do not do needless work. |
| [The high cost of free coding](../sections/web--allen-pike-coding-agent-spend--high-cost-of-free-coding.md) | coding-agent-economics | Bigger messes are the price of building better software; the prize is on the other side. |
| [unum: token/compute cost ledger](../sections/unum--token-cost-ledger.md) | coding-agent-economics | unum's per-run attributed cost ledger (costs.jsonl): capture from the Claude CLI result event; raw tokens + CLI-computed dollars. |
| [unum: cost attribution and aggregation](../sections/unum--cost-attribution-and-aggregation.md) | coding-agent-economics | Grouping the ledger by task/day/model; the three surfaces (invoke cost table, per-task TADA cost stanza, live operator chip). |
| [unum: per-persona model tiers](../sections/unum--per-persona-model-tiers.md) | coding-agent-economics | Right-sizing the model per persona in durable config (liaison/foreman sonnet, steward opus, invoker fable); a coarse instance of model-routing. |

## See also

- [agent-payments](agent-payments.md) — machine-initiated payment over open rails; the rails agents pay *over*, distinct from the cost of running the agents.
- [local-model-serving](local-model-serving.md) — running inference runtimes on your own hardware; the "cheaper tokens" lever taken all the way to self-hosting.
- [llm-agent-frameworks](llm-agent-frameworks.md) — the consumer layer (LangChain/LangGraph) whose token spend this topic is about managing.
