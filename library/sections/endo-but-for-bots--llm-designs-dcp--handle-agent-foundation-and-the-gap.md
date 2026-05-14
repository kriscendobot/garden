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
---

The design rests on three existing Endo primitives. Understanding them
is the prerequisite for the delegate / epithet model.

## Handle

A **Handle** (`packages/daemon/src/interfaces.js`, `HandleInterface`)
is a mailbox endpoint with two methods:

- `receive(envelope)` — accept an incoming envelope.
- `open(envelope)` — verify that the sender is who they claim to be.

The envelope protocol prevents mail fraud: a receiver calls
`E(senderHandle).open(envelope)` to confirm the sender recognizes the
envelope, catching forgeries. Every Handle has a formula identifier,
and the `handle` formula type links back to its owning agent:
`{ type: 'handle', agent: agentId }`.

## Agent

An **Agent** (Host or Guest) extends `EndoDirectory` — it *is* a
pet-name directory with mail operations. The mail methods (`send()`,
`request()`, `reply()`) take **pet-name paths** as recipients, not raw
addresses. `send("bob", ...)` resolves "bob" through the agent's
directory to a formula identifier, looks up the corresponding Handle,
and delivers via the envelope protocol. **An agent can only message
names it holds — structural confinement is already the default.**

## Pet-name directories

Each agent's directory is a NameHub. Pet names are **locally scoped
and unforgeable** — they are mappings the host writes into the agent's
pet store. An agent cannot fabricate a pet name; it can only use the
names the host has granted.

## What is missing

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
