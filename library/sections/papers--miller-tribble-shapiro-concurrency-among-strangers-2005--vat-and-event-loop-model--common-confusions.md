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
topics: [capability-theory, eventual-send, compartments]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model
---

- **"`<-` looks like Erlang's `!`."** Both are message-send operators in concurrent languages, but Erlang's `!` sends to a process mailbox (no return value, no promise). E's `<-` returns a promise for the eventual result; this is the foundation §8 builds promise-pipelining on. Erlang has no analogous concept.
- **"Isn't a vat just a process?"** The paper distinguishes them. A vat is the language-level isolation unit; a process is the OS-level unit. One machine can host many vats; one vat lives on one machine at a time but can *migrate* between machines (§6 names vats as "the minimum unit of migration"). Modern Endo collapses these levels: an Endo daemon is one OS process hosting many compartments, each of which is one vat in the paper's sense.
- **"Doesn't `await E(...)` make it synchronous?"** No. `await` yields control to the event loop until the promise resolves; the calling code becomes a separate turn at each `await` point. The paper's turn semantics translate directly to JS `await` semantics.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 202-207 (§5 A Taste of E, §6 Communicating Event-Loops); SHA-256 `4ff0c5bd07e1`.
