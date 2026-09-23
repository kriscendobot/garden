---
title: Why this design exists separately
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **followup** to [[endo-but-for-bots--llm-designs-daemon-256-bit-identifiers]] — was originally that document's *"Future Work"* section, split out as a sibling design once the work grew. Two of its four work items have since shipped via the locator-terminology rename ([[endo-but-for-bots--llm-designs-daemon-locator-terminology]]); the other two — *per-agent networks (NETS)* and *network registration* — are still **In Progress**.
parent: endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt
---

> *This was originally the "Future Work" section of
> [`daemon-256-bit-identifiers`](daemon-256-bit-identifiers.md).*

It was split out when the network-registration and per-agent-NETS
pieces grew large enough to warrant their own design treatment. The
naming of the four items together preserves the *coherence of the
integration program* even as individual items land in separate PRs.
