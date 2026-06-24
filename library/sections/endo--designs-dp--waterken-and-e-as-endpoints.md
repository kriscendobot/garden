---
title: Waterken and E as endpoints — two entangled dimensions of partition and persistence
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
kind: index
section_count: 3
---

Distributed capability systems must choose along **two entangled
dimensions**:

1. How partition and revival are presented to application programs.
2. How state is persisted across restart and upgrade.

The dimensions are entangled — choices about partition visibility
constrain persistence strategy and vice versa — but they are not the
same axis. Formula Persistence is distinctive in making a *different*
choice along each.

Sections:

- [Endpoint A: Masked partition + orthogonal persistence (Waterken)](endo--designs-dp--waterken-and-e-as-endpoints--endpoint-a-masked-partition-orthogonal-persistence-waterken.md)
- [Endpoint B: Exposed partition per reference (E)](endo--designs-dp--waterken-and-e-as-endpoints--endpoint-b-exposed-partition-per-reference-e.md)
- [The common substrate: URL-like references](endo--designs-dp--waterken-and-e-as-endpoints--the-common-substrate-url-like-references.md)
