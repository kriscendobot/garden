---
title: Implementation steps
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

1. `formulateGuestDependencies`: formulate a new networks directory
   and include `networksDirectoryId` in the returned identifiers.
2. `formulateNumberedGuest`: add `networks: identifiers.networksDirectoryId`
   to `GuestFormula`.
3. Guest maker: accept `networksDirectoryId`, wire as `NETS` special
   name.
4. Guest `extractLabeledDeps`: include `['networks', formula.networks]`.
