---
title: Make/Define vs Prepare
source: packages/exo/docs/exo-taxonomy.md
source_repo: endojs/endo
source_commit: 01ba3f7d57c9
source_date: 2023-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, daemon, persistence]
status: current
---

> Abstract: The third axis (durable-variant only). make/define functions create new state on each call; prepare functions retrieve previously-defined classes from a baggage capability. The prepare form is what allows code to survive a process restart: on restart, prepareDurableExoClass re-hydrates the class from baggage rather than creating a fresh definition.

## Make/Define vs Prepare

"prepare" is like "provide" in that it defines something that should be in the baggage, using the one that is there if found, but otherwise making a new one and registering it, so that the successor vat-invocation will find it at the same place in the baggage. Unlike "provide", for each exo behavior already in the baggage, one must call "prepare" immediately --- during the first crank of the vat incarnation. What is passed in baggage is only the state of the durable objects. Only the `prepare*` calls associate that state with code, giving it behavior. All these objects must be prepared early, so they know how to react when they receive messages.

- `prepareExo`:
  Each call returns a durable exo in baggage, creating it first if necessary.
- `prepareExoClass`:
  Each call returns a "make" function for the durable exo class in baggage, creating it first if necessary.
- `prepareExoClassKit`:
  Each call returns a "makeKit" function for the durable exo class kit in baggage, creating it first if necessary.


Source: [packages/exo/docs/exo-taxonomy.md](https://github.com/endojs/endo/blob/01ba3f7d57c9/packages/exo/docs/exo-taxonomy.md) at commit `01ba3f7d`.
