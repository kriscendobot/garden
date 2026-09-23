---
title: "MemGPT: main context and queue management"
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

Abstract: MemGPT partitions its prompt into immutable system instructions, editable working context, and a FIFO message queue. A queue manager records messages in recall storage, warns the model before context exhaustion, then evicts old queue entries and replaces them with a recursive summary while retaining the originals for later search.

Working context is a fixed-size text block intended for salient user facts, preferences, persona, and objective information. The FIFO holds user, agent, system, and function-call messages; its first entry carries a recursive summary of material already evicted. On a configurable warning threshold (the paper gives 70 percent as an example), the queue manager emits a memory-pressure message so the model can save important details. At a flush threshold it evicts a selected block (50 percent is the example), updates the summary, and leaves the full messages in recall storage indefinitely.

The paper's architecture makes eviction lossier only for immediate prompt visibility, not for stored transcript availability. Retrieval still depends on the agent issuing a useful search and selecting results under the token budget.

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
