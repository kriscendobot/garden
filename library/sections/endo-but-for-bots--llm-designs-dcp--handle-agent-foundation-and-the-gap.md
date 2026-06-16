---
title: Handle/Agent foundation and the gap that delegates fill
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, agent-conventions]
status: current
notes: The internal title of this design is *"Delegates and Epithets: Ideas and Directions"* — the filename says `daemon-capability-persona` but the document is broader than persona-as-OS-user. Status **Not Started** upstream as of 2026-02-24. Builds on the per-agent keypair work ([[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]) and the per-agent NETS work ([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]) — both supply *who-am-I* affordances that this design uses as the substrate for *who-am-I-relative-to-whom*.
kind: index
section_count: 4
---

The design rests on three existing Endo primitives. Understanding them
is the prerequisite for the delegate / epithet model.

Sections:

- [Handle](endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap--handle.md)
- [Agent](endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap--agent.md)
- [Pet-name directories](endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap--pet-name-directories.md)
- [What is missing](endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap--what-is-missing.md)
