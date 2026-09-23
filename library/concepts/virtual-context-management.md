---
id: virtual-context-management
aliases: [virtual context, virtual memory for LLMs, context paging, memory tiers, memory pressure]
topics: [llm-agent-frameworks, persistence]
---

# virtual-context-management

Virtual context management is MemGPT's analogy from virtual memory to finite-window LLMs: retain a bounded prompt as main context while allowing the model to page relevant information in from external stores and move selected information out. Its mechanism combines a queue manager's deterministic capacity controls with model-selected writes and retrieval. It is not equivalent to simply increasing a model's context limit, nor does it prove that retrieval will find or select the needed information.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [virtual context and memory hierarchy](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--virtual-context-and-memory-hierarchy.md) | Defines the virtual-context analogy and tier boundary. |
| [main context and queue management](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--main-context-and-queue-management.md) | Capacity warning, eviction, summary, and recall preservation. |
| [self-directed memory tools and control flow](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--self-directed-memory-tools-and-control-flow.md) | Model-directed movement and bounded pagination. |

## See also

- [[memgpt]] — the paper and architecture that names the approach.
- [[langgraph-store]] — cross-thread key-value memory with optional semantic search.
