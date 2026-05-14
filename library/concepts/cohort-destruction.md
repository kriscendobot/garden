---
id: cohort-destruction
aliases: ["destruction by cohort", "pass by construction", "reconstruction on demand", "cohort", "cohort-aware programming model", "disincarnation by cohort"]
topics: [daemon, persistence, capability-security]
---

# cohort-destruction

The Endo Daemon's response to partition: when any reference in a
*cohort* (a capability plus the live references for its transitive
dependencies) becomes partitioned, the entire dependent subgraph of
live references is collectively destroyed. The system then offers
*reconstruction on demand* — affected capabilities may later be
reincarnated from their formulas when partition heals and a consumer
requests them. This is the *pass by construction* property: rather
than patching a partially broken graph of live references, the
system destroys the affected cohort and rebuilds from formulas. The
programming model is therefore "cohort-aware" rather than per-reference
defensive (E) or partition-blind (Waterken).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/formula-graph-and-cohort-destruction](../sections/endo--designs-dp--formula-graph-and-cohort-destruction.md) | The canonical exposition — petname graph as persistence root, formulas as recipes, cohort + reconstruction-on-demand, graceful-shutdown window. |
| [dp/frame-and-position-in-design-space](../sections/endo--designs-dp--frame-and-position-in-design-space.md) | Position in the design space — "exposed per-cohort" placement between Waterken (masked) and E (per-reference). |
| [dp/system-fit-and-not-orthogonal](../sections/endo--designs-dp--system-fit-and-not-orthogonal.md) | Why a user agent needs cohort destruction rather than orthogonal persistence: instant restart + no distributed GC obligation. |

## See also

- [[formula-graph]] — the durable substrate that survives cohort destruction.
- [[formula-persistence-thesis]] — the surrounding design that names this property.
- [[revocation-by-withdrawal]] — the user-initiated form of cohort destruction.
