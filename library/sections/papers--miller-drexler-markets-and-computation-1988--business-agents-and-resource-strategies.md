---
title: Business Agents, Initial Market Strategies, and the Scandal of Idle Time (subcontractors vs agents; data-type agents; reputations; compilation as investment; the idle-resource diagnosis)
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
---

## Abstract

§5 introduces the **agent** abstraction: a software object that delegates *performance-domain* actions for other objects, analogous to how a *subcontractor* (a traditional design-pattern concept) delegates *competence-domain* actions. The architectural insight: simple objects can participate in sophisticated markets *by delegation* — a small lookup-table client can ask a sophisticated *lookup-table agent* to decide which implementation to use, what tradeoffs to make, and when to switch as usage patterns change. §5.1 names *initial market strategies* as the resource-allocation algorithms that scaffold the system into existence — auction-based processor scheduling, rent-based memory allocation — drawn from the companion paper *Incentive Engineering for Computational Resource Management* [III]. §5.2 frames *business location decisions* as the architectural metaphor for memory-hierarchy management: core memory is the high-rent business district, disk is the residential district, and objects pay rent and commute based on local economic decisions. §5.3 develops the central machinery — *data-type agents* who select implementations based on usage patterns, *managers* who select agents and set prices, and *reputations* that scale trust without requiring exhaustive verification. §5.3.4 introduces *compilation as investment*: compile-speculators invest in program transformations and earn returns from the resulting efficiency improvements. §5.4 names what the paper calls **the scandal of idle time** — most computing resources sit idle most of the time, a sign of "very wasteful resource allocation policies," and one suspects "it is just the tip of a very large iceberg." The §5.4 closing offers Terry Stanley's *post-facto simulation* as a partial answer.

## Body

### §5.1 Initial market strategies — auction-based scheduling, rent-based memory

§5.1 names the architectural premise: in the market approach, *systems programming problems such as garbage collection and processor scheduling* can be recast in terms of *local negotiation among objects* — instead of an omniscient central planner imposing a system-wide solution based on global aggregate statistics, objects can be given price information and make profitable use of resulting flexibility. The paper points to a companion paper, *Incentive Engineering for Computational Resource Management* [III], for full development. The §5.1 sketches:

- **Initial strategies for processor scheduling** based on *auctions in which bids can be automatically escalated to ensure they are eventually accepted*.
- **Initial strategies for memory allocation and garbage collection** based on *rent payment, with objects paying retainer fees to objects they wish to retain in memory*. Objects that are unwanted and hence unable to pay rent are eventually evicted, deallocating their memory space.

The §5.1 architectural payoff: initial market strategies will *provide a programmable system that generates price information, enabling a wide range of choices to be made on economic grounds*. **For example, processor and memory prices can guide decisions regarding the use of memory to cache recomputable results. Given a rule for estimating the future rate of requests for a result, one should cache the result whenever the cost of storage for the result is less than the rate of requests times the cost of recomputing the result.** The general principle: as demand for memory rises, the memory price rises, and these rules should free the less-valuable parts of caches; if processing prices rise, caches should grow. **Thus, prices favor tradeoffs through trade.**

### §5.2 Business location decisions — memory hierarchy as commercial geography

§5.2 makes one of the paper's most-quoted architectural metaphors: *main "core" memory is a high-performance resource in short supply; disk is a lower-performance resource in more plentiful supply*. In an agoric system, **core memory will typically be a high-rent (business) district, while disk will typically be a low-rent (residential) district**. Commuting from one to the other will take time and cost money. An object that stays in core will pay higher rent but can provide faster service. To the degree that this is of value, the object can charge more; if increased income more than offsets the higher rent, the object will profit by staying in core.

The §5.2 generalization to migration in distributed systems: *machines linked by networks resemble cities linked by highways. Different locations have different levels of demand, different business costs, and different travel and communications costs.* The paper enumerates five traditional approaches (staying put and using the phone; commuting to wherever momentary demand is; moving only when there are no local customers; coordinating multiple offices; moving where labor costs are lower — load balancing) — each maps directly to a market-decision style and each will tend to win or lose under different economic conditions.

### §5.3 Business agents — the central machinery

§5.3 distinguishes two delegation-styled abstractions:

- **Subcontractor**: an object that does *competence-domain* work on behalf of another (the traditional design-patterns sense). Hierarchical decomposition.
- **Agent**: an object that does *performance-domain* work on behalf of another — bid prices, select subcontractors, negotiate contracts, judge reputations, decide on tradeoffs. Performance-domain delegation.

The §5.3 architectural payoff: *simple objects can find their way in a complex world by being born with service relationships to sophisticated agents (which themselves can be composed of simple objects, born with...). Initially, human decisions will establish these relationships; later, specialized agent-providing agents can establish them as part of the process of creating new economic objects.*

#### §5.3.1 Data-type agents — the lookup-table example

§5.3.1 develops the *lookup-table agent* as the canonical worked example. In object-oriented programming, one can supply multiple implementations of an abstract data type, all providing the same service through the same protocol but offering different *performance tradeoffs*. Linked list, balanced binary tree, hash table, distributed table. Code that *uses* such an abstract data type is itself generally abstract; code that *requests an instance* is usually less abstract and embodies tradeoff decisions in a relatively scattered, frozen form.

The §5.3.1 architectural insight: *in a market, agents can unfreeze these decisions*. Instantiation requests can be sent to a data-type agent, which then provides a suitable subcontractor. Just as someone seeking a house can consult a real-estate agent specializing in tradeoffs, a lookup-table agent could know what lookup-table implementations are available and what tradeoffs they embody. **The agent could also "ask questions" by providing a trial lookup table that gathers usage statistics; once a pattern becomes clear, the agent can transparently switch to a more appropriate implementation.** Long-term, sporadic sampling of usage patterns can provide a low-overhead mechanism for alerting the agent of needed changes in implementation.

#### §5.3.2 Managers — agent-selection agents

§5.3.2 names *managers* as agents that *select subcontractors and set prices*. To select good agents and subcontractors, manager-agents will need to judge reputations. The §5.3.2 closing addresses the infinite-regress objection: *agent-selection agents are also in competition with each other, but this need not lead to an infinite regress: for example, an object can be born with a fixed agent-selection agent. The system as a whole remains flexible, since different objects (or versions of a single object) will use different agent-selection agents. Those using poor ones will tend to be eliminated by competition.*

#### §5.3.3 Reputations — positive vs negative

§5.3.3 names a structural taxonomy of reputation systems:

- **Negative reputation systems** *fail if effective pseudonyms are cheaply available* — an entity with a bad reputation discards it and starts over.
- **Positive reputation systems** require only that one entity cannot claim the identity of another — a condition met by *actors* and by *public-key systems*. The §5.3.3 conclusion: computational markets are expected to rely on *positive reputation systems*.

The §5.3.3 closing addresses the new-object cold-start problem: *new objects can give reason to expect good service — thereby establishing a positive reputation — by posting a cash bond guaranteeing good performance*. This requires both parties to the contract to trust some third party to hold the bond and judge performance.

#### §5.3.4 Compilation as investment

§5.3.4 names a deep architectural insight: tradeoffs in compilation can often be cast in economic terms. The best choice in a time-space tradeoff depends on processor and memory costs and on the value of a prompt result. *Investment in code transformation is much like other investments in an economy: it involves estimates of future demand, and hence cannot be made by a simple, general algorithm.* In a computational market, compilation speculators can estimate demand, invest in program transformations, and share in the resulting savings. Some will overspend and lose investment capital; others will spend in better-adapted ways. Overall, resources will flow toward investors following rules that are well-adapted to usage patterns in the system, thereby allocating resources more effectively. This is an example of *the subtlety of evolutionary adaptation: nowhere need these patterns be explicitly represented*.

The §5.3.4 paper also introduces the **Pareto-preferred compiler** concept: a compiler that performs cross-module transformations *so as to guarantee that some component will be better off and none will be worse off*. This can be achieved even if the resulting division of income only approximates the original proportions, since the total savings from compilation will result in a greater total income to divide. The expectation of Pareto-preferred results is enough to induce objects to submit to compilation; since multiple results can meet this condition, room will remain for negotiation.

### §5.4 The scandal of idle time

§5.4 names what the paper calls the **scandal of idle time**: *current resource allocation policies leave much to be desired. One sign of this is that most computing resources — including CPUs, disk heads, local area networks, and much more — sit idle most of the time. But such resources have obvious uses, including improving their own efficiency during later use.*

The §5.4 diagnosis: in a computational market, *a set of unused resources would typically have a zero or near-zero price of use, reflecting only the cost of whatever power consumption or maintenance could be saved by genuine idleness or complete shutdown. Almost any use, however trivial, would then be profitable.* In practice, contention for use would bid prices up until they reflected the marginal value of use. **Idle time is a blatant sign of wasteful resource allocation policies; one suspects that it is just the tip of a very large iceberg.**

The §5.4 closing offers Terry Stanley's *post-facto simulation* as a partial answer: a technique that uses idle (or inexpensive) time. It enables a set of objects to avoid the overhead of fine-grained accounting while gaining many of its advantages. While doing real work, they do no accounting and make no attempt to adapt to internal price information; instead, they just gather statistics (at low overhead) to characterize the computation. Later, when processing is cheap and response-time demands are absent (i.e., at "night"), they *simulate* the computation (based on the statistics), but with fine-grained accounting turned on. To simulate the day-time situation, they do not charge for the overhead of this accounting, and proceed using simulated "day" prices. The resulting decisions (regarding choice of data structures, use of partial evaluation, etc.) should improve performance during future "days". **This is analogous to giving your best real-time response during a meeting, then reviewing it slowly afterward: by considering what you should have done, you improve your future performance.**

## Translation block (paper idiom → Endo / Agoric / Hardened JavaScript surface)

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

## Implications for Endo

This section is *most useful as the unrealized-architecture map*: it names the agoric-systems primitives the Endo / Agoric stack has not yet enacted at the performance-modularity layer. The library can use §5 as the canonical reference when:

1. **A design names "business agent" or "agoric system" without further elaboration.** §5 is the canonical citation; §5.3 develops the agent vs subcontractor distinction.
2. **A design names "reputation system."** §5.3.3 is the canonical citation for the positive-vs-negative distinction. Agoric's IST and similar systems implicitly choose positive reputation; this section grounds the choice.
3. **A design proposes resource-pricing or metering.** §5.1 is the canonical historical anchor; the contemporary @endo/agoric meter-and-fuel discipline traces its lineage here.
4. **A design discusses idle-resource use or post-facto analysis.** §5.4 is the canonical citation; the "scandal of idle time" framing is the diagnostic vocabulary.
5. **A design proposes adaptive implementation selection (data structure switching at runtime).** §5.3.1 is the canonical lookup-table-agent example.

**The biggest architectural gap the section reveals**: Endo today modularizes *competence* (exo + lockdown + marshal); the *performance modularization via prices* that §4.3 named and §5 develops is largely unrealized. Agoric SwingSet's meter discipline is the closest production enactment, but the broader market-mediated resource allocation the paper envisions remains research territory.

## See also

- [[principle-of-least-authority]] — POLA at the access layer; this section's market framework is POLA at the *resource* layer (each object holds the minimum resource-authority needed). The thesis extends.
- [[four-ways-to-acquire-references]] — capability constraints on connectivity; this section's market discipline operates *within* those constraints. The two layers are orthogonal.
- [[security-as-extreme-modularity]] — competence-modularity-as-security; this section extends to performance-modularity-as-economic-efficiency.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--mint-purse-money-and-six-security-properties` — the 2000 paper's mint-purse-money example is the worked-out form of §4.4's currency framing and §5.1's initial market strategy for currency transfer.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — vats are the 2005 framing of what §3.5 calls "computational firms" — protected aggregations of objects with low-overhead internal accounting.

## Common confusions

- **"Business agents are just smart contracts."** No — smart contracts (per the 2000 paper's terminology) are *application-level* compositions of capability-based money + access; business agents are *performance-layer* delegates that choose implementations, prices, and tradeoffs. The two layers are orthogonal; an Agoric Zoe contract may use business agents to choose its data-structure implementations.
- **"Reputation systems need anonymity."** §5.3.3's positive-reputation discipline does *not* require anonymity — it requires *unforgeable identity*. The substrate is capability + per-agent-keypair (the 1988 framing). Negative-reputation systems fail under anonymity; positive-reputation systems do not.
- **"Markets eliminate the need for accounting."** §5.4's *post-facto simulation* is the paper's nuanced answer: full per-operation accounting is too expensive for many computations; post-facto simulation gives many of the benefits without the run-time cost. The §3.5 *Coase / firms* argument is the broader framing: *transaction costs are real; the architectural choice is which interactions to price and which to bundle inside firms*.
- **"Compilation-as-investment requires AI."** §5.3.4 is explicit that simple economic agents can produce the speculation-and-investment dynamics; what's required is *price signals* and *unforgeable identity for the agents*, not sophisticated AI. The §6.2 *marketplace of mind* extends to AI, but §5.3.4's compilation-as-investment does not require it.
- **"The scandal of idle time is a 1988 problem solved by virtualization."** No — modern cloud infrastructure has the *substrate* for utilization but not the *market discipline*. Hyperscalers internalize the market across many customers; per-object-per-resource pricing as the paper envisions has not been realized in mainstream computing. Agoric's metering is the closest contemporary enactment.
