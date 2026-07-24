---
title: "MemGPT: document retrieval and multihop evaluation"
source: "MemGPT: Towards LLMs as Operating Systems"
source_kind: paper
source_authors: [Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, Joseph E. Gonzalez]
source_year: 2023
source_venue: arXiv:2310.08560v2 [cs.AI]
source_url: https://arxiv.org/pdf/2310.08560
source_pdf_sha256: 9f674bcff69c86f11c813dcfad613d8841f5f8ed17979e3c4df06a91df7762e0
ingested: 2026-07-24
ingested_by: scholar
topics: [llm-agent-frameworks, persistence, patterns]
status: current
---

Abstract: For document QA, MemGPT puts an embedding-indexed corpus in archival storage and lets the model search and paginate it; for nested key-value retrieval, it repeatedly follows retrieved values that are themselves keys. The paper reports that its agent can use more retrieved documents than a fixed prompt can hold and is the only tested approach that remains consistently successful past two nesting levels, while also documenting premature stopping and model-dependent tool-use failures.

The document-QA setup uses the same cosine-similarity retriever for all methods. The paper used PostgreSQL with pgvector and an HNSW index, then contrasts a fixed retriever-reader prompt with agent-driven repeated archival searches. It notes two limitations: poor embedding ranking can hide a gold document, and MemGPT often stops paging before exhausting results. For nested UUID key-value chains, fixed GPT-4 and GPT-4 Turbo reached zero accuracy by three nesting levels in the reported setup; MemGPT with GPT-4 was described as unaffected by level, while the GPT-3.5 and GPT-4 Turbo variants still declined after two levels because they did not make enough calls.

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
