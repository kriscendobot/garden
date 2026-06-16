---
title: Implications for Endo
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

This section is the architectural blueprint for everything Endo does at the partition-tolerance and persistence layer. Specifically:

1. **Broken-reference state, terminal.** Endo's HandledPromise inherits this: a rejected handled-promise stays rejected; subsequent `E()` sends to a rejected promise produce rejected promises with the same rejection (broken-reference contagion). The cycle-66 `endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise` section is the implementation-level enactment of this paper's §8.5 broken-promise-contagion argument.
2. **Persistence by traversal from roots.** Endo's daemon-persistence design (the formula-graph) is the direct successor: the petname graph names the roots, the formula graph names the persistent structure reachable by traversal, and unreachable formulas are eligible for collection. The cycle-47 ingest of `endojs/endo#3121` (the Formula Persistence design draft) traces this lineage explicitly.
3. **Crash-as-partition.** Endo daemon restarts are conceptually identical to E's vat revival from checkpoint. Bundles outside the daemon are partitioned-and-revived in the same step; references to them stored at checkpoint time would be revived as broken in the strict E model. Endo's actual reconnection logic re-establishes by formula-id lookup, which is the Endo enactment of "only offline capabilities in either direction enable reconnection."
4. **No `_reactToLostClient` analog.** This is a *gap* in the Endo surface relative to the paper. The §9 design assumed the target-side notification was a valuable signal; Endo doesn't currently surface it. Whether this gap matters in practice depends on whether per-object cleanup hooks on remote-client-loss would change architecture decisions — a question worth a future designer note.
5. **When-catch is JavaScript's Promise.then.** Endo inherits when-catch for free from the host language; the mechanism is identical. Endo's `E.when(p, onResolved, onRejected)` is the canonical surface and is precisely the paper's `when (...) -> {...} catch ex {...}`.
