---
title: Agent
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

An **Agent** (Host or Guest) extends `EndoDirectory` — it *is* a
pet-name directory with mail operations. The mail methods (`send()`,
`request()`, `reply()`) take **pet-name paths** as recipients, not raw
addresses. `send("bob", ...)` resolves "bob" through the agent's
directory to a formula identifier, looks up the corresponding Handle,
and delivers via the envelope protocol. **An agent can only message
names it holds — structural confinement is already the default.**
