---
title: See also
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_paper_pages: "215-221 (§9 Partial Failure, §10 The When-Catch Expression)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
ingested_via: orchestrator-direct-draft (subagent path twice filtered on this content)
topics: [capability-theory, eventual-send, persistence]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch
---

- [[promise-pipelining]] — §8 is the data-flow postponement mechanism; §10 when-catch is the control-flow postponement mechanism. The paper's closing line of §10 is the cleanest pairing: "Promise-chaining postpones plans efficiently by data-flow; the 'when-catch' postpones plans until the data needed for control-flow is available."
- [[formula-graph]] — the Endo equivalent of vat-checkpoint persistent reachability. The `kriskowal/endo#3121` ingest section `endo--designs-daemon-persistence--persistence-by-petname-traversal` is the direct successor.
- [[four-tables-coordinated-retention]] — Endo's swiss-number-equivalent unguessable-formula-id mechanism is the persistence-side cryptographic substrate this section's §9.2 framing motivates.
- [[caretaker-pattern]] — defensive-consistency under partition is the partial-failure analog of the access-control discipline `defensive-correctness-and-pola` covers.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — the Harel statechart this section extends to handle the broken state.
- `endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise` — the implementation-level enactment of broken-reference contagion.
