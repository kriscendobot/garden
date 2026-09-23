---
title: Translation block (E idiom → Endo / JavaScript surface)
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

| E construct                          | Endo / JavaScript equivalent                                                                 |
| ------------------------------------ | -------------------------------------------------------------------------------------------- |
| `_whenBroken(handler)`               | `.catch(handler)` on a Promise, or `E.when(promise, onResolved, onRejected)` on `eventual-send` |
| `_whenMoreResolved(handler)`         | `.then(handler)` on a Promise (handler is also called on rejection if no catch chained)      |
| `_reactToLostClient(exception)`      | **No direct counterpart in Endo.** The target end is not notified of severed remote-client connections; CapTP closes the connection but doesn't fire a per-object hook. |
| `when (promise) -> {...} catch ex {...}` | `E.when(promise, val => {...}, ex => {...})`, or equivalently `promise.then(val => {...}, ex => {...})` |
| `captp://...` URI                    | The CapTP URI scheme is preserved in OCapN's wire form. Endo's persistent capabilities live in the petname graph and are addressed by formula identifier rather than URI string in everyday use. |
| `SturdyRef`                          | Endo's persistent capability / formula handle — a serializable reference that survives reconnection and re-establishes a live reference through the daemon. |
| `swiss-number`                       | The unguessable random portion of an Endo formula identifier. |
| vat checkpoint                       | The Endo daemon's content store + petname graph + formula-graph persistence. Endo persists eagerly per-mutation rather than only at turn boundaries, but the conceptual unit (persistent reachability via traversal from a root) is identical. |
| vat incarnation                      | A restarted Endo daemon process (or bundle restart). The persistent identity is the keypair; the in-memory state is rebuilt by hydrating from the formula graph. |
