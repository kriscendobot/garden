---
title: Translation block (paper idiom → Endo / Agoric / Hardened JavaScript surface)
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

| Paper concept                              | Endo / Agoric equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Subcontractor                              | An exo that delegates competence-domain work to other exos. Standard OO decomposition. Endo / Agoric default pattern. |
| Business agent                             | **No direct counterpart in Endo today.** The agoric-system performance-modularity discipline is the largest unrealized portion of this paper for Endo. |
| Initial market strategy (auction, rent)    | Agoric SwingSet's meter and fuel discipline is the closest production enactment; the broader market-strategy framework is unrealized. |
| Data-type agent (lookup-table example)     | A meta-pattern; closest Endo analog is the @endo/store kit's pluggable backend selection, but the dynamic-implementation-switching the paper describes is not enacted. |
| Business location (core vs disk)           | Endo's bundle-in-daemon vs bundle-in-cold-storage is a primitive enactment; the migration discipline the paper describes is unrealized. |
| Positive reputation system                 | Endo's per-agent-keypair + formula-graph give the substrate (unforgeable identity); the reputation tracking is application-level and not yet integrated. |
| Cash-bond performance guarantee            | Agoric IST and ERTP collateral mechanisms are the production enactment at the application level. |
| Pareto-preferred compiler                  | A future Endo optimization discipline. No current enactment. |
| Post-facto simulation                      | A research direction. No current enactment in production Endo / Agoric. |
| The scandal of idle time                   | A diagnostic frame; the contemporary @endo and Agoric stacks do not yet expose resource-idleness as a market signal. |
