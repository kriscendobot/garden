---
title: "Hierarchical planning and reaction"
source: "Generative Agents: Interactive Simulacra of Human Behavior"
source_kind: presentation
source_authors: [Abhinav Chinta]
source_year: 2024
source_venue: "ConvAI Reading Group #2"
source_url: https://abhinavchinta.com/files/generative_agents_talk.pdf
source_pdf_sha256: ecbf72e67307a97af0cc2dc7e019a8b0138a7577787413f91af32d95de0b8a85
ingested: 2026-08-24
ingested_by: scholar
topics: [llm-agent-frameworks]
status: current
---

Abstract: Agents maintain temporal coherence by recursively decomposing a broad daily plan into hourly and then 5–15-minute actions, while an observation-and-reaction loop can revise the remaining plan when an event warrants attention. Planning prevents locally plausible actions from composing into an implausible day; reaction keeps the plan from becoming rigid.

At each time step, the agent perceives the environment and adds observations to memory. A model decides whether a new observation merits reaction or whether the existing plan should continue. If reaction is warranted, the prompt combines the agent's summary, retrieved memories, and the observation to select a response.

After a reaction, the architecture regenerates the plan from that point forward. This separates stable intent from adaptive execution: earlier actions remain historical memory, the high-level routine supplies continuity, and the future schedule changes in response to new social or environmental information.

Source: [Chinta, *Generative Agents* talk](https://abhinavchinta.com/files/generative_agents_talk.pdf) at SHA-256 `ecbf72e6`.
