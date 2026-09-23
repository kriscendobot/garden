---
id: memgpt
aliases: [MemGPT, MemoryGPT, Letta, LLM operating system]
topics: [llm-agent-frameworks, persistence]
---

# memgpt

MemGPT is Packer et al.'s OS-inspired fixed-context LLM architecture. It treats prompt tokens as main memory, uses working context plus FIFO history for what is immediately visible, and delegates persistent recall and archival storage to external stores that the model accesses through functions. The system's distinctive claim is not merely retrieval augmentation but model-directed paging, memory edits, and chained tool calls under explicit capacity warnings. The paper was later associated with the Letta project; this page indexes the 2023 paper only.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [virtual context and memory hierarchy](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--virtual-context-and-memory-hierarchy.md) | Fixed prompt plus external stores as an OS-like hierarchy. |
| [main context and queue management](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--main-context-and-queue-management.md) | Prompt layout and recall-backed eviction policy. |
| [self-directed memory tools and control flow](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--self-directed-memory-tools-and-control-flow.md) | Memory functions and chained calls. |
| [conversation-memory evaluation](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--conversation-memory-evaluation.md) | Reported conversation-memory findings. |
| [document retrieval and multihop evaluation](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--document-retrieval-and-multihop-evaluation.md) | Reported archival-search and nested-retrieval findings. |

## See also

- [[langgraph-store]] — a different long-term-memory abstraction with explicit namespace/key storage.
- [[langgraph-checkpointer]] — thread-scoped persisted execution state rather than prompt-visible memory tiers.
