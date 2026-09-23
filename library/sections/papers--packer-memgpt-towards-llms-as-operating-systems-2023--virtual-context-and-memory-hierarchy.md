---
title: "MemGPT: virtual context and memory hierarchy"
source: "MemGPT: Towards LLMs as Operating Systems"
source_kind: paper
source_authors: [Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, Joseph E. Gonzalez]
source_year: 2023
source_venue: arXiv:2310.08560v2 [cs.AI]
source_url: https://arxiv.org/pdf/2310.08560
source_pdf_sha256: 9f674bcff69c86f11c813dcfad613d8841f5f8ed17979e3c4df06a91df7762e0
ingested: 2026-07-24
ingested_by: scholar
topics: [llm-agent-frameworks, persistence]
status: current
---

Abstract: The paper frames a finite LLM context window as main memory and external data as secondary memory, then calls the managed illusion of more usable context "virtual context." Unlike a larger-context model, this design relies on explicit movement between tiers: the model can retrieve missing history into prompt tokens and evict less relevant material out. The authors present this as an OS-inspired architecture, not as evidence that all agent-memory systems should use the same tiers.

MemGPT divides information into main context (prompt tokens available to inference) and external context (data outside the fixed window that must be moved in explicitly). Its external context includes recall storage, a message database, and archival storage for arbitrary-length text. The stated motivation is that attention cost grows steeply with context and that merely extending a window need not improve use of the middle of that window.

Synthesis: this is a useful contrast with a checkpointer/store split. MemGPT's tiers classify what is currently visible to one inference and what can be retrieved, whereas a checkpointer/store split primarily classifies lifecycle scope and durability.

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
