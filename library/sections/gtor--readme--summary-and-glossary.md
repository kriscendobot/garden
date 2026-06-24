---
title: gtor — summary, further work, and glossary (the recap of the reactivity taxonomy + the flat vocabulary index)
source: README.md
source_repo: kriskowal/gtor
source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d
source_date: 2017-12-04
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [change-propagation, streams]
status: current
---

> Abstract: gtor's closing recap (`## Summary`), its open-questions list (`## Further Work`), and its flat term `## Glossary`, consolidated into one section per the conventions' glossary-handling rule (preserve term anchors inline for grep; harvest the terms as `keywords.md` entry points rather than splitting one section per term). The **Summary** restates the framework's load-bearing claims: reactive primitives categorize along multiple dimensions; the interfaces of non-reactive constructs (getters, setters, generators) inform the design of their asynchronous counterparts; **singular-vs-plural** greatly informs design; **pressure** handles resource contention while guaranteeing consistency; **push or poll** strategies skip irrelevant states for continuous (behavior) or discrete (signal) time series; there is a **tension between cancelability and robustness** — streams and tasks are cooperative, cancelable, and bidirectional, while **promises guarantee producer and consumer cannot interfere**; and unifying all of these in one framework lets you pick the right tool and obviates silver-bullet debates. **Further Work** is gtor's own backlog — reservoir sampling as a stream-watching behavior, coercions between primitive kinds (promise↔task, signal↔behavior, signal↔stream), operator lifting across value spaces, the thundering-herd inverse-of-throttle operator, hot/cold (Rx) observables, Conal Elliott's continuous-behavior FRP lineage, and propagating estimated-time-to-completion through stream-returned tasks. The **Glossary** is a flat ~55-term vocabulary list (accumulator … yield) reproduced inline below as the canonical term index.

This section is the cross-cutting recap of *A General Theory of Reactivity*; the per-primitive detail lives in the sibling sections ([[gtor--readme--reactivity-taxonomy]], [[gtor--readme--signals-and-behaviors]], the async/queue substrate sections, and [[gtor--readme--iterators-and-generators]]). Read here for the one-paragraph framing and the vocabulary index; read the siblings for mechanism.

## §Summary — the framework's load-bearing claims

Reactive primitives can be categorized in multiple dimensions. The interfaces of analogous **non-reactive** constructs — getters, setters, and generators — are insightful in the design of their asynchronous counterparts. Identifying whether a primitive is **singular or plural** also greatly informs the design.

- We can use **pressure** to deal with resource contention while guaranteeing **consistency**.
- We can alternately use **push or poll** strategies to skip irrelevant states for either **continuous** (behavior) or **discrete** (signal) time-series data.
- There is a **tension between cancelability and robustness**, but gtor has primitives for both cases. **Streams and tasks** are inherently cooperative, cancelable, and allow bidirectional information flow. **Promises guarantee that consumers and producers cannot interfere.**
- All these concepts are related and benefit from mutual availability: promises and tasks are great for single-result data but can also carry a convenient channel for plural signals and behaviors.

Bringing all of these reactive concepts into a single framework tells a coherent story about reactive programming, promotes understanding of which tool fits the job, and obviates the debate over whether any single primitive is a silver bullet.

## §Further Work — gtor's own open questions and backlog

gtor names many topics it intends to expand (verbatim shape, lightly compressed):

- **Reservoir sampling** modeled as a behavior that watches a stream or signal and produces a representative sample on demand.
- A **clock UI** as a study in the interplay of behaviors, signals, time, and animation scheduling.
- **Multi-resolution historical counters** (drawn from FastSoft TCP-acceleration kernel variables that overflow), combining streams, behaviors, and signals; cf. RRDTool's design.
- **Coercions between primitive kinds** — the payoff of a unified framework: promises↔tasks, a signal used as a behavior and a behavior captured by a signal, signals channeled into streams and streams into signals.
- **Lifting operators** across each of these value spaces.
- **Distributed sort** using streams.
- An **inverse-of-throttle** operator for asynchronous behaviors solving the **thundering-herd** problem.
- **Type-ahead suggestion** as a case for cancelable streams and tasks.
- Propagating **operational transforms** through queries (push and pull styles) and its relation to bindings, synchronous and asynchronous.
- Comparing **publish/subscribe** to signals and streams: pub/sub is broadcast (unlike unicast streams), a single subscription could be modeled as a stream, but a subscriber typically cannot push back on a publisher, so resource contention is an open question. Relatedly, **streams can be forked**, both branches putting pressure back on the source.
- Streams have methods that **return tasks** (`all`, `any`, `race`, `read`), all of which could propagate estimated time to completion.
- **High-performance bytewise buffers** with the promise-buffer interface; implementing a **retry loop** with promises and tasks.
- **Hot vs cold** (Rx) observables; the clock reference implementation shows a signal that is active or inactive based on whether anyone is looking.
- The original **Functional Reactive Programming** research of **Conal Elliott** (continuous behaviors) deserves attention.
- The interplay of promises and tasks with their underlying **progress behavior**, **estimated-time-to-completion**, and **status signals** needs to be incorporated into the promise/task implementation sketches.

## §Glossary — the flat vocabulary index (term anchors preserved inline for grep)

The README's glossary is a flat list of the vocabulary the document defines or uses; reproduced verbatim here as the canonical term set (also harvested into `keywords.md`):

`accumulator` · `array` · `asynchronous` · `await` · `behavior` · `blocking` · `broadcast` · `buffer` · `cancelable` · `continuous` · `control` · `counter` · `deferred` · `discrete` · `flow gauge` · `future` · `gauge` · `getter` · `getter getter` · `iterable` · `iterator` · `multiple` · `non-blocking` · `observable` · `observer` · `operation` · `poll` · `pressure` · `probe` · `promise` · `publisher` · `pull` · `pulse` · `push` · `readable` · `result` · `retriable` · `sensor` · `setter` · `setter setter` · `signal` · `single` · `sink` · `spatial` · `stream` · `strobe` · `subscriber` · `synchronous` · `task` · `temporal` · `throttle` · `unicast` · `value` · `writable` · `yield`

(The doubled forms — `getter getter`, `setter setter` — name the higher-order producer/consumer of a producer/consumer, e.g. a stream of streams; `flow gauge`, `gauge`, `probe`, `sensor`, `strobe`, `pulse` are the sampling-and-display vocabulary for behaviors and signals.)

Source: [README.md](https://github.com/kriskowal/gtor/blob/d2a238fce2cc0b73bbaec795a7230473b584fa9d/README.md) at commit `d2a238fc` (§ Summary / Further Work / Glossary, lines 1654–1822).
