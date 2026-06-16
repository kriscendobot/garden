---
title: Dependencies
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, ocapn, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-dani--network-registration
---

This work depends on two prior designs:

- [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] —
  provides the per-agent Ed25519 keypairs.
- [`ocapn-network-transport-separation`](endo-but-for-bots--llm-designs-ntsep--design-conceptual-model)
  — the network abstraction layer that will implement
  `registerAgentKey`. (See the ntsep design's conceptual-model
  section for the four-layer OCapN hierarchy that this interface
  lives in.)

It is also blocked on
[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]
because the *agents to register keys for* are discovered via the
agent's NETS membership, not via a daemon-wide registry.
