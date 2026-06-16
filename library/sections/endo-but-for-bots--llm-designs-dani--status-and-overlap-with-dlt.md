---
title: Status and overlap with daemon-locator-terminology — what's done, what's pending
source: designs/daemon-agent-network-identity.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5ab5e48d80c5d925bcec2d142606d7555bfad7ed
source_date: 2026-03-18
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **followup** to [[endo-but-for-bots--llm-designs-daemon-256-bit-identifiers]] — was originally that document's *"Future Work"* section, split out as a sibling design once the work grew. Two of its four work items have since shipped via the locator-terminology rename ([[endo-but-for-bots--llm-designs-daemon-locator-terminology]]); the other two — *per-agent networks (NETS)* and *network registration* — are still **In Progress**.
kind: index
section_count: 3
---

This design is the *integration layer* between the 256-bit identifier
migration ([[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]])
and the network protocol layer. d256 *gave every agent its own
keypair*; this design wires those keypairs into the network and
locator systems.

Sections:

- [Four work items](endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt--four-work-items.md)
- [Why this design exists separately](endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt--why-this-design-exists-separately.md)
- [Position in the daemon design cluster](endo-but-for-bots--llm-designs-dani--status-and-overlap-with-dlt--position-in-the-daemon-design-cluster.md)
