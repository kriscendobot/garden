---
title: "Endpoint B: Exposed partition per reference (E)"
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [persistence, capability-security, captp]
status: current
notes: Background framing for the Formula Persistence design. See [[endo--designs-dp--frame-and-position-in-design-space]] for the resulting position in the design space.
parent: endo--designs-dp--waterken-and-e-as-endpoints
---

Mark Miller's **E** language exposes partition and revival at every
individual reference. A program is written so that any dereference or
message send to a potentially remote reference might fail; recovery
requires reconstructing the chain of computation that led to the
broken reference after partition heals.

| | |
|---|---|
| **Advantages** | Simpler runtime; does not sacrifice availability to Waterken's extent; no obligation to retain "offline capabilities" indefinitely (sturdyrefs and out-of-band URL-like references are necessarily weak references; sturdyrefs additionally enable *distributed confinement* without revealing cryptographic material to a multi-peer confined program) |
| **Disadvantages** | More complex programming model — every dependent computation must handle mid-process recovery defensively |
