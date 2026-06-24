---
title: Translation
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

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| promise | a `HandledPromise` in Endo's `@endo/eventual-send` shim; user-visible as a JS `Promise` but interceptable by the handler protocol |
| resolver | the `resolve` callback paired with the promise; in Endo: the second element of a `HandledPromise` constructed via `new HandledPromise(executor, unfulfilledHandler)` |
| pipelining over multiple vats | works the same way over CapTP: a pipelined `E(E(remote).foo()).bar()` ships both messages with the `<desc:answer answer-pos>` wire form |
| `def r3 := x <- a() <- c(y <- b())` | `E(E(x).a()).c(E(y).b())` (or, more typically split across lines for readability) |
| broken reference | a rejected promise in JS terms — but Endo's HandledPromise rejection contagion mirrors the paper's broken-reference contagion exactly: an eventual-send to a rejected HandledPromise produces a rejected HandledPromise |
| immediate-call on broken reference | `await rejectedPromise` throws the rejection at the await point (JS's await contract); eager `.then(...)` propagates as data-flow rejection (no immediate throw) — the paper's control-flow / data-flow split is approximately what JS's `await` vs `.then` split is |
| eventual-send on broken reference | `E(rejectedPromise).foo()` returns a rejected HandledPromise without throwing; pipelining continues, exception propagates through the chain |
| `def [p, r] := Ref.promise()` | `const { promise, resolve, reject } = makePromiseKit()` in `@endo/promise-kit`; or `new Promise((res, rej) => { ... })` for the JS-native form |
| datalock | the same bug shape exists in JS; modern toolchains (V8, Node.js) detect some cases but not all |

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
