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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--abstract-and-introduction
---

- [[eventual-send]] — the topic page collecting Endo API sections about `E()`, `HandledPromise`, and the `<-` semantics this paper introduces.
- [[vat-and-compartment]] — new concept this cycle pinning the paper-side *vat* to Endo's *compartment* + *bundle* isolation unit.
- [[promise-pipelining]] — new concept this cycle covering §8's argument that pipelining is the latency-reducing mechanism at the core of `E()`-chains.
- [[papers--miller-capability-myths-demolished-2003]] — the cited companion paper (MYS03) that grounds the security model this paper's concurrency model operationalizes.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 195-197 (Abstract, §1 Introduction, §2 Overview); SHA-256 `4ff0c5bd07e1`.
