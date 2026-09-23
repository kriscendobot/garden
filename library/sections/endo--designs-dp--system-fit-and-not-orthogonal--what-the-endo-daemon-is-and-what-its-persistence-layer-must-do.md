---
title: What the Endo Daemon is, and what its persistence layer must do
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security]
status: current
parent: endo--designs-dp--system-fit-and-not-orthogonal
---

The Endo Daemon is a **user agent for distributed capabilities**.
Capabilities pass to peers, bots, and applications with **the user's
informed consent and the right to timely revocation** of any reference
going forward. The persistence layer has three system-level
constraints driven by that role:

### 1. Ephemeral clients and fast convergence

Nodes — especially clients — go on and offline frequently. An
ephemeral client needs to **quickly recover** access to capabilities
it was previously granted. It cannot afford to:

- Replay a transcript of prior interactions, or
- Restore a heap snapshot containing large numbers of capabilities
  unrelated to the task at hand.

Formulas solve this directly: when a client restarts, the formula
graph describes how to reconstruct **exactly the capabilities the
client needs, and only those capabilities, without replaying history.**

### 2. Retaining policy without fatiguing the user

If a user has granted a capability in a previous incarnation, **that
grant should be honored in subsequent incarnations without
re-prompting.** Repeatedly asking the user to re-authorize previously-
granted capabilities — *"harassing the user"* — erodes trust and
makes the system unusable in practice.

Formula-based retention of policy enables this: the formula graph
encodes **not just how to reconstruct a capability but the fact that
it was authorized.** When an ephemeral session is re-established, the
system can re-derive the authorized capabilities from their formulas,
restoring the user's prior policy decisions without re-confirmation.

### 3. Revocation by withdrawal of construction

The mechanism is detailed in
[[endo--designs-dp--acyclic-formula-graph-and-revocation]] — what the
system fit adds is that this revocation form *requires* a model where
the formula is the durable artifact. In Waterken-style orthogonal
persistence, there is nothing to "withdraw" except the heap object,
and the heap object is opaque to the user agent.
