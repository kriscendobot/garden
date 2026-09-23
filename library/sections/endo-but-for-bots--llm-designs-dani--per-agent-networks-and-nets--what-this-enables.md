---
title: What this enables
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets
---

The per-agent NETS is the **identity / advertisement** half of the
persona problem. It pairs with the per-agent keypair from
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] to give
each agent independent control over:

- **Who reaches me** — the keypair (cryptographic identity).
- **How to reach me** — the NETS contents (advertised transports).

Two different agents on the same daemon can present completely
different network footprints — one pseudonymous-via-relay-only,
another publicly-direct-TCP-reachable — while sharing the same
underlying daemon process.

See
[[endo-but-for-bots--llm-designs-dani--per-agent-connection-hints-and-null-local-node]]
for the connection-hint policy layer that complements the NETS-as-set
of-addresses choice. See
[[endo-but-for-bots--llm-designs-dani--network-registration]] for
how the network layer routes inbound connections to the right agent
once multiple agents share a daemon.
