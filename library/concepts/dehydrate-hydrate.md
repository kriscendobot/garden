---
id: dehydrate-hydrate
aliases: ["dehydrate", "hydrate", "dehydration and hydration", "formula key vs locator", "stable formula key vs ephemeral hints", "pet store holds formula keys not locators", "dehydrate at ingestion hydrate at presentation"]
topics: [daemon, persistence, capability-security]
---

# dehydrate-hydrate

The Endo Daemon's discipline for separating *stable* references
(formula keys) from *ephemeral* network metadata (connection hints).
On ingestion (a locator arrives from another peer / user input / chat),
the daemon **dehydrates** it: the formula key (`{address}:{peerKey}`)
goes to the pet store; the connection hints go to a separate per-peer
record where they can be replaced wholesale on the next arrival.
On presentation (a locator is needed for display / sharing /
invitation), the daemon **hydrates**: looks up the peer's *current*
hints and combines them with the stored formula key. Identity is
stable across hint changes; long-stored references stay reachable as
peer network addresses change.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dlt/dehydration-and-hydration](../sections/endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration.md) | The canonical exposition with both code shapes and the round-trip invariant. |
| [dlt/method-additions](../sections/endo-but-for-bots--llm-designs-dlt--method-additions.md) | The API consequence: `locate` (durable, no hints) vs `locateWithHints` (immediate sharing). |
| [dlt/locator-format-evolution](../sections/endo-but-for-bots--llm-designs-dlt--locator-format-evolution.md) | The locator URL format that carries hints inline so dehydration is meaningful. |

## See also

- [[local-node-sentinel]] — externalize/internalize swaps LOCAL_NODE for an agent key on outbound dehydration boundary.
- [[producer-typed-shape-consumer-rendering]] — the formula key is the typed shape; the locator URL is the rendered form.
