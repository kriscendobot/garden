---
id: business-agent
aliases: ["business agent", "business agents", "data-type agent", "manager agent", "agent-selection agent", "performance-domain delegate", "subcontractor vs agent", "specialized resource-allocation agent", "lookup-table agent"]
topics: [capability-security, agent-conventions, patterns]
---

# business-agent

A **performance-domain delegate** in an agoric system — a software object that handles bidding, pricing, subcontractor selection, contract negotiation, reputation judgment, and tradeoff decisions on behalf of another object. The 1988 *Markets and Computation* paper §5.3 introduces the term and distinguishes it sharply from the OO-tradition's **subcontractor** (a delegate that handles *competence-domain* work, the hierarchical-decomposition pattern that originated with the subroutine). Both abstractions are *delegation*; the distinction is the domain of delegation. The architectural payoff: simple objects can find their way in a complex agoric world *by being born with service relationships to sophisticated agents* — and those sophisticated agents can themselves be composed of simple objects with their own agent relationships, recursing as deep as needed.

The §5.3 paper develops three sub-families of business agents that the library can name independently:

- **Data-type agents (§5.3.1)**: select implementations of an abstract data type based on usage patterns. The canonical example is the *lookup-table agent* that maintains usage statistics and transparently switches between linked-list, balanced-binary-tree, hash-table, and distributed-table implementations depending on the access pattern. The agent could also provide a *trial lookup table that gathers usage statistics* — a low-overhead mechanism for adaptive performance optimization.
- **Managers (§5.3.2)**: agents that set prices, select subcontractors, and negotiate contracts. They must judge reputations. Manager-agents are agents that select other agents; the infinite-regress objection is addressed by *agent-selection agents born with fixed initial choices*.
- **Reputation services (§5.3.3)**: agents that judge other agents' service quality. Distinguished into positive vs negative reputation systems (the cycle-78 [[positive-vs-negative-reputation]] concept page covers this taxonomy in detail).

A fourth sub-family, **compilation speculators (§5.3.4)**, are performance-domain agents that *invest* in program-transformation tradeoffs — partial-evaluation, inlining, layout optimizations — and share in the resulting efficiency gains. The §5.3.4 *Pareto-preferred compiler* concept (a compiler that performs cross-module transformations guaranteeing some component is better off and none is worse off) is what makes compilation-as-investment composable.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies](../sections/papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies.md) | **Canonical exposition.** §5.3 introduces business agents, the lookup-table-agent example, manager-agents, reputation services, and compilation speculators. The closing §5.4 *scandal of idle time* names the diagnostic frame business agents are positioned to address. |
| [papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations.md) | §4.3 competence-vs-performance modularity is the structural justification: business agents are the operational machinery by which performance modularization happens. Without agents, performance choices are made implicitly at instantiation time and cannot adapt. |
| [papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems.md) | §6.2 marketplace-of-mind extends the agent abstraction to *knowledge-based services*: intelligence as emergent property of market interactions among knowledge-bearing agents. |
| [papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) | §6.4 *broker mutually trusted by the option buyer and seller* — the broker is a business-agent (specifically, a manager-agent) that mediates the smart-contract setup. The 2000 paper's worked example uses a business agent without naming it as such. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) | The vat is the unit of isolation a business agent runs inside. Agents are vat-resident objects with stable identity and persistence semantics. |

## See also

- [[positive-vs-negative-reputation]] — the trust-substrate taxonomy that business-agent (specifically manager-agent and reputation-service) discipline rests on.
- [[competence-vs-performance-modularity]] — the structural framing that justifies why business agents are needed *in addition to* subcontractors.
- [[agoric-system]] — the broader market framework business agents operate within.
- [[principle-of-least-authority]] — POLA at the business-agent layer: each agent holds the minimum authority needed for its delegation role.
- [[four-ways-to-acquire-references]] — the structural substrate. Business agents acquire references to their clients and subcontractors via standard Introduction/Endowment mechanisms.
- [[smart-contract]] — smart contracts often use business agents (especially brokers and managers) as mutually-trusted third parties.
- [[caretaker-pattern]] — Caretakers are the *attenuation* sibling of business agents: where business agents *select* and *bid*, Caretakers *limit* and *revoke*.

## Common confusions

- **"Business agents are AI agents."** No — §5.3 is explicit that *simple* objects can be business agents. The 1988 paper anticipated AI-mediated agents (§6.2 marketplace-of-mind extends this), but the §5.3 business-agent abstraction does not require AI. A lookup-table agent can be ~50 lines of code that maintains usage statistics and switches implementations; it does not need to "understand" anything. The agent abstraction is about *delegation*, not intelligence.
- **"Subcontractor vs agent is a stylistic distinction."** No — it is a *domain* distinction. Subcontractors handle competence-domain work (the hierarchical-decomposition pattern: factor out a sub-task into a sub-object); agents handle performance-domain work (the delegation pattern: factor out a *tradeoff decision* into a specialized agent). The structural payoff: an object can have both subcontractors and agents simultaneously, with no entanglement between them.
- **"Endo has business agents."** Partially. Agoric SwingSet's metering discipline is the closest enactment; Zoe contract framework is partial (Zoe's mutually-trusted broker is structurally a manager-agent). But the *§5.3.1 data-type-agent* pattern — adaptive implementation selection at runtime based on usage statistics — is largely unrealized in the contemporary @endo / Agoric stack. This is one of the clearer architectural gaps.
- **"The infinite-regress is unsolvable."** §5.3.2 addresses this directly: *an object can be born with a fixed agent-selection agent. The system as a whole remains flexible, since different objects (or versions of a single object) will use different agent-selection agents. Those using poor ones will tend to be eliminated by competition.* The infinite regress is *cut* at the initial-conditions layer; subsequent agent-selection becomes a market-mediated process.
- **"Business agents require centralized coordination."** No — agents are *individual* objects, each with their own state and decisions. The §5.3.3 reputation-service framing addresses how distributed agents can build trust without central coordination. The architectural prescription matches the broader agoric-systems framing: islands of central direction (within an agent, or within an agent's TCB), sea of trade (between agents).
- **"Compilation speculators require complete program analysis."** §5.3.4 is explicit: *compilation speculators can estimate demand, invest in program transformations, and share in the resulting savings*. The estimation can be probabilistic, the investment can be partial, and the *Pareto-preferred compiler* construction ensures the system improves even if some speculators lose investment capital. The model tolerates imperfect agents.
