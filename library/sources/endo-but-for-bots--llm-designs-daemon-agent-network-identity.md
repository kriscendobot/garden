---
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: The **followup** to [[endo-but-for-bots--llm-designs-daemon-256-bit-identifiers]] — originally that document's *"Future Work"* section, split out as a sibling design. Two of four work items (locator construction with agent keys; LOCAL_NODE for formula storage) have shipped via the locator-terminology rename ([[endo-but-for-bots--llm-designs-daemon-locator-terminology]]); the other two (per-agent NETS; network registration) are still **In Progress** upstream. This document is the **origin** of the LOCAL_NODE sentinel and the `0.0.0.0`-as-this-host analogy that `dlt` later landed.
---

> Abstract: Integration layer between per-agent keypairs (d256) and the network protocol layer. Four work items: (1) locator construction with agent keys — **Done** in dlt; (2) LOCAL_NODE for formula storage — **Done** in dlt; (3) per-agent networks (NETS) — In Progress; (4) network registration — In Progress. Items 3 and 4 are this document's substantive new material. *Per-agent NETS*: every agent (host and guest) gets its own NETS special name pointing to its own networks directory; root host startup unchanged; default contents empty; new GuestFormula `networks` field; empty NETS produces locators without hints (foundation for anonymizing personas). *Network registration*: new `EndoNetwork.registerAgentKey(publicKey, agentId)` / `unregisterAgentKey(publicKey)` methods; additive (networks without multi-key support ignore the calls); daemon root keypair always registered as default. *Per-agent connection hints*: `AgentConnectionHints` typed shape with `requireRelay`, `allowDirectConnect`, `preferredTransports`, `relayAddresses` — advisory, since the keypair is the ultimate identity. *Null local-node sentinel*: the **origin document** for `LOCAL_NODE = '0'.repeat(64)` and the `0.0.0.0`-as-this-host analogy — the all-zeros point is not on the Ed25519 curve, so it can never collide with a valid public key. Externalize/internalize pair establishes the discipline that `dlt` later named.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [status-and-overlap-with-dlt](../sections/endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt.md) | daemon, capability-security | current |
| [per-agent-networks-and-nets](../sections/endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets.md) | daemon, capability-security, agent-conventions | current |
| [network-registration](../sections/endo-but-for-bots--llm-designs-dani--network-registration.md) | daemon, ocapn, capability-security | current |
| [per-agent-connection-hints-and-null-local-node](../sections/endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node.md) | daemon, capability-security, patterns | current |

## See also

- `daemon-256-bit-identifiers.md` (`d256`) — parent design; this was originally its *"Future Work"* section
- `daemon-locator-terminology.md` (`dlt`) — landed two of this design's four work items (LOCAL_NODE sentinel + agent-stamped locators)
- `daemon-persistence.md` (`dp`, PR #3121) — Formula Persistence model that motivates per-agent identity
- `ocapn-network-transport-separation.md` (`ntsep`) — the network abstraction layer that will implement `registerAgentKey`
- `ocapn-noise-network.md` — the OCapN-Noise protocol that uses Ed25519 keys for peer authentication
- `daemon-capability-persona.md` — the persona system that motivates per-agent network identity (not yet ingested)
