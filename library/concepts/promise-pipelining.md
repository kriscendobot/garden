---
id: promise-pipelining
aliases: ["promise pipelining", "pipelined message send", "pipelined eventual-send", "applyMethod pipelining", "chained E() calls", "E(E(x).foo()).bar()", "round-trip elimination"]
topics: [eventual-send, captp]
---

# promise-pipelining

The composition pattern by which a message can be sent *eventually*
to the value a previous eventual-send is expected to produce,
*before* that previous send's answer has arrived. The classic E
form is `E(E(target).foo()).bar()`: `foo` is dispatched to `target`,
and `bar` is queued against the not-yet-resolved promise that
`foo` will return. When the messages cross a network boundary, the
remote comm layer pipelines the queue so a chain of `E()` calls
collapses to a single round-trip: subsequent calls arrive at the
remote side as references to the answer-slot of an earlier call,
not as new requests waiting on local resolution. Pipelining
*emerges* from the eventual-send shim's `applyMethod` reduction
(decompose into `get` followed by `applyFunction`, threading the
intermediate `HandledPromise`) and from CapTP's wire-level
`<desc:answer>` answer-slot reference; it is not a separately
implemented primitive.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining.md) | **Original theoretical motivation.** The §8 argument: an eventual-send returns a *promise* that is an eventual-reference for the result; messages may be eventually-sent to the promise *before* it resolves (FIFO buffering); pipelining ships `def r3 := x <- a() <- c(y <- b())` as one round-trip; latency (not bandwidth) is the motivation; symmetrically generalizes Bogle's "Batched Futures" (BL94). Names *datalock*, *explicit promise*, and *broken-reference contagion* as companion mechanisms. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--history-and-related-work.md) | **Lineage anchor.** Promise pipelining was first invented by Liskov and Shrira (LS88), significantly improved by Bogle and Liskov ("Batched Futures", BL94), independently reinvented in Udanax Gold (Miller 1992) for client-server, and adapted to peer-to-peer by E and its descendants. Endo's `E(E(x).foo()).bar()` is the JavaScript enactment of this LS88 → BL94 → Udanax → E → Endo lineage. |
| [endo--pkg-eventual-send-readme--promise-pipelining](../sections/endo--pkg-eventual-send-readme--promise-pipelining.md) | The user-facing description: when messages cross a network boundary via `E()`, the comm layer can pipeline subsequent `E()` calls against the not-yet-resolved promise without a full round-trip. |
| [endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) | **Mechanical origin.** `dispatchToHandler`'s reduction of `applyMethod` into `get` + `applyFunction` threads an intermediate `HandledPromise` whose pending handler is the same as the outer chain's; the second sub-operation queues against that pending state, pipelining transparently without a dedicated primitive. |
| [endo--pkg-eventual-send-readme--handled-promise](../sections/endo--pkg-eventual-send-readme--handled-promise.md) | The `HandledPromise` primitive that pipelining rides on; user-facing summary. |
| [endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find](../sections/endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find.md) | **Why deep pipelining stays cheap.** When pipelined chains resolve, the forwarding-graph collapses via path-splitting; intermediate `HandledPromise`s become eligible for GC instead of forming a linear retention chain. |
| [agoric-sdk--pkg-swingset-readme--promise-pipelining](../sections/agoric-sdk--pkg-swingset-readme--promise-pipelining.md) | SwingSet's framing of the same pattern: "the Promise returned by an eventual-send can be used as a target itself — `E(E(bob).foo()).bar()` queues `bar` to deliver to whatever `foo` returns." |
| [ocapn--implementation-guide--stage-4-promise-pipelining](../sections/ocapn--implementation-guide--stage-4-promise-pipelining.md) | OCapN's Stage 4 implementation milestone: pipelining via `<desc:answer answer-pos>`. The wire form of an answer-slot reference. |
| [ocapn--draft-specifications-captp--promises](../sections/ocapn--draft-specifications-captp--promises.md) | Spec-level account of promises in CapTP, including the answer-slot machinery that the wire side of pipelining depends on. |

## See also

- [[caretaker-pattern]] — pipelining and caretakers are independent decompositions of a capability call, but both rely on the same `HandledPromise` substrate.
- [[handler-protocol]] — `dispatchToHandler`'s reductions, the SendOnly substitution, and the minimum-viable handler interface. Expands on the *mechanism* this concept names: the `applyMethod` decomposition there is where pipelining emerges. The section [endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly](../sections/endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly.md) is the canonical source.

## Common confusions

- **"Pipelining is just `Promise.all`."** No. `Promise.all` waits for a set of independent promises to all resolve locally. Pipelining is about *dependent* promises whose dependencies are themselves remote sends, and about avoiding the local-resolution wait by routing subsequent sends to the *remote* side's answer slot before any local resolution has happened.
- **"Pipelining is implemented in `applyMethod`."** Not quite. `applyMethod` is one of the reduction sites where pipelining mechanically emerges, but pipelining is also visible on direct `get`-then-`applyMethod` chains where the handler implements `applyMethod` directly. The substrate is the `HandledPromise` queue and the wire's answer-slot reference, not any one operation in the dispatcher.
