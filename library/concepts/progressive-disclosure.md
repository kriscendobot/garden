---
id: progressive-disclosure
aliases: ["progressive disclosure", "incremental context discovery", "layer by layer understanding", "explore to discover context", "self-managed context window"]
topics: [context-engineering]
---

# progressive-disclosure

**Progressive disclosure** is the property that letting an agent navigate and retrieve data autonomously allows it to **incrementally discover relevant context through exploration**, rather than having all context surfaced up front. Each interaction yields context that informs the next decision: file sizes suggest complexity, naming conventions hint at purpose, timestamps proxy for relevance. The agent assembles understanding **layer by layer**, maintaining only what is necessary in working memory and leaning on note-taking for additional persistence — a self-managed context window that keeps it focused on relevant subsets rather than drowning in exhaustive but potentially irrelevant information. It is the payoff of [[just-in-time-context]] retrieval and a direct antidote to the [[attention-budget]] problem: context enters the window only as exploration proves it relevant.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Context retrieval and agentic search](../sections/web--anthropic-context-engineering--context-retrieval-and-agentic-search.md) | Introduces progressive disclosure as what autonomous navigation enables: incremental, layer-by-layer context discovery with a self-managed window. |

## See also

- [[just-in-time-context]] — the retrieval strategy progressive disclosure is the payoff of.
- [[attention-budget]] — the finite budget progressive disclosure spends only on proven-relevant context.
- [[context-engineering]] — the umbrella discipline.
