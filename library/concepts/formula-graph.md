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

## Storage substrate — two distinct layers

The daemon's formula-related state lives in **two structurally
different on-disk stores**, and they are not interchangeable.
Confusing them is a common library-reader mistake (the round-2 A/B
test's Q7 surfaced one such confusion):

| Store | Substrate | What lives there |
|---|---|---|
| Formula store | **JSON files** at `<statePath>/formulas/<head(2)>/<tail(62)>.json` | One file per formula. The formula record itself — its type, dependencies, content. Written via `DaemonicPersistencePowers.writeFormula`. |
| Content-addressed blob store | Files at `<statePath>/store-sha256/<hash>` | Bytes of `readable-blob` / `readable-tree` formula content, addressed by SHA-256. |
| Pet-name binding store | Small files in per-agent pet-name directories | Each pet name → formula id; one tiny file per pet name. |
| **Retention table** | **SQLite** at `daemon-database.js:87` | `retention(guest_public_key, retained_formula_number)` — cross-peer retention edges only. Shadows the in-memory `formulaGraph.retentionEdges` map. |

The formula store, the blob store, and the pet-name directory are
**JSON / file-per-entity**. Only the retention table uses SQLite,
and it is **only the cross-peer retention edges** — not the
formulas, not the pet names, not policy state. Capability policies
(allowlists, TOFB bindings, etc.) are persisted as ordinary
formulas in the JSON formula store, not in a separate SQLite table.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/formula-graph-and-cohort-destruction](../sections/endo--designs-dp--formula-graph-and-cohort-destruction.md) | Petname graph as persistence root; formulas as construction recipes; the live vs. formula reference graphs. |
| [dp/acyclic-formula-graph-and-revocation](../sections/endo--designs-dp--acyclic-formula-graph-and-revocation.md) | Acyclic + locally reference-counted properties; permitted cycles among co-formula groups; the formula graph as the *floor* from which heap-bloat is recovered. |
| [dcpg/persistence-and-graph](../sections/endo-but-for-bots--llm-designs-dcpg--persistence-and-graph.md) | `formulaGraph.retentionEdges` map + the SQLite shadow + the three-clause local GC reachability test (the third clause is the peer-set). |
| [d256/formula-types-and-security](../sections/endo-but-for-bots--llm-designs-d256--formula-types-and-security.md) | The 26 formula types that populate the graph: `directory`, `endo`, `eval`, `guest`, `handle`, `host`, `invitation`, `keypair`, etc. |
| [d256/identifier-migration-and-crypto-powers](../sections/endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers.md) | Storage path format `<statePath>/formulas/<head(2)>/<tail(62)>.json` — the on-disk shape of the JSON formula store, sharded by leading hex chars. |
| [d256/per-agent-keypairs](../sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs.md) | Keypair lifecycle follows formula lifecycle (deleting the formula deletes the keys) — no new persistence layer needed; agent identities are formulas in this graph. |
| [dlt/dehydration-and-hydration](../sections/endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration.md) | Pet stores hold formula keys (formula-graph identifiers), not locators; ephemeral hints live separately. The boundary at which the graph's identifiers leave/enter the daemon's address space. |

## See also

- [[formula-persistence-thesis]] — the surrounding design.
- [[cohort-destruction]] — what happens when partition interrupts a live reference subgraph backed by this graph.
- [[per-agent-keypair]] — agent identities are just one more formula in the graph.
