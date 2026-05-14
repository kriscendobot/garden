---
title: What do I get from using this?
source: README.md
source_repo: kriscendobot/ocapn
source_commit: 482d9cc9845a6580840711e518d71b4e27a2dcaf
source_date: 2025-07-10
source_authors: [Jessica Tallon]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, capability-security]
status: current
---

> Abstract: Motivation section: the properties using the protocol gets you (capability-secure messaging across mutually-suspicious peers, language-agnostic interop, the network-of-vats programming model). Aimed at potential adopters.

## What do I get from using this?

You get:

 - A general distributed communication API.

 - In host language environments which follow the object capability
   security paradigm (**TODO:** link which writeup?), programmers can
   write networked systems with security properties that are easily
   reasoned about.  The abstraction gain of having this layer
   generalized is similar to the gains of having TCP and TLS be
   general layers that each program does not have to re-implement:
   programmers can focus on the particular details that are relevant
   to their particular program.

 - Distributed (acyclic) garbage collection.
   Peers can cooperate to inform each other when they no longer need
   references across the network.

 - Network layers supporting live connections (tcp-like), store and
   forward networks, and even communication between blockchains.

 - The abstraction of machines on the network supports both
   traditional single-hardware-unit computers, quorums of machines
   running the same abstracted machine, or blockchains with
   global-scale consensus.

 - [Promise pipelining!](http://www.erights.org/elib/distrib/pipeline.html)

   > Machines grow faster and memories grow larger.
   > But the speed of light is constant and New York is not getting any"
   > closer to Tokyo.
   >
   >   -- [Mark S. Miller's dissertation](http://www.erights.org/talks/thesis/)
   >      explaining the value of promise pipelining

(Why distributed *acyclic* GC?
[Distributed cyclic garbage collection](http://erights.org/history/original-e/dgc/)
was implemented in the pre-open-source version of E.
However, it requires special hooks into the garbage collector, whereas
distributed *acyclic* gc merely requires weakrefs, weakmaps, and
finalizers.)


Source: `README.md` at commit `482d9cc9` (held at kriscendobot/ocapn).
