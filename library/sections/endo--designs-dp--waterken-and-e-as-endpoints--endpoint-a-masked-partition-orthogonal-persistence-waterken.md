---
title: "Endpoint A: Masked partition + orthogonal persistence (Waterken)"
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

Tyler Close's **Waterken server** masks partition and revival from
application code. All loss of connectivity is treated as temporary; a
program never observes a broken reference and simply waits. Waterken
pairs Joe-E (a capability-safe Java subset) with a live crypto-cap
protocol in the CapTP family, and uses **orthogonal persistence** to
snapshot the heap and restart from that snapshot — possibly on a
different host — without the program's knowledge.

| | |
|---|---|
| **Advantages** | Simpler programming model (no defensive code against partition); determinism across communicating programs; transparent relocation |
| **Disadvantages** | Sacrifices availability — a single partitioned dependency stalls all dependents; entangled distributed heaps require **distributed garbage collection**; different participant incentives motivate market-based GC algorithms (Drexler & Miller 1988); upgrading programs in flight is difficult because the heap snapshot encodes assumptions an upgrade may violate |
