---
title: "Cluster pattern: sentinel-with-rationale"
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node
---

The pattern *"use a deliberately-unreachable value as a sentinel,
with a rationale for why it cannot collide with valid values"* shows
up twice in the daemon design cluster:

| Design | Sentinel | Why it cannot collide |
|---|---|---|
| This design / dlt | `LOCAL_NODE = '0'.repeat(64)` for local-node component | All-zeros is not a point on the Ed25519 curve |
| The 26 formula types ([[endo-but-for-bots--llm-designs-d256--formula-types-and-security]]) | (no analogue) | n/a |

Future ingests of daemon material should record similar
"deliberately-unreachable-sentinel + rationale" pairs explicitly,
since the rationale is *what licenses* the use of the sentinel and
should not be implicit. See the **patterns** topic for related
discipline ([[endo-but-for-bots--llm-designs-dlt--local-node-sentinel]] —
stable internal id, externalized per identity).
