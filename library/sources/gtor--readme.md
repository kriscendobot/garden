---
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 6
status: current
notes: |
  Multi-cycle ingest in progress. Cycle 1 (`scholar-through-lines-change-propagation`)
  filed the two keystone sections (the reactivity taxonomy and the
  signal-vs-behavior duality) that anchor the change-propagation through-line
  concept pages. Cycle 2 (`scholar-ingest-gtor`) added the four async/queue
  substrate sections (asynchronous-values-and-functions,
  promise-queues-and-buffers, promise-iterators-and-generators,
  asynchronous-generator-functions) that ground the @endo/stream makeQueue
  cons-cell and @endo/pubsub sink/spring mechanisms. Still deferred to a
  re-posted `scholar-ingest-gtor` follow-on: the plural-spatial column
  (Iterators / Generator Functions / Generators, README lines 254-524) and the
  cross-cutting recap (Summary / Further Work / Glossary, lines 1654-1822, the
  vocabulary glossary being keyword-index fodder). The Concepts intro
  (lines 55-247) is covered by reactivity-taxonomy; the Observables /
  Observables and Signals / Behaviors H3s (1432-1598) are covered by
  signals-and-behaviors.
---

> Abstract: *A General Theory of Reactivity* (gtor) is Kris Kowal's framework unifying JavaScript's reactive primitives under one vocabulary. Its organizing claim: every reactive primitive is a **producer/consumer dual** (getter/setter, reader/writer, observable/signal-generator), and the primitives partition along three axes — **singular vs plural** (one value or many), **spatial vs temporal** (a value in space or a value that arrives over time), and **broadcast vs unicast** (many independent consumers, or one cancelable cooperative consumer with back-pressure). Streams transport an entire collection with pressure; publish/subscribe is broadcast and discontinuous; **signals** push discrete changes while **behaviors** are polled for their latest value. gtor is the conceptual root the garden's change-propagation cluster descends from: `@endo/stream`'s Reader/Writer, `@endo/pubsub`'s sink/spring and changes-vs-latest topics, and `kriskowal/frb`'s incremental bindings are all instances of these dualities. The `@endo/exo-pubsub` design (endo-but-for-bots#507) cites gtor explicitly as its vocabulary anchor.

This source document is the canonical statement of the reactivity taxonomy that the rest of the change-propagation corpus instantiates. See the [change-propagation topic page](../topics/change-propagation.md) for how the taxonomy maps onto the concrete packages (frb, @endo/stream, @endo/pubsub) and the [change-propagation concept page](../concepts/change-propagation.md) for the unifying through-line.

| Section | Topics | Status |
|---------|--------|--------|
| [reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | change-propagation, streams, reactive-bindings | current |
| [signals-and-behaviors](../sections/gtor--readme--signals-and-behaviors.md) | change-propagation, streams | current |
| [asynchronous-values-and-functions](../sections/gtor--readme--asynchronous-values-and-functions.md) | change-propagation, streams | current |
| [promise-queues-and-buffers](../sections/gtor--readme--promise-queues-and-buffers.md) | streams, change-propagation | current |
| [promise-iterators-and-generators](../sections/gtor--readme--promise-iterators-and-generators.md) | streams, change-propagation, eventual-send | current |
| [asynchronous-generator-functions](../sections/gtor--readme--asynchronous-generator-functions.md) | streams, change-propagation | current |

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc`.
