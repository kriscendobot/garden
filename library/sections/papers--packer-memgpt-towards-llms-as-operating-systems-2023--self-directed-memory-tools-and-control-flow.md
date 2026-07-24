---
title: "MemGPT: self-directed memory tools and control flow"
source: "MemGPT: Towards LLMs as Operating Systems"
source_kind: paper
source_authors: [Charles Packer, Sarah Wooders, Kevin Lin, Vivian Fang, Shishir G. Patil, Ion Stoica, Joseph E. Gonzalez]
source_year: 2023
source_venue: arXiv:2310.08560v2 [cs.AI]
source_url: https://arxiv.org/pdf/2310.08560
source_pdf_sha256: 9f674bcff69c86f11c813dcfad613d8841f5f8ed17979e3c4df06a91df7762e0
ingested: 2026-07-24
ingested_by: scholar
topics: [llm-agent-frameworks, patterns]
status: current
---

Abstract: MemGPT gives the model explicit functions for memory editing and retrieval, parses completion tokens as calls, feeds results or errors back into context, and permits a call to request another inference immediately. This makes retrieval a model-controlled, multi-step loop rather than a fixed pre-prompt retrieval step.

The system prompt explains both tier roles and function schemas. A function executor validates generated arguments, performs the call, and returns its result or runtime error to the model; token-limit warnings and paginated retrieval are part of the feedback design. Events can be user messages, capacity warnings, login/upload events, or timers. Calls with `request_heartbeat=true` retain control for a next inference, enabling result-page traversal or collation from multiple searches. Calls without it yield until the next event.

Synthesis: the architecture separates policy from mechanism only partially. The queue manager enforces capacity and persistence mechanics, while the model selects what to preserve and retrieve. Therefore the reported behavior also depends on function-calling reliability and the prompt's tool-use instructions.

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
