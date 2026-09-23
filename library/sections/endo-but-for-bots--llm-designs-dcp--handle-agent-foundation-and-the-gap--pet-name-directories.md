---
title: Pet-name directories
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

Each agent's directory is a NameHub. Pet names are **locally scoped
and unforgeable** — they are mappings the host writes into the agent's
pet store. An agent cannot fabricate a pet name; it can only use the
names the host has granted.
