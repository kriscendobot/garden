---
id: context-rot
aliases: ["context rot", "needle in a haystack", "recall degradation", "long-context recall", "context window degradation", "lost in the middle"]
topics: [context-engineering]
---

# context-rot

**Context rot** is the observed phenomenon that, as the number of tokens in an LLM's context window increases, the model's ability to accurately recall information from that context decreases. It was surfaced by needle-in-a-haystack style benchmarking and, per Anthropic, emerges across all models (some degrade more gently than others). It is the empirical half of the argument that context must be treated as a **finite resource with diminishing marginal returns** — the other half being the architectural [[attention-budget]] argument. Importantly, context rot produces a **performance gradient, not a hard cliff**: models remain highly capable at long contexts but show reduced precision for information retrieval and long-range reasoning. It is the motivating problem that all the [[context-engineering]] techniques ([[just-in-time-context]], [[context-compaction]], structured note-taking, sub-agent architectures) exist to work around.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Why context engineering is important](../sections/web--anthropic-context-engineering--why-context-engineering-matters.md) | Names context rot from needle-in-a-haystack benchmarking; pairs it with the attention budget and the n² transformer-attention root cause. |

## See also

- [[attention-budget]] — the architectural companion: a finite budget every token depletes, rooted in the transformer's n² attention.
- [[context-compaction]] — a technique to bound the window before rot degrades recall.
- [[just-in-time-context]] — loading data on demand rather than pre-filling the window keeps token count (and rot) down.
