---
source_kind: web-essay
source_url: https://habitat-chronicles.com/2019/08/the-unum-pattern/
source_content_sha256: 7d099818689a2f196889f1602187a7c6a79110e80f1baa7c4a2bab88952e81dd
source_author: Chip Morningstar
source_date: 2019-08-28
retrieved: 2026-07-11
ingested: 2026-07-11
ingested_by: scholar
section_count: 7
status: current
notes: |
  First ingest from **habitat-chronicles.com** (the dashed live domain; the
  non-dashed `habitatchronicles.com` is STALE/dead — always cite the dashed
  form). Chip Morningstar & Randy Farmer's blog on virtual worlds, distributed
  systems, and object-capability history. This essay, authored by Chip, is the
  canonical writeup of the **unum** distributed-object pattern — the primary
  reason for the ingest (maintainer job `scholar-ingest-source-habitat-chronicles`).
  Fetched live (`source_fetched_via=direct`); the content hash is the idempotency
  anchor. NOT to be confused with the library's other `unum` source
  (`sources/unum.md`), which is jcorbin's unrelated task-queue monorepo. A
  follow-on `scholar-ingest-source-habitat-chronicles` job carries the rest of the
  germane blog set (What Are Capabilities?, A Slightly Skeptical Perspective on
  REST, the Tripartite Identity Pattern, Adventures in LLM Land, and others).
---

## Abstract

Chip Morningstar's canonical writeup of the **unum pattern**: a design pattern for
**distributed objects that are themselves distributed entities**. A unum (Latin, "a
single thing") is a world-level object — the teacup on a table in a virtual room —
whose identity is distinct from the OOP objects that realize it; the portion living
on each machine is a **presence**, and presences are factored not as master/replica
but by a **division of labor**, each authoritative about different aspects and each
holding private state. The essay develops the unum/object distinction, the presence
abstraction, message addressing over **vats** and channels, the client/server
asymmetry, the four codified messaging patterns (**Reply, Neighbor, Broadcast,
Point**), why unum protocols are **behavioral (anti-REST)** rather than
data-replication, and the open research directions — alternate divisions of labor,
per-unum client/server authority (Electric Communities), and the **containership
problem**. Roots trace to Lucasfilm *Habitat* (1985–86) and carry forward into the
**Elko** server framework and Electric Communities' capability-secure distributed
world. Highly germane to the garden's ocap / distributed-object lineage (the E-vat
model, `@endo` presences and remotables, ocapn).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [The Unum Pattern — overview and origin](../sections/habitat-chronicles--unum-pattern--overview.md) | distributed-objects | current |
| [Unum vs. object — two planes of existence](../sections/habitat-chronicles--unum-pattern--unum-vs-object-two-planes.md) | distributed-objects | current |
| [Presences and division of labor (not master/replica)](../sections/habitat-chronicles--unum-pattern--presences-and-division-of-labor.md) | distributed-objects, change-propagation | current |
| [Addressing a unum — presences, vats, and message channels](../sections/habitat-chronicles--unum-pattern--addressing-presences-vats-and-channels.md) | distributed-objects, capability-theory | current |
| [The four messaging patterns — Reply, Neighbor, Broadcast, Point](../sections/habitat-chronicles--unum-pattern--four-messaging-patterns.md) | distributed-objects, change-propagation | current |
| [Behavioral (not data) protocols — why the unum is anti-REST](../sections/habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) | distributed-objects, networking | current |
| [Other divisions of labor, per-unum authority, and the containership problem](../sections/habitat-chronicles--unum-pattern--other-divisions-of-labor-and-containership.md) | distributed-objects, capability-theory | current |
