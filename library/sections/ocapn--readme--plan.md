---
title: What's the plan?
source: README.md
source_repo: kriscendobot/ocapn
source_commit: 482d9cc9845a6580840711e518d71b4e27a2dcaf
source_date: 2025-07-10
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn]
status: current
---

> Abstract: Roadmap section: planned spec maturation milestones, anticipated implementations, areas where the spec is still evolving (locators and netlayers were both draft as of the cycle 18 ingestion).

## What's the plan?

Different recent implementations have brought different things to the
table in terms of their implementations:

 - [Spritely](https://spritelyproject.org/)
   has the most pieces of CapTP (including distributed
   acyclic GC, handoffs) and the start of the "netlayer" abstractions
   and URI concepts.

 - [Agoric](https://agoric.com/)
   has been working to figure out how to do the work to treat
   blockchains as ordinary machines supporting distributed objects on
   the network using [IBC](https://ibcprotocol.org/)
   (and has most of the engineering talent who have implemented
   CapTP historically).

 - [Cap'N Proto](https://capnproto.org/) has an efficient implementation
   of CapTP with some different choices around memory management than
   the other two.
   Can this be merged with the other two approaches?
   We don't know yet... watch this space!

The plan is to get at least Agoric and Spritely's implementations
interoperable first before considering interoperability with Cap'N
Proto and before beginning any discussion of standardization.

For expedience, this repository is usually using Spritely's
implementation as the "jumping off point" for discussion, but pulling
in details from the other two implementations to seek unification.
This should not be interpreted as a value judgement about the quality
of implementations, but rather that at the time of writing since
Spritely has the most features, it's the easiest place to start
talking from.


Source: `README.md` at commit `482d9cc9` (held at kriscendobot/ocapn).
