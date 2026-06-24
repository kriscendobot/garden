---
title: Position in the daemon design cluster
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

| Design | Layer | What it adds |
|---|---|---|
| `d256` | identifier primitives | 256-bit IDs; Ed25519 as node ID; per-agent keypair formula |
| `dani` *(this)* | identity → network integration | NETS per agent; network-registration interface; **origin** of LOCAL_NODE sentinel |
| `dlt` | locator URL format | `endo://{peerKey}/{addr}@{hint}` URLs; landed the LOCAL_NODE sentinel; dehydrate/hydrate split |
| `dcpg` | cross-peer protocol | one-way retention set per peer; uses Ed25519 public key as peer index |
| `dp` (PR #3121) | thesis | Formula Persistence model that the above all serve |

See [[endo-but-for-bots--llm-designs-d256--problem-and-original-state]]
for the parent design and
[[endo-but-for-bots--llm-designs-dlt--terminology-rename]] for the
naming layer.
