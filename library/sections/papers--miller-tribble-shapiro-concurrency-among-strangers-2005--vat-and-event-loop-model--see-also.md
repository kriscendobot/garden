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
topics: [capability-theory, eventual-send, compartments]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model
---

- [[vat-and-compartment]] — new concept this cycle pinning the paper's vat to Endo's compartment + bundle (with the per-agent / per-vat keypair distinction documented).
- [[eventual-send]] — the topic page cataloging Endo's API surface for the paper's `<-` operator.
- [[promise-pipelining]] — the next section; pipelining over the eventual-references this section introduces.
- [[formula-graph]] — Endo's persistence model, divergent from the paper's vat-as-persistence-unit framing.
- [[four-tables-coordinated-retention]] — Endo's later refinement of the cross-vat retention story (the paper's §9.3 persistence-by-traversal is the upstream).
- [`endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find`](endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) — **implementation rationale for an eventual-reference chain.** The paper's *eventual reference* abstraction becomes a forwarded `HandledPromise` in the shim; the forwarding-forest section explains how Endo keeps long chains of forwarded eventual references cheap to resolve. Theory (this section) ↔ implementation (that section).
- [`endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly`](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) — **the operational reduction that makes pipelining mechanical.** The paper introduces eventual-send as a primitive; the operation-reduction section shows how applyMethod-via-get-plus-applyFunction makes pipelining emerge from the dispatcher's reductions even without a separate pipelining primitive.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
