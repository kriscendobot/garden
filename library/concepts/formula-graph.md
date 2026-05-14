---
id: formula-graph
aliases: ["formula graph", "formulaGraph", "petname graph as persistence root", "persist construction not content", "formulas as recipes", "formulas as constructors", "acyclic formula graph"]
topics: [daemon, persistence, capability-security]
---

# formula-graph

The Endo Daemon's durable substrate. The petname database maps
human-readable names to *formulas* — recipes for reconstructing a
live reference and its transitive dependencies. The graph is
*acyclic across peers* (it admits limited cycles only among co-formula
groups like promise/resolver pairs and agent-handle pairs that must
present unique unforgeable identifiers while being constructed as
facets of a shared underlying capability) and *locally
reference-counted* — no distributed garbage collection protocol is
needed for the durable layer. Formulas persist *construction, not
content*: each formula records how to arrive at the live reference and
how to construct its dependencies, not a snapshot of state.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/formula-graph-and-cohort-destruction](../sections/endo--designs-dp--formula-graph-and-cohort-destruction.md) | Petname graph as persistence root; formulas as construction recipes; the live vs. formula reference graphs. |
| [dp/acyclic-formula-graph-and-revocation](../sections/endo--designs-dp--acyclic-formula-graph-and-revocation.md) | Acyclic + locally reference-counted properties; permitted cycles among co-formula groups; the formula graph as the *floor* from which heap-bloat is recovered. |
| [dcpg/persistence-and-graph](../sections/endo-but-for-bots--llm-designs-dcpg--persistence-and-graph.md) | `formulaGraph.retentionEdges` map + the SQLite shadow + the three-clause local GC reachability test (the third clause is the peer-set). |
| [d256/formula-types-and-security](../sections/endo-but-for-bots--llm-designs-d256--formula-types-and-security.md) | The 26 formula types that populate the graph: `directory`, `endo`, `eval`, `guest`, `handle`, `host`, `invitation`, `keypair`, etc. |

## See also

- [[formula-persistence-thesis]] — the surrounding design.
- [[cohort-destruction]] — what happens when partition interrupts a live reference subgraph backed by this graph.
- [[per-agent-keypair]] — agent identities are just one more formula in the graph.
