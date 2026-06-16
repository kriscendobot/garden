---
title: What is missing
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

Today, a Handle is **opaque**. You can send it mail and verify that
mail came from it, but you cannot ask it anything *about itself*.
There is no way for Bob to ask Aifred's Handle "who are you?" or
"what is your relationship to Alice?" And even if Aifred's Handle
self-reported a relationship, the claim would be unverifiable —
**Aifred could lie**.

The delegate / epithet model fills this gap by structurally attaching
a verifiable relationship-to-principal claim to the Handle itself, so
Bob can:

1. Read the claim directly from Aifred's Handle (no trust in Aifred
   required).
2. Verify the claim by asking the principal's Handle directly (no
   trust in any intermediary required).

See
[[endo-but-for-bots--llm-designs-dcp--delegates-and-epithets]] for the
core idea and
[[endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions]]
for the verification protocol.
