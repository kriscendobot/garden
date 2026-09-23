---
title: Common confusions
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "149-156 (§5 Agents and strategies — §5.1 initial market strategies; §5.2 business location decisions; §5.3 business agents including data-type agents, managers, reputations, compilation; §5.4 the scandal of idle time)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies
---

- **"Business agents are just smart contracts."** No — smart contracts (per the 2000 paper's terminology) are *application-level* compositions of capability-based money + access; business agents are *performance-layer* delegates that choose implementations, prices, and tradeoffs. The two layers are orthogonal; an Agoric Zoe contract may use business agents to choose its data-structure implementations.
- **"Reputation systems need anonymity."** §5.3.3's positive-reputation discipline does *not* require anonymity — it requires *unforgeable identity*. The substrate is capability + per-agent-keypair (the 1988 framing). Negative-reputation systems fail under anonymity; positive-reputation systems do not.
- **"Markets eliminate the need for accounting."** §5.4's *post-facto simulation* is the paper's nuanced answer: full per-operation accounting is too expensive for many computations; post-facto simulation gives many of the benefits without the run-time cost. The §3.5 *Coase / firms* argument is the broader framing: *transaction costs are real; the architectural choice is which interactions to price and which to bundle inside firms*.
- **"Compilation-as-investment requires AI."** §5.3.4 is explicit that simple economic agents can produce the speculation-and-investment dynamics; what's required is *price signals* and *unforgeable identity for the agents*, not sophisticated AI. The §6.2 *marketplace of mind* extends to AI, but §5.3.4's compilation-as-investment does not require it.
- **"The scandal of idle time is a 1988 problem solved by virtualization."** No — modern cloud infrastructure has the *substrate* for utilization but not the *market discipline*. Hyperscalers internalize the market across many customers; per-object-per-resource pricing as the paper envisions has not been realized in mainstream computing. Agoric's metering is the closest contemporary enactment.
