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
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining
---

- **"Pipelining is just `Promise.all`."** No. `Promise.all` waits for a set of *independent* promises to resolve locally. Pipelining is about *dependent* promises whose dependencies are themselves remote sends, and about routing subsequent sends to the *remote* side's answer slot before any local resolution has happened. See the concept page [[promise-pipelining]].
- **"`<-` chains are sequential like `.then(...)` chains."** Not on the wire. A `.then(...)` chain serializes data-flow but each `.then` runs only after the previous resolves *locally*. A pipelined `<-` chain streams the dependent messages to the remote *before* the first resolves locally; the dependent message's arrival at the remote may even precede the first's resolution returning to the local vat.
- **"Datalock means the runtime deadlocks."** No. Datalock means a particular *promise* never resolves. Other plans in the vat continue. The vat's turn-by-turn execution model is preserved; only the specific data dependency that participates in the cycle hangs. Datalock is a *bug* in the dependent plan, not a system-level failure.
- **"Broken-promise contagion is like exception propagation."** Partially. Both propagate exceptions, but exception propagation terminates the *caller's* control flow whereas broken-promise contagion propagates through the *data-flow graph* without unwinding the caller's stack. The paper's IEEE-754 NaN analogy is the right mental model: NaN arithmetic propagates NaN to dependent computations without raising a signal.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
