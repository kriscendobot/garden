---
title: See also
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

- [[per-agent-keypair]] — the cryptographic substrate this registration interface routes against.
- [[delegates-and-epithets]] — agents that need network registration are precisely the agents that may carry epithets and present verifiable identity claims.
- [[caretaker-pattern]] — `registerAgentKey` is *additive* on the `EndoNetwork` interface; networks without multi-key support ignore the calls — the same backward-compatible-extension shape as `dlt`'s method-additions discipline.
