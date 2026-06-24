---
title: Implications for Endo
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "156-176 (§6 Agoric systems in the large; §6.1 software distribution markets; §6.2 marketplace of mind; §7 The absence of agoric systems; §8 Conclusions; Appendix I summary)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, agent-conventions, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems
---

This section closes the historical arc the four-paper Miller cluster + this 1988 paper develop. The library now has the entire conceptual lineage:

1. **1988 (this paper)**: the agoric vision; encapsulation as property rights; capability security as the three-mechanism rule; charge-per-use markets; marketplace of mind.
2. **2000 (Capability-Based Financial Instruments)**: the worked-out form of agoric currency via mint+purse+sealed-decr; Pluribus distributed protocol; smart contracts.
3. **2003 (Capability Myths Demolished)**: the four-models taxonomy + seven security properties.
4. **2003 (Paradigm Regained)**: abstraction-as-protection; the cp-vs-cat designation argument; Caretaker pattern.
5. **2004 (Structure of Authority)**: security as extreme modularity; four-ways-to-acquire-references; nested-POLA multiplicative attack-surface reduction.
6. **2005 (Concurrency Among Strangers)**: vat-and-event-loop model; promise pipelining; partial-failure + when-catch.

The §7 *absence of agoric systems* argument is now partially refutable: contemporary cloud infrastructure exhibits some agoric properties; Agoric the company exists; capability-discipline languages (SES, E, Goblins) exist. **But the full agoric vision — per-object resource pricing, distributed business agents, the marketplace of mind — remains research territory.** The library's role is to anchor the lineage so future Endo / Agoric work can build on the foundations the cluster establishes.

The §6.2 *marketplace of mind* and §7's anticipation of AI-coded systems are unexpectedly contemporary: the garden's own design — autonomous bots running under capability discipline, with reputation tracked via journal history, building on each other's work via formula-graph composition — is structurally what this 1988 paper anticipates. The garden is a partial enactment of the agoric vision at the workflow layer; production Agoric is the partial enactment at the value-transfer layer.
