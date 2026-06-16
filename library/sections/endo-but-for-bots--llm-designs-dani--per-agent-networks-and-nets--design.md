---
title: Design
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

1. **Root agent startup.** The root host's NETS directory is the only
   one whose networks are pinned and started on daemon startup — the
   `endo` formula references `networks`. **This is unchanged.**
2. **Agent incarnation.** When *any* agent (host or guest) is
   incarnated, the daemon formulates a new networks directory and
   wires it as the agent's `NETS` special name. The guest formula
   gains a `networks` field (currently absent).
3. **Default contents.** A newly created agent's NETS directory
   starts **empty**. The creating host can populate it (e.g., by
   copying network references from its own NETS) or leave it empty if
   the agent should not be directly reachable.
4. **Connection hint resolution.**
   `getAllNetworkAddresses(networksDirectoryId)` already accepts a
   per-directory ID — the host passes its own `networksDirectoryId`
   to `locateForSharing`, `getPeerInfo`, and invitation construction.
   No change is needed in the resolution path — only in how the
   directory ID is provisioned.
5. **Persona privacy.** An agent with an empty NETS produces locators
   *without* connection hints. Peers must already know how to reach
   the daemon through other means (e.g., they received hints from a
   different agent). **This is the foundation for anonymizing
   personas that never reveal direct addresses.**
