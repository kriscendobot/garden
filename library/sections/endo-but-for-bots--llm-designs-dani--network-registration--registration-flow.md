---
title: Registration flow
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

> *Each installed network (accessible through the NETS formula) needs
> to know the public keys of all active agents so the network layer
> can accept and negotiate connections on behalf of any persona.*

1. **On agent creation**, the daemon registers that agent's public
   key with *every installed network*.
2. **Each agent tracks its own set of retained agents** (via its pet
   store) and maintains the list of known keys for each installed
   network *incrementally*.
3. **On inbound connection**, the network identifies the target local
   agent by matching the target public key against its registry.
