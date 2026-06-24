---
title: Four work items
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **followup** to [[endo-but-for-bots--llm-designs-daemon-256-bit-identifiers]] — was originally that document's *"Future Work"* section, split out as a sibling design once the work grew. Two of its four work items have since shipped via the locator-terminology rename ([[endo-but-for-bots--llm-designs-daemon-locator-terminology]]); the other two — *per-agent networks (NETS)* and *network registration* — are still **In Progress**.
parent: endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt
---

The design enumerates four pieces of integration work; two have
shipped, two are still in flight:

| # | Work item | Status | Where it landed |
|---|---|---|---|
| 1 | Locator construction with agent keys — *each agent stamps outgoing locators with its own Ed25519 public key* | **Done** | Implemented as part of the locator-terminology rename; see [[endo-but-for-bots--llm-designs-dlt--locator-format-evolution]] for the new URL format and [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]] for the externalize/internalize machinery. |
| 2 | LOCAL_NODE for formula storage — *`'0'.repeat(64)` sentinel in locally-stored formula keys; `localKeys` registry + `isLocalKey` predicate; pet-store repair on startup* | **Done** | Implemented as [[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]]. |
| 3 | **Per-agent networks (NETS)** — each agent has its own `NETS` special name pointing to a networks directory that controls connection-hint advertisement | **In progress** | See [[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]. |
| 4 | **Network registration** — installed networks must know agent public keys to route inbound connections | **In progress** | See [[endo-but-for-bots--llm-designs-dani--network-registration]]. |

The Done items are notable for being where this design *originally
specified* mechanisms that have since been implemented and named in
their own designs. This document remains the **historical origin
point** for the LOCAL_NODE sentinel and the externalize/internalize
discipline; `dlt` is the design that landed them and is the
authoritative reference for current behavior.
