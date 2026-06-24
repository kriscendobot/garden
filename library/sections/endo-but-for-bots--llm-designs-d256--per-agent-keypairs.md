---
title: Per-agent keypairs — KeypairFormula, agent integration, and the `@keypair` special name
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence, agent-conventions]
status: current
kind: index
section_count: 5
---

Beyond the daemon's *root* keypair, **each host and guest agent has
its own Ed25519 keypair**, stored as a `keypair` formula in the formula
graph. This puts agent identities on the same footing as every other
durable artifact the daemon manages.

Sections:

- [`KeypairFormula`](endo-but-for-bots--llm-designs-d256--per-agent-keypairs--keypairformula.md)
- [Agent formula updates](endo-but-for-bots--llm-designs-d256--per-agent-keypairs--agent-formula-updates.md)
- [Formulation flow](endo-but-for-bots--llm-designs-d256--per-agent-keypairs--formulation-flow.md)
- [`@keypair` as a special name](endo-but-for-bots--llm-designs-d256--per-agent-keypairs--keypair-as-a-special-name.md)
- [See also](endo-but-for-bots--llm-designs-d256--per-agent-keypairs--see-also.md)
