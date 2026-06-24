---
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
notes: |
  Partial ingest. Only the two keystone sections (the reactivity taxonomy
  and the signal-vs-behavior duality) are absorbed so far, because they
  anchor the change-propagation through-line concept pages. The README is
  a ~1800-line document with ~20 H3 primitive sections (Iterators,
  Generators, Asynchronous Values, Promise Queues / Buffers / Iterators /
  Generators, Semaphores, Observables, Behaviors). The full per-primitive
  ingest is deferred to the follow-on `scholar-ingest-gtor` job.
---

> Abstract: *A General Theory of Reactivity* (gtor) is Kris Kowal's framework unifying JavaScript's reactive primitives under one vocabulary. Its organizing claim: every reactive primitive is a **producer/consumer dual** (getter/setter, reader/writer, observable/signal-generator), and the primitives partition along three axes — **singular vs plural** (one value or many), **spatial vs temporal** (a value in space or a value that arrives over time), and **broadcast vs unicast** (many independent consumers, or one cancelable cooperative consumer with back-pressure). Streams transport an entire collection with pressure; publish/subscribe is broadcast and discontinuous; **signals** push discrete changes while **behaviors** are polled for their latest value. gtor is the conceptual root the garden's change-propagation cluster descends from: `@endo/stream`'s Reader/Writer, `@endo/pubsub`'s sink/spring and changes-vs-latest topics, and `kriskowal/frb`'s incremental bindings are all instances of these dualities. The `@endo/exo-pubsub` design (endo-but-for-bots#507) cites gtor explicitly as its vocabulary anchor.

This source document is the canonical statement of the reactivity taxonomy that the rest of the change-propagation corpus instantiates. See the [change-propagation topic page](../topics/change-propagation.md) for how the taxonomy maps onto the concrete packages (frb, @endo/stream, @endo/pubsub) and the [change-propagation concept page](../concepts/change-propagation.md) for the unifying through-line.

| Section | Topics | Status |
|---------|--------|--------|
| [reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | change-propagation, streams, reactive-bindings | current |
| [signals-and-behaviors](../sections/gtor--readme--signals-and-behaviors.md) | change-propagation, streams | current |

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc`.
