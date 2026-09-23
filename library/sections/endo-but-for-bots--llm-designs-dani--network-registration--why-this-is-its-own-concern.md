---
title: Why this is its own concern
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

Network registration is *not* the same as peer authentication. The
OCapN-Noise handshake (see
[[endo-but-for-bots--llm-designs-ocapn-noise-network--session-establishment]])
authenticates that a peer holds a specific keypair. Registration
answers the prior question: *which of the agents on this daemon is
this inbound connection trying to reach?* The OCapN-Noise handshake
then proves that the agent is who it says it is.

This separation is the same split-by-responsibility pattern that the
daemon design cluster repeats elsewhere:

- `CryptoPowers` generates keypairs; `DaemonicPersistencePowers` stores
  them (see [[endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers]]).
- Per-agent NETS controls *which addresses are advertised* (see
  [[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]);
  network registration controls *which agent receives an inbound
  connection*.
