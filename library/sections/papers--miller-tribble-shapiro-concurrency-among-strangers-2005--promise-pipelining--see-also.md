---
title: See also
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, eventual-send]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining
---

- [[promise-pipelining]] — the concept page; this section is the theoretical anchor, the cycle-66 `handled-promise.js` ingest provides the mechanical anchor.
- [[vat-and-compartment]] — pipelining is meaningful only because vats are isolated; the *answer-slot-reference* arrow makes sense exactly because near references cannot cross vat boundaries.
- [[four-tables-coordinated-retention]] — Endo's later retention-graph machinery is what makes pipelined answer-slot references retainable across vat boundaries.
- [`endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly`](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) — **mechanical complement.** The dispatcher reduction that makes pipelining emerge from the shim's `applyMethod` / `get` / `applyFunction` decomposition.
- [`endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find`](endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) — **why deep pipelined chains stay cheap.** Path-splitting in the forwarding-graph keeps long chains from forming a linear retention list.
- [`endo--pkg-eventual-send-readme--promise-pipelining`](endo--pkg-eventual-send-readme--promise-pipelining.md) — Endo's user-facing description of the same mechanism.
- [`ocapn--implementation-guide--stage-4-promise-pipelining`](ocapn--implementation-guide--stage-4-promise-pipelining.md) — the upstream protocol's Stage 4 milestone; the wire form of an answer-slot reference.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
