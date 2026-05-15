---
title: Promise Pipelining (promises, pipelining, datalock, explicit promises, broken-promise contagion)
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
---

## Abstract

Section 8 introduces **promises** as the return-value of an eventual-send and **pipelining** as the streaming optimization that lets `def r3 := x <- a() <- c(y <- b())` ship three messages in one network round-trip. A promise is initially an *eventual reference for the result*; the eventual-send's pending-delivery carries a *resolver* (the right to choose what the promise designates), and when the spawned turn completes the vat reports the outcome to the resolver, *resolving* the promise so it becomes a reference to the *resolution*. Messages may be eventual-sent to a promise *before* it resolves; they buffer in FIFO order within the promise and forward in order once resolution lands. Pipelining (§8.2) extends this to remote vats: if `x` and `y` live on `VatR`, the three pending deliveries are serialized and streamed to `VatR` together; `VatR` queues the first two locally (since their targets are known), and sends the third on a local promise whose resolver is the answer to `a()`. The "Three-Vat-Attack" geometry (where `r1` resolves to a third vat) shows how `c(r2)` is *forwarded* to wherever `r1` resolves, not held back at the originating vat. Latency is the motivation: bandwidth and buffers improve, but the speed of light is fixed; pipelining symmetrically generalizes Bogle's "Batched Futures" (BL94) and is critical for plan composition over a high-latency link. §8.3 names **datalock** (circular data dependencies that prevent progress, like the `epimenides` self-referencing promise), distinguishes it from deadlock (datalock manifests reproducibly, deadlock manifests sporadically), and reports two datalock bugs in 60-programmer-years of experience. §8.4 introduces the **explicit promise** primitive `def [p, r] := Ref.promise()` for hand-rolled postponement. §8.5 introduces **broken-reference contagion**: an exception that terminates an eventual-sent turn does *not* signal back into the caller's control flow; instead the vat catches it and *breaks* the promise by resolving it to a *broken reference* containing the exception. Immediate-call on a broken reference throws; eventual-send on a broken reference breaks the new send's promise with the same exception. The control-flow / data-flow split parallels signaling vs non-signaling NaNs in IEEE floating point: broken-reference contagion *does not hinder pipelining* in the way thrown exceptions would.

## Body

### Promises

The opening of §8 makes precise what a promise is:

> As discussed previously, eventual-sends queue a pending delivery and complete immediately. The return value from an eventual-send operation is called a *promise* for the eventual result. The promise is not a near reference for the result of the eventual-send because the eventual-send cannot have happened yet (i.e., it will happen in a later turn). Instead, the promise is an eventual-reference for the result. A pending delivery, in addition to the message and reference to the target object, includes a *resolver* for the promise, which provides the right to choose what the promise designates. When the turn spawned by the eventual-send completes, its vat reports the outcome to the resolver, *resolving* the promise so that the promise eventually becomes a reference designating that outcome, called the *resolution*.

The post-resolution unification:

> Once resolved, the promise is equivalent to its resolution. Thus, if it resolves to an eventual-reference for an object in another vat, then the promise becomes that eventual reference. If it resolves to an object that can be passed by copy between vats, then it becomes a near-reference to that object.

And the **defining feature of a promise as more than a future**: messages can be eventually-sent to a promise *before* it resolves:

> Because the promise starts out as an eventual reference, messages can be eventually-sent to it even *before* it is resolved. Messages sent to the promise cannot be delivered until the promise is resolved, so they are buffered in FIFO order within the promise. Once the promise is resolved, these messages are forwarded, in order, to its resolution.

This buffering-into-FIFO is what makes pipelining mechanical: queue-against-an-unresolved-promise is the same operation whether the eventual reference is unresolved-because-pending-delivery or unresolved-because-promise.

### Pipelining (§8.2)

The motivating snippet:

```
def r3 := x <- a() <- c(y <- b())
```

or equivalently:

```
def r1 := x <- a()
def r2 := y <- b()
def r3 := r1 <- c(r2)
```

When `x` and `y` are on `VatR` and the code runs in `VatL`:

> All three requests are serialized and streamed out to `VatR` immediately and the turn in `VatL` continues without blocking. By contrast, in a conventional RPC system, the calling thread would only proceed after multiple network round trips.

The paper's *Figure 4* (page 213) shows the geometry: the `a()` pending-delivery carries a promise-end at `VatL` (`r1`) and a resolver-end traveling toward `VatR`; the `c(r2)` pending-delivery is queued against the resolver-end of `r1`. Messages flow toward the *destination*; the resolver-side of an unresolved reference is the arrow*head*. "References x and y are shown with solid arrowheads, indicating that their target is known. The others are promises, whose open arrowhead represents their resolvers, which provide the right to choose their promises' value."

The wire-side detail:

> While the pending delivery for a() is in transit to VatR, so is the resolver for r1, so we send the c(r2) message there as well. As VatR unserializes these three requests, it queues the first two in its local to-do list, since their target is known and local. It sends the third, c(r2), on a local promise that will be resolved by the outcome of a(), carrying as an argument a local promise for the outcome of b().

The three-vat case is where the streaming pays off:

> If the resolution of r1 is local to VatR, then as soon as a() is done, c(r2) is immediately queued on VatR's to-do list and may well be serviced before VatL learns of r1's resolution. If r1 is on VatL, then c(r2) is streamed back towards VatL just behind the message informing VatL of r1's resolution. If r1 is on yet a third vat, then c(r2) is forwarded to that vat.

The latency-vs-bandwidth argument that motivates it:

> Across geographic distances, latency is already the dominant performance consideration. As hardware improves, processing will become faster and cheaper, buffers larger, and bandwidth greater, with limits still many orders of magnitude away. But latency will remain limited by the speed of light. Pipes between fixed endpoints can be made wider but not shorter. Promise pipelining reduces the impact of latency on remote communication. Performance analysis of this type of protocol can be found in Bogle's "Batched Futures" [BL94]; the promise pipelining protocol is approximately a symmetric generalization of it.

The history: Liskov-Shrira (PLDI 1988) invented promises; Bogle's 1994 OOPSLA paper added batched-futures pipelining for client-server systems; this paper's contribution is *symmetric* pipelining, which works peer-to-peer because *both* sides of a vat-pair can hold promises and route messages along their resolvers.

### Datalock (§8.3)

Promise chaining lets some plans postpone behind earlier plans, but the same primitives admit circular data dependencies:

> Using the primitives introduced so far, however, it is possible to create circular data dependencies which, like deadlock, are a form of lost-progress bug. We call this kind of bug, *datalock*.

The example uses an Epimenides-style self-reference:

```
var flag := true
def epimenides() { return flag <- not() }
```

If `flag` is later assigned to the result of invoking `epimenides` eventually:

```
flag := epimenides <- run()
```

then a promise for the result is immediately bound to `flag`. When `epimenides` runs in a later turn, it eventual-sends to the promise in `flag` and resolves the flag promise to the new promise for `not()` sent to *that same* flag promise:

> The datalock is created, not because a promise is resolved to another promise (which is acceptable and common), but because computing the eventual resolution of flag requires already knowing it.

The paper's distinction from deadlock:

> Although the E model trades one form of lost-progress bug for another, it is still more reliable. As above, datalock bugs primarily represent circular dependencies in the computation, which manifest reproducibly like normal program bugs. This avoids the significant non-determinism, non-reproducibility, and resulting debugging difficulty of deadlock bugs. Anecdotally, in many years of programming in E and E-like languages and a body of experience spread over perhaps 60 programmers and two substantial distributed systems, we know of only two datalock bugs.

### Explicit promises (§8.4)

The paper introduces a primitive to create a promise-resolver pair directly, without an eventual-send:

```
def [p, r] := Ref.promise()
```

> p and r are bound to the promise and resolver of a new promise/resolver pair. Explicit promise creation gives us yet greater flexibility to postpone plans until other conditions occur. The promise, p, can be handed out and used just as any other eventual reference. All messages eventually-sent to p are queued in the promise. An object with access to r can wait until some condition occurs before resolving p and allowing these pending messages to proceed.

This is the primitive that the §10 `when-catch` and the §9 reconnection patterns are built from.

### Broken-promise contagion (§8.5)

> Because eventual-sends are executed in a later turn, an exception raised by one can no longer signal an exception and abort the plan of its "caller". Instead, the vat executing the turn for the eventual send catches any exception that terminates that turn and *breaks* the promise by resolving the promise to a *broken reference* containing that exception. Any immediate-call or eventual-send to a broken reference breaks the result with the broken reference's exception.

Two cases:

- **Immediate-call to a broken reference**: throws the exception, terminating local control flow.
- **Eventual-send to a broken reference**: breaks the new send's promise with the same exception, *without* terminating control flow but propagating the broken state to dependent plans.

The IEEE-754 analogy is the design lens:

> E's split between control-flow exceptions and data-flow exceptions was inspired by signaling and non-signaling NaNs in floating point. Like non-signaling NaNs, broken promise contagion does not hinder pipelining. Following sections discuss how additional sources of failure in distributed systems cause broken references, and how E handles them while preserving defensive consistency.

The pipelining-preservation matter: a thrown exception would propagate up the local call stack and prevent the next pipelined eventual-send from being queued; a broken-promise resolution simply marks the *result* as broken and lets the rest of the pipeline keep flowing. The two pipelined sends after `r1` (i.e., `r2 := y <- b()` and `r3 := r1 <- c(r2)`) still execute even if `a()` fails; `r3` will simply be broken with the same exception.

## Translation

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

## Implications for Endo

The paper's promise-pipelining argument is the **upstream of `@endo/eventual-send`'s pipelining behavior** and the **theoretical motivation** for the comment-fragment ingest of cycle 66 (`endo--packages-eventual-send-src-handled-promise-js--*`). Three concrete pinnings:

1. **The mechanical implementation is `applyMethod` reduction + the forwarding-graph.** The cycle-66 ingest of `handled-promise.js` shows the *mechanical* path: pipelining emerges from `dispatchToHandler`'s reduction of `applyMethod` into `get` followed by `applyFunction`, threading an intermediate `HandledPromise` whose pending handler is the same as the outer chain's; the second sub-operation queues against that pending state. This *paper section* is the theoretical motivation; the *handled-promise.js section* is the mechanical realization. Both anchor onto the [[promise-pipelining]] concept page.

2. **CapTP's `<desc:answer>` wire form is the network realization.** The paper's three-vat geometry (the `c(r2)` arrow that follows wherever `r1` resolves) is exactly the *forward-the-answer-slot-reference* discipline that CapTP's `<desc:answer answer-pos>` enables. Endo's `packages/captp/README.md` already names this; the paper grounds it in the latency argument.

3. **Broken-reference contagion → HandledPromise rejection contagion.** Endo inherits the design: a rejected HandledPromise eventual-sent to with `E(...)` yields a rejected HandledPromise without throwing. The "split between control-flow and data-flow exceptions" maps onto JS's `await` (control-flow throw at the await point) vs `.then(...)` / `E(...)` (data-flow rejection propagation).

A *substantive divergence* worth a future investigation: the paper's **broken-reference state is terminal** — once a reference is broken, it stays broken; sending to it any number of times always yields a broken promise. Modern JS Promise semantics (and Endo's HandledPromise built on them) honor this: a rejected promise stays rejected, and chaining off a rejected promise propagates rejection. The shape matches; the formal-correspondence claim is solid.

## Common confusions

- **"Pipelining is just `Promise.all`."** No. `Promise.all` waits for a set of *independent* promises to resolve locally. Pipelining is about *dependent* promises whose dependencies are themselves remote sends, and about routing subsequent sends to the *remote* side's answer slot before any local resolution has happened. See the concept page [[promise-pipelining]].
- **"`<-` chains are sequential like `.then(...)` chains."** Not on the wire. A `.then(...)` chain serializes data-flow but each `.then` runs only after the previous resolves *locally*. A pipelined `<-` chain streams the dependent messages to the remote *before* the first resolves locally; the dependent message's arrival at the remote may even precede the first's resolution returning to the local vat.
- **"Datalock means the runtime deadlocks."** No. Datalock means a particular *promise* never resolves. Other plans in the vat continue. The vat's turn-by-turn execution model is preserved; only the specific data dependency that participates in the cycle hangs. Datalock is a *bug* in the dependent plan, not a system-level failure.
- **"Broken-promise contagion is like exception propagation."** Partially. Both propagate exceptions, but exception propagation terminates the *caller's* control flow whereas broken-promise contagion propagates through the *data-flow graph* without unwinding the caller's stack. The paper's IEEE-754 NaN analogy is the right mental model: NaN arithmetic propagates NaN to dependent computations without raising a signal.

## See also

- [[promise-pipelining]] — the concept page; this section is the theoretical anchor, the cycle-66 `handled-promise.js` ingest provides the mechanical anchor.
- [[vat-and-compartment]] — pipelining is meaningful only because vats are isolated; the *answer-slot-reference* arrow makes sense exactly because near references cannot cross vat boundaries.
- [[four-tables-coordinated-retention]] — Endo's later retention-graph machinery is what makes pipelined answer-slot references retainable across vat boundaries.
- [`endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly`](endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) — **mechanical complement.** The dispatcher reduction that makes pipelining emerge from the shim's `applyMethod` / `get` / `applyFunction` decomposition.
- [`endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find`](endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) — **why deep pipelined chains stay cheap.** Path-splitting in the forwarding-graph keeps long chains from forming a linear retention list.
- [`endo--pkg-eventual-send-readme--promise-pipelining`](endo--pkg-eventual-send-readme--promise-pipelining.md) — Endo's user-facing description of the same mechanism.
- [`ocapn--implementation-guide--stage-4-promise-pipelining`](ocapn--implementation-guide--stage-4-promise-pipelining.md) — the upstream protocol's Stage 4 milestone; the wire form of an answer-slot reference.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
