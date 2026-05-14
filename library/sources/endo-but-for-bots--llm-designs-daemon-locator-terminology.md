---
source: designs/daemon-locator-terminology.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bccee2841e52eb5e42ec5b5be4fcbe1e66d60a42
source_date: 2026-03-17
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: Builds on `daemon-256-bit-identifiers.md` (the prior migration). Strict invariant — *no existing method signatures change*; the design is documentation + types + new methods, not a breaking rename. Introduces the LOCAL_NODE sentinel (`'0' × 64`) and the dehydrate/hydrate split between stable formula keys and ephemeral connection hints, alongside the new locator URL format with `@`-separated inline hints.
---

> Abstract: Daemon identifier and locator terminology rename — *Node Number → Peer Key*, *Formula Number → Formula Address*, *Formula Identifier → Formula Key* — bridged by `types.d.ts` aliases so the rename is non-breaking. The new locator URL format moves the formula address from `?id=` onto the path (`endo://{peerKey}/{formulaAddress}?type=...`) and inlines connection hints with `@` separators. `parseLocator` is format-aware: presence of `?id=` triggers the old parser, so pet stores (which hold formula keys, not locators) need no migration. Two new methods are added: `formatLocatorWithHints` and `locateWithHints`. The LOCAL_NODE sentinel (`'0' × 64`) replaces any local agent's key in internal storage so a single formula has one internal entry regardless of which agent created or views it; externalization stamps the agent's actual public key on outgoing locators. A startup `repairIds` pass normalizes pre-migration pet-store entries; `normalizeId` handles on-touch rewrites in formula dependency references.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [terminology-rename](../sections/endo-but-for-bots--llm-designs-dlt--terminology-rename.md) | daemon, agent-conventions | current |
| [locator-format-evolution](../sections/endo-but-for-bots--llm-designs-dlt--locator-format-evolution.md) | daemon, ocapn | current |
| [method-additions](../sections/endo-but-for-bots--llm-designs-dlt--method-additions.md) | daemon, agent-conventions | current |
| [local-node-sentinel](../sections/endo-but-for-bots--llm-designs-dlt--local-node-sentinel.md) | daemon, capability-security, patterns | current |
| [dehydration-and-hydration](../sections/endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration.md) | daemon, persistence, capability-security | current |

## See also

- `daemon-256-bit-identifiers.md` — the prior migration that established 256-bit keys
- `retention-path-notation.md` (`rpn`) — same producers-own-typed-shape, consumers-own-rendering discipline
