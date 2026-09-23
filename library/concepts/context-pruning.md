---
id: context-pruning
aliases: ["context pruning", "fewer tokens", "prune context", "context engine", "agent-ready codebase", "shift verification left", "context window spend", "/context", "context reduction", "minimum tokens per unit shipped"]
topics: [coding-agent-economics, context-engineering]
---

# context-pruning

**Context pruning** is the "fewer tokens" lever on [[coding-agent-spend]]: use the minimum number of tokens per unit of product improvement shipped, by sending less context each turn and taking fewer turns to success. It is the second factor in `spend = token_cost × token_count`, complementary to [[model-routing]] on the first. From Allen Pike's essay, the concrete tactics are:

- **Agent-ready codebase.** Make the repo navigable so agents explore and trial-and-error less to understand the product and verify PRs. Easiest greenfield, but achievable in any codebase.
- **Shift verification left.** It is far cheaper for an agent to run and fix lints early than to push to CI, tail CI logs, and receive the error much later. (The garden's `local-verify` and `pre-push-gates` skills lean this way.)
- **Actively prune the window.** Claude Code's `/context` shows what a session is spending context on; post-hoc review with a tool like AgentsView shows what burned the tokens. A worked example from the essay: agents running unit tests with `--verbose` and processing the output, when all they needed in context was "success."
- **Context engines.** Tools like Unblocked's deduplicate and reduce the context sent to the agent, collapsing the gather-and-prune work every session otherwise repeats, for a more deterministic and cheaper loop.
- **Watch cloud-harness behavior.** A cloud harness with a different system prompt can push intermediate work to GitHub far more eagerly than a human would (the essay saw roughly 10x the intermediate PR pushes), multiplying CI runs and LLM-guardrail checks until tamped down.
- **Do not do needless work.** Let agents idle while you think and talk to customers rather than forging at high velocity in the wrong direction.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Fewer tokens](../sections/web--allen-pike-coding-agent-spend--fewer-tokens.md) | Agent-ready codebase, shift verification left, prune the window, context engines, watch cloud-harness behavior. |
| [Compaction](../sections/web--anthropic-context-engineering--compaction.md) | Anthropic's window-summarization technique and tool-result clearing — a concrete "prune the window" mechanism from the context-engineering side. |
| [The anatomy of effective context](../sections/web--anthropic-context-engineering--anatomy-of-effective-context.md) | The smallest set of high-signal tokens across system prompts, tools, and examples — the curation half of "fewer tokens." |

## See also

- [[coding-agent-spend]] — the cost `token_cost × token_count`; context-pruning is the second factor.
- [[model-routing]] — the complementary "cheaper tokens" lever on the first factor.
- [[context-compaction]] — the context-engineering technique for pruning a near-full window; the cost-side and discipline-side views of the same move.
- [[context-engineering]] — the token-curation discipline of which pruning is the economics-facing view.
