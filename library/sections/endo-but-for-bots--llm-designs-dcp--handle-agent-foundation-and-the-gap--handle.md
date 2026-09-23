---
title: Handle
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
notes: The internal title of this design is *"Delegates and Epithets: Ideas and Directions"* — the filename says `daemon-capability-persona` but the document is broader than persona-as-OS-user. Status **Not Started** upstream as of 2026-02-24. Builds on the per-agent keypair work ([[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]) and the per-agent NETS work ([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]) — both supply *who-am-I* affordances that this design uses as the substrate for *who-am-I-relative-to-whom*.
parent: endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap
---

A **Handle** (`packages/daemon/src/interfaces.js`, `HandleInterface`)
is a mailbox endpoint with two methods:

- `receive(envelope)` — accept an incoming envelope.
- `open(envelope)` — verify that the sender is who they claim to be.

The envelope protocol prevents mail fraud: a receiver calls
`E(senderHandle).open(envelope)` to confirm the sender recognizes the
envelope, catching forgeries. Every Handle has a formula identifier,
and the `handle` formula type links back to its owning agent:
`{ type: 'handle', agent: agentId }`.
