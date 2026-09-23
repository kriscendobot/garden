---
title: "Memory stream and retrieval"
source: "Generative Agents: Interactive Simulacra of Human Behavior"
source_kind: presentation
source_authors: [Abhinav Chinta]
source_year: 2024
source_venue: "ConvAI Reading Group #2"
source_url: https://abhinavchinta.com/files/generative_agents_talk.pdf
source_pdf_sha256: ecbf72e67307a97af0cc2dc7e019a8b0138a7577787413f91af32d95de0b8a85
ingested: 2026-08-24
ingested_by: scholar
topics: [llm-agent-frameworks, context-engineering]
status: current
---

Abstract: The architecture records observations, plans, and reflections as timestamped natural-language memories, then ranks candidates for a situation by recency, model-scored importance, and embedding relevance. This weighted retrieval is the bridge between an unbounded experiential record and the small, situation-specific context presented to the model.

Recency decays over time, making a morning conversation easier to retrieve later that day than an old event. Importance is assigned on a 1–10 scale by a language model so significant social commitments can outrank routine events. Relevance is semantic similarity between the current query and memory embeddings, so an election question retrieves election material rather than unrelated routines.

The three signals serve different failure modes: recency preserves continuity, importance resists burying consequential events, and relevance selects memories that fit the immediate situation. Their combination is an explicit context-engineering policy rather than a claim that storage alone constitutes useful memory.

Source: [Chinta, *Generative Agents* talk](https://abhinavchinta.com/files/generative_agents_talk.pdf) at SHA-256 `ecbf72e6`.
