---
title: Abstract
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

§5 introduces the **agent** abstraction: a software object that delegates *performance-domain* actions for other objects, analogous to how a *subcontractor* (a traditional design-pattern concept) delegates *competence-domain* actions. The architectural insight: simple objects can participate in sophisticated markets *by delegation* — a small lookup-table client can ask a sophisticated *lookup-table agent* to decide which implementation to use, what tradeoffs to make, and when to switch as usage patterns change. §5.1 names *initial market strategies* as the resource-allocation algorithms that scaffold the system into existence — auction-based processor scheduling, rent-based memory allocation — drawn from the companion paper *Incentive Engineering for Computational Resource Management* [III]. §5.2 frames *business location decisions* as the architectural metaphor for memory-hierarchy management: core memory is the high-rent business district, disk is the residential district, and objects pay rent and commute based on local economic decisions. §5.3 develops the central machinery — *data-type agents* who select implementations based on usage patterns, *managers* who select agents and set prices, and *reputations* that scale trust without requiring exhaustive verification. §5.3.4 introduces *compilation as investment*: compile-speculators invest in program transformations and earn returns from the resulting efficiency improvements. §5.4 names what the paper calls **the scandal of idle time** — most computing resources sit idle most of the time, a sign of "very wasteful resource allocation policies," and one suspects "it is just the tip of a very large iceberg." The §5.4 closing offers Terry Stanley's *post-facto simulation* as a partial answer.
