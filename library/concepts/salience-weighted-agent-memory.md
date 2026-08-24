---
id: salience-weighted-agent-memory
aliases: [recency importance relevance, memory stream retrieval, generative-agent memory, salience-weighted retrieval]
topics: [llm-agent-frameworks, context-engineering]
---

# salience-weighted-agent-memory

Salience-weighted agent memory is the Generative Agents policy for selecting a small working set from a growing natural-language memory stream. Each candidate's retrieval score combines recency (time decay), importance (a model-assigned significance score), and relevance (embedding similarity to the current query). Reflection uses the same retrieval path to ground higher-level inferences, and stores those inferences back into the stream. This is a context-selection policy, not a durability mechanism: persistence determines what survives; the weighting determines what becomes visible to the next inference.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [memory stream and retrieval](../sections/talks--chinta-generative-agents-2024--memory-stream-and-retrieval.md) | Defines the recency/importance/relevance retrieval score and the role of each signal. |
| [reflection and memory integration](../sections/talks--chinta-generative-agents-2024--reflection-and-memory-integration.md) | Shows reflection reusing retrieval and returning evidence-linked abstractions to memory. |

## See also

- [[memgpt]] — a complementary architecture in which the model actively pages between prompt-visible and external memory tiers.
- [[just-in-time-context]] — the broader context-engineering practice of retrieving high-signal material only when it is needed.
- [[context-compaction]] — summary-based context reduction rather than record-level weighted retrieval.
