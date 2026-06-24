---
id: local-node-sentinel
aliases: [LOCAL_NODE, "all-zeros sentinel", "0.0.0.0 of Ed25519", "sentinel local node", "'0'.repeat(64)"]
topics: [daemon, capability-security, patterns]
---

# local-node-sentinel

The daemon's internal-storage convention for representing "this host's
keypair" when there is no single canonical local node identifier.
`LOCAL_NODE = '0'.repeat(64)` is used in all locally-stored formula keys
in place of any specific agent's Ed25519 public key. The sentinel cannot
collide with a valid public key because the all-zeros point is not on
the Ed25519 curve (analogous to `0.0.0.0` as a "this host" placeholder
in networking). Externalize/internalize functions swap LOCAL_NODE for
the sharing agent's actual key on outbound locators and back to
LOCAL_NODE for inbound ones recognized as local.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dlt/local-node-sentinel](../sections/endo-but-for-bots--llm-designs-dlt--local-node-sentinel.md) | The shipping implementation: `localKeys` set, `isLocalKey` predicate, `internalizeLocator` / `externalizeId` functions, startup `repairIds` pass. |
| [dani/per-agent-connection-hints-and-null-local-node](../sections/endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node.md) | Origin document — introduces the `0.0.0.0`-as-this-host analogy and the rationale that `'0'.repeat(64)` is not a valid Ed25519 public key. |

## See also

- [[per-agent-keypair]] — each agent has its own keypair; LOCAL_NODE is what local storage uses *instead* of any specific agent key.
- [[sentinel-with-rationale]] — the broader pattern this is an instance of.
- [[dehydrate-hydrate]] — the externalize/internalize pair is the boundary at which LOCAL_NODE is swapped.
