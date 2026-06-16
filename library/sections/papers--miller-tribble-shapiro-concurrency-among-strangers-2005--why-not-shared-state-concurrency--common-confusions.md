---
title: Common confusions
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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--why-not-shared-state-concurrency
---

- **"Endo must be slow because it queues everything."** The paper's §8 (Promise Pipelining) addresses this directly: pipelining lets a chain of dependent eventual-sends stream out in one network trip, so the latency model is fundamentally different from naive RPC. See [[promise-pipelining]].
- **"Surely you sometimes need synchronous calls."** Within a vat, immediate-calls (the `.` operator in E; the normal `.` in JS) are synchronous. The paper's discipline is that *cross-vat* references carry only eventual-sends; *near* references carry both. Endo's model is the same: a near reference (object in the same compartment) supports normal JS method calls; a far reference (via `E()`) supports only eventual-sends.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 197-202 (§3 The Sequential StatusHolder, §4 Why Not Shared-State Concurrency); SHA-256 `4ff0c5bd07e1`.
