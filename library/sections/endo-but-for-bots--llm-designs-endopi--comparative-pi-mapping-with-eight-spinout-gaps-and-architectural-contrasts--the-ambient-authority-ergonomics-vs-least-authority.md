---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: The *ambient authority + ergonomics* vs *least authority +
parent: endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
---

auditable structure* worldview

The §Architecture Comparison table is the design's load-bearing
frame. Twelve rows contrast Pi and Endo on Runtime / Embedding /
Agent shape / Tool model / Capability model / Provider model /
Persistence / Branching / Compaction / Extensions / Skills /
Distribution / Security. The single most structurally interesting
row is the *Capability model* contrast:

- **Pi**: *Ambient authority + opt-in container/sandbox*
- **Endo**: *Object-capability (agent holds only granted caps)*

The §Architectural Contrasts section near the end (§Capability
model, §Persistence, §Extensibility, §Security, §Agent-orchestration
shape) makes the contrast explicit: Pi takes the *ergonomic path*
(the agent's process *is* the user's process; safety is *review
extensions before installing*, *run pi in a container*, or *write a
permission-gate extension*); Endo *inverts the default* — the agent
receives a `Dir(/path/to/project)` and a `Shell({allowed: [...]})`
and **cannot name** anything outside.

The bet of Endo: *capability confinement will pay off when agents
act on behalf of users who cannot evaluate the agent's source code*.
