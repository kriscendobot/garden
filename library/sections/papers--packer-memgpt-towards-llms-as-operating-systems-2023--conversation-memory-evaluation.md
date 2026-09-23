---
title: "MemGPT: conversation-memory evaluation"
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

Abstract: On a derived Multi-Session Chat deep-memory retrieval task, the paper reports substantially higher answer accuracy and ROUGE-L for MemGPT-equipped models than corresponding fixed-context baselines that received lossy summaries. It separately reports that conversation openers could match or exceed the human reference on its similarity measures. These are experiment-specific results, not a general guarantee of durable conversational memory.

The DMR task asks a narrow question about the first five sessions. The baselines saw a recursive summary; MemGPT retained full history in recall storage but had to retrieve it with paginated search. Reported accuracy/ROUGE-L changes were GPT-3.5 Turbo 38.7/0.394 to 66.9/0.629, GPT-4 32.1/0.296 to 92.5/0.814, and GPT-4 Turbo 35.3/0.359 to 93.4/0.827. The engagement task evaluates a new-session opener against persona labels and a human opener; the authors attribute useful personalization in part to storing key facts in working context.

Source: [MemGPT paper](https://arxiv.org/pdf/2310.08560) at SHA-256 `9f674bcf`.
