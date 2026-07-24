---
source_kind: paper
source_authors: [Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, Joseph E. Gonzalez]
source_title: "MemGPT: Towards LLMs as Operating Systems"
source_year: 2023
source_venue: arXiv:2310.08560v2 [cs.AI]
source_url: https://arxiv.org/pdf/2310.08560
source_pdf_sha256: 9f674bcff69c86f11c813dcfad613d8841f5f8ed17979e3c4df06a91df7762e0
source_pdf_pages: 12
ingested: 2026-07-24
ingested_by: scholar
section_count: 5
status: current
---

MemGPT is a 2023 paper proposing an OS analogy for fixed-window LLMs: the prompt is managed main memory and external stores are secondary memory. The LLM receives memory-pressure events and tool schemas, then chooses writes, searches, paging, and function chains. The paper describes a prompt layout (instructions, editable working context, FIFO history with recursive summary), recall storage for complete conversation history, and archival storage for long documents. Its empirical claims are specific to its 2024 experiment configuration and baselines: reported deep-memory retrieval gains, stable document-QA behavior as available retrieved documents grow, and better nested key-value traversal than fixed-context baselines. This library's comparison to contemporary agent-memory systems is synthesis, not a claim made by the paper.

| Section | Topics | Status |
|---------|--------|--------|
| [virtual-context-and-memory-hierarchy](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--virtual-context-and-memory-hierarchy.md) | llm-agent-frameworks, persistence | current |
| [main-context-and-queue-management](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--main-context-and-queue-management.md) | llm-agent-frameworks, persistence | current |
| [self-directed-memory-tools-and-control-flow](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--self-directed-memory-tools-and-control-flow.md) | llm-agent-frameworks, patterns | current |
| [conversation-memory-evaluation](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--conversation-memory-evaluation.md) | llm-agent-frameworks, persistence | current |
| [document-retrieval-and-multihop-evaluation](../sections/papers--packer-memgpt-towards-llms-as-operating-systems-2023--document-retrieval-and-multihop-evaluation.md) | llm-agent-frameworks, persistence, patterns | current |

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
