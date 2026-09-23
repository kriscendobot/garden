---
id: casktel-span-completion
aliases: ["casktel Span", "casktel.Span", "Span completion", "StoreWithSpan", "SpanDriver", "casktel.SpanDriver", "StoreWrapper", "casktel.StoreWrapper", "span progress", "Span.Add", "Span.Done", "Progress() numerator denominator", "fire-and-forget store", "ErrSpanRequired", "SpanFromContext", "Tracer.Trace", "Tracer.Nice", "NopTracer", "NopSpan", "SpanSnapshot", "dir.StoreWithSpan"]
topics: [networking, content-addressed-storage]
status: current
---

# casktel-span-completion

CASK's `casktel.Span` is the abstraction storage systems use to track completion of large fire-and-forget tasks (storing many blocks). A Span carries identity (Trace, SpanID, TrafficClass, Priority) for the wire and for load-shedding, plus a **numerator/denominator progress model**: `Add(n)` queues `n` units (raises the denominator/Planned), `Add(-n)` completes `n` units (raises the numerator/Completed, capped), and `Progress()` returns `Completed/Planned` (or NaN when Planned is 0). The **Done channel** is the single completion point: the first `Done()` call *finalizes* the span (no more positive `Add`) and returns a channel that closes when `Completed == Planned` or on `Cancel()`/`Fail(err)`. This separates "I'm done adding" + "wait for me" into one call owned by the span's creator, with no separate `Finalize()`. The storage layering is two methods: synchronous `Store(ctx, hash, block, meta)` (the base) and asynchronous `StoreWithSpan(ctx, span, hash, block, meta)` (does `Add(1)`, enqueues, returns; completion does `Add(-1)`/`Fail`). Sync stores gain the async path by **embedding `casktel.SpanDriver`** (a goroutine drains the queue into the embedder's sync `Store()` then `Add(-1)`), or via the `casktel.StoreWrapper` fallback; Peer implements `StoreWithSpan` natively. `dir.Store` makes a Span *mandatory* (`ErrSpanRequired`) and is fire-and-forget: it returns the root hash immediately and the caller waits on `<-span.Done()` then reads `span.Err()`. Distinct from [[codel-send-buffer-shedding]], which is about the *Priority* a Span carries and how buffers evict by it; this concept is about the *completion/progress* side.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--trace2--casktel-package-interfaces](../sections/cask--trace2--casktel-package-interfaces.md) | The Tracer and Span interfaces: identity, cancellation, Add/Progress/Done semantics, constants. |
| [cask--trace2--nopcasktel-no-cost-tracer](../sections/cask--trace2--nopcasktel-no-cost-tracer.md) | The no-allocation/no-goroutine Span: atomic Add, inline Done-close via sync.Once, no-op logs. |
| [cask--trace2--buffercasktel-sampling-buffer-and-eviction](../sections/cask--trace2--buffercasktel-sampling-buffer-and-eviction.md) | The sampling Span buffer (parallel arrays + priority heap), parasitic log eviction, Flush/SpanSnapshot. |
| [cask--trace2--span-as-storage-completion-abstraction](../sections/cask--trace2--span-as-storage-completion-abstraction.md) | Store vs StoreWithSpan, the SpanDriver embeddable, StoreWrapper, Peer/dir/blob/io integration. |
| [cask--trace2--dir-store-span-contract-and-test](../sections/cask--trace2--dir-store-span-contract-and-test.md) | dir.Store requires a Span (ErrSpanRequired); fire-and-forget traversal; the nopcasktel test flow. |
| [cask--trace2--file-layout-and-implementation-order](../sections/cask--trace2--file-layout-and-implementation-order.md) | The three-package layout and the staged build order from interfaces to buffercasktel. |
| [cask--cask-go--store-interface-and-span-tracked-completion](../sections/cask--cask-go--store-interface-and-span-tracked-completion.md) | The consumer side: the `cask.Store` interface doc-comment specifying the Add(1)/Add(-1)/Fail span discipline and the four-step create-span → call-Store → wait-on-Done → check-Err caller pattern. |
| [cask--net-peer-go--command-request-span-lifecycle](../sections/cask--net-peer-go--command-request-span-lifecycle.md) | The casknet `Peer` consumer: `Store`/`Load`/`CAS`/`Collect`/`Weigh` enqueue and return immediately, resolving the Span on the remote's UDP acknowledgment; duplicate in-flight stores coalesce one ack onto many spans; Fail/Add(-1) run after the peer lock releases. |

## See also

- [[codel-send-buffer-shedding]] — the *priority/eviction* side of casktel: the TrafficClass + 128-bit Trace → 256-bit Priority that a Span carries and that buffers (including buffercasktel) order by. This concept is the *completion/progress* side; the two meet in the Span.
- [[parallel-arrays-columnar]] — buffercasktel's fixed-size span+log buffer is the same columnar parallel-array shape as the sendbuffer/CoDel buffers.
- [[content-addressed-block-store]] — the blocks whose stores a Span tracks; each 1KB block store is one `Add(1)`/`Add(-1)` pair.
