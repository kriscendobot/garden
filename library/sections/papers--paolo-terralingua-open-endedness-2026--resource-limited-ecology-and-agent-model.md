---
title: Resource-limited ecology and agent model
source: "TerraLingua: Emergence and Analysis of Open-endedness in LLM Ecologies"
source_kind: paper
source_authors: [Giuseppe Paolo, Jamieson Warner, Hormoz Shahrzad, Babak Hodjat, Risto Miikkulainen, Elliot Meyerson]
source_year: 2026
source_venue: "arXiv preprint arXiv:2603.16910 (cs.MA, cs.AI, physics.soc-ph)"
source_url: https://arxiv.org/abs/2603.16910
source_pdf_sha256: 7ce4c980b2666bfd088207f4fbabab4f8fd626a84cdc7ba48c1f246dd3d45e07
ingested: 2026-07-23
ingested_by: scholar
topics: [open-ended-agent-ecologies, llm-agent-frameworks]
status: current
---

Abstract: This derived digest, not the original paper, describes the engineered pressures that make TerraLingua an ecology instead of a consequence-free chat simulation: local perception on a toroidal grid, decaying food, finite energy and lifespan, state-dependent actions, reproduction with personality mutation, and short per-agent textual memory.

The world is a two-dimensional toroidal grid containing food, agents, and artifacts. Food may be spatially uniform or concentrated and decays probabilistically. An agent sees only a bounded local radius, receives a textual description of that local state, its energy and remaining lifetime, personality traits, inventory, recent messages, and its own prior short memory. It chooses one available action per timestep: movement, energy transfer or theft, reproduction, artifact operations, and an optional local broadcast. Preconditions make affordances local: transfer needs a nearby agent, while artifact operations need co-location or possession.

Mortality and energy bind choices to survival. Reproduction costs energy and creates an offspring that inherits a mutated personality vector. The tested agents use a fixed LLM decision engine rather than parameter learning, so the paper treats persistent environmental structures, not changing weights, as the main place for cultural accumulation. Personality uses OCEAN plus Honesty-Humility and dominance to introduce controlled behavioral heterogeneity.

Source: [TerraLingua: Emergence and Analysis of Open-endedness in LLM Ecologies](https://arxiv.org/abs/2603.16910), sections 3.1 and 4.1-4.2.
