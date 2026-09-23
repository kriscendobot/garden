---
title: The 26 formula types
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
parent: endo-but-for-bots--llm-designs-d256--formula-types-and-security
---

The migration listed the complete set of formula types as a stable
reference for the cluster. From `formula-type.js`:

`directory`, `endo`, `eval`, `guest`, `handle`, `host`, `invitation`,
**`keypair`**, `known-peers-store`, `least-authority`, `lookup`,
`loopback-network`, `mail-hub`, `mailbox-store`, `make-bundle`,
`make-unconfined`, `marshal`, `message`, `peer`, `pet-inspector`,
`pet-store`, `promise`, `readable-blob`, `resolver`, `worker`.

That is 25 names + `eval` listed twice in the source's bulleted form,
totalling 26 formula types in the post-migration daemon (the design
text says "26"). The newly-added one in this migration is **`keypair`**
(see [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]).

This list is the **formula-type taxonomy** that every other daemon
design implicitly references when speaking of "a formula":

- Identity / agency: `host`, `guest`, `handle`, `keypair`, `peer`.
- Naming / lookup: `pet-store`, `pet-inspector`, `lookup`, `directory`,
  `known-peers-store`.
- Messaging: `mailbox-store`, `mail-hub`, `message`, `invitation`.
- Execution: `worker`, `eval`, `make-bundle`, `make-unconfined`,
  `marshal`.
- Promises: `promise`, `resolver`.
- Content: `readable-blob`.
- Network: `loopback-network` (and other network types arriving later).
- Policy: `least-authority`.
- Root: `endo`.

Future cycles ingesting daemon designs should cross-reference this
list when introducing new types; e.g., the `retention-set` and the
`network` formula types added by later designs extend this taxonomy.
