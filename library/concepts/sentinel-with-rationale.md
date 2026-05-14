---
id: sentinel-with-rationale
aliases: ["sentinel-with-rationale", "deliberately-unreachable value", "why it cannot collide", "out-of-band sentinel", "rationale for sentinel choice"]
topics: [patterns, capability-security]
---

# sentinel-with-rationale

A pattern for choosing a special value to mark an out-of-band state:
*use a deliberately-unreachable value as a sentinel, with an explicit
rationale for why it cannot collide with valid values.* The rationale
licenses the sentinel — without it, a future reader cannot tell
whether a collision is impossible or merely unlikely. The
sentinel-with-rationale pattern recurs in the daemon design cluster:

| Sentinel | Why it cannot collide |
|---|---|
| `LOCAL_NODE = '0'.repeat(64)` for the local-node component in formula keys | The all-zeros point is not on the Ed25519 curve. |

Future ingests of daemon material should record similar
deliberately-unreachable-value + rationale pairs explicitly when they
appear.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dani/per-agent-connection-hints-and-null-local-node](../sections/endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node.md) | The pattern's origin: the `0.0.0.0`-as-this-host analogy and the all-zeros-not-on-the-curve rationale. |
| [dlt/local-node-sentinel](../sections/endo-but-for-bots--llm-designs-dlt--local-node-sentinel.md) | The shipping implementation with the same sentinel + rationale. |

## See also

- [[local-node-sentinel]] — the canonical instance.
- [[shape-not-content]] and [[producer-typed-shape-consumer-rendering]] — sibling structural principles from cycles 41-43.
