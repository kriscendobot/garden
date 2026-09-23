---
title: Network registration — `registerAgentKey` so the network layer can route inbound connections
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, ocapn, capability-security]
status: current
kind: index
section_count: 5
---

Once a daemon hosts multiple agents, each with its own Ed25519
keypair, **the network layer needs to know which agent an inbound
connection is targeting.** A remote peer connects with a specific
public key in mind; without registration, the network has no way to
route the connection.

Sections:

- [Registration flow](endo-but-for-bots--llm-designs-dani--network-registration--registration-flow.md)
- [Interface](endo-but-for-bots--llm-designs-dani--network-registration--interface.md)
- [Why this is its own concern](endo-but-for-bots--llm-designs-dani--network-registration--why-this-is-its-own-concern.md)
- [Dependencies](endo-but-for-bots--llm-designs-dani--network-registration--dependencies.md)
- [See also](endo-but-for-bots--llm-designs-dani--network-registration--see-also.md)
