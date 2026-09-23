---
id: attention-budget
aliases: ["attention budget", "attention scarcity", "finite attention", "n squared attention", "n^2 pairwise relationships", "transformer attention constraint", "context as finite resource", "position encoding interpolation"]
topics: [context-engineering]
---

# attention-budget

**Attention budget** is Anthropic's framing that an LLM, like a human with limited working memory, draws on a finite budget of attention when parsing context, and **every new token depletes that budget by some amount**. The scarcity is architectural: the transformer lets every token attend to every other token, producing **n² pairwise relationships for n tokens**, so as context length grows the model's capacity to capture those relationships is stretched thin — a natural tension between context size and attention focus. It is compounded by training-data distribution (shorter sequences are more common, so models have fewer specialized parameters for context-wide dependencies) and only partially relieved by techniques like position-encoding interpolation (which extends usable length but degrades token-position understanding). The attention budget is the architectural companion to the empirical [[context-rot]]; together they ground the core [[context-engineering]] principle: **find the smallest set of high-signal tokens that maximize the likelihood of the desired outcome**.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Why context engineering is important](../sections/web--anthropic-context-engineering--why-context-engineering-matters.md) | Introduces the attention budget and its n² transformer-attention root cause; the finite-resource argument for curating tokens. |
| [The anatomy of effective context](../sections/web--anthropic-context-engineering--anatomy-of-effective-context.md) | Applies the finite-budget premise: the smallest set of high-signal tokens across system prompts, tools, and examples. |

## See also

- [[context-rot]] — the empirical companion: recall degrades as tokens grow.
- [[context-engineering]] — the discipline the finite-budget premise motivates.
- [[context-pruning]] — the coding-agent-economics "fewer tokens" lever that spends the budget efficiently.
