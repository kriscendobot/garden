---
title: Per-agent networks — `NETS` special name on every agent
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
kind: index
section_count: 4
---

Today, `NETS` is a special name only on the **root host**. It points
to a networks directory formula, and **all child hosts created via
`formulateHost` share the same `networksDirectoryId`.** Guests have no
NETS at all.

The goal:

> *Every agent (host and guest) gets its own `NETS` special name
> pointing to its own networks directory.*

This controls which network addresses appear as connection hints in
locators produced by that agent's `locate()`, `locateForSharing()`,
`getPeerInfo()`, and `invite()`.

Sections:

- [Design](endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets--design.md)
- [Formula changes](endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets--formula-changes.md)
- [Implementation steps](endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets--implementation-steps.md)
- [What this enables](endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets--what-this-enables.md)
