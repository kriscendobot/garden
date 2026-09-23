---
title: Body
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

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) §8 (pages 212-215); SHA-256 `4ff0c5bd07e1`.
