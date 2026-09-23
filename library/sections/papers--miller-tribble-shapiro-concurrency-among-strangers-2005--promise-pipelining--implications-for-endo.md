---
title: Implications for Endo
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

The paper's promise-pipelining argument is the **upstream of `@endo/eventual-send`'s pipelining behavior** and the **theoretical motivation** for the comment-fragment ingest of cycle 66 (`endo--packages-eventual-send-src-handled-promise-js--*`). Three concrete pinnings:

1. **The mechanical implementation is `applyMethod` reduction + the forwarding-graph.** The cycle-66 ingest of `handled-promise.js` shows the *mechanical* path: pipelining emerges from `dispatchToHandler`'s reduction of `applyMethod` into `get` followed by `applyFunction`, threading an intermediate `HandledPromise` whose pending handler is the same as the outer chain's; the second sub-operation queues against that pending state. This *paper section* is the theoretical motivation; the *handled-promise.js section* is the mechanical realization. Both anchor onto the [[promise-pipelining]] concept page.

2. **CapTP's `<desc:answer>` wire form is the network realization.** The paper's three-vat geometry (the `c(r2)` arrow that follows wherever `r1` resolves) is exactly the *forward-the-answer-slot-reference* discipline that CapTP's `<desc:answer answer-pos>` enables. Endo's `packages/captp/README.md` already names this; the paper grounds it in the latency argument.

3. **Broken-reference contagion → HandledPromise rejection contagion.** Endo inherits the design: a rejected HandledPromise eventual-sent to with `E(...)` yields a rejected HandledPromise without throwing. The "split between control-flow and data-flow exceptions" maps onto JS's `await` (control-flow throw at the await point) vs `.then(...)` / `E(...)` (data-flow rejection propagation).

A *substantive divergence* worth a future investigation: the paper's **broken-reference state is terminal** — once a reference is broken, it stays broken; sending to it any number of times always yields a broken promise. Modern JS Promise semantics (and Endo's HandledPromise built on them) honor this: a rejected promise stays rejected, and chaining off a rejected promise propagates rejection. The shape matches; the formal-correspondence claim is solid.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
