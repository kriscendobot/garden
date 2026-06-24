# Topic: change-propagation

> Abstract: How a change in one place is incrementally and reliably reflected elsewhere — between data structures and between agents — without recomputing the whole derived state. The garden's recent and in-flight work converges here: `kriskowal/frb` (synchronous, in-process incremental bindings), `@endo/pubsub` (asynchronous broadcast topics; PR #513) and the `@endo/exo-pubsub` design (#507), the `@endo/stream` Reader/Writer symmetry, and the in-flight Endo/Exo reactive-collections research. `kriskowal/gtor` (*A General Theory of Reactivity*) is the conceptual root that names the axes — producer/consumer dual, singular/plural, spatial/temporal, push/pull, broadcast/unicast — along which these systems differ. The unifying claim: FRB observers, pubsub topics, and (with caveats) propagators are three faces of one idea — propagate the *delta*, not a fresh snapshot — and the recurring sub-threads are **changes vs latest** (lossless deltas vs lossy current value) and **ordered-collection windows as derived topics**. Distinct from [reactive-bindings](reactive-bindings.md) (which is specifically FRB) and [streams](streams.md) (the `@endo/stream` transport): this topic is the cross-cutting *theory* those instantiate. Seeded 2026-06-24 by the `scholar-through-lines-change-propagation` job.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [gtor--readme--reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | gtor README | The producer/consumer dual × singular/plural × spatial/temporal grid; broadcast vs unicast; pressure. |
| [gtor--readme--signals-and-behaviors](../sections/gtor--readme--signals-and-behaviors.md) | gtor README | Discrete pushed signals (changes) vs continuous polled behaviors (latest); the two faces of one signal. |
| [gtor--readme--asynchronous-values-and-functions](../sections/gtor--readme--asynchronous-values-and-functions.md) | gtor README | Promise/resolver/deferred; promise (broadcast) vs task (unicast, cancel upstream); the async-function promise trampoline. |
| [gtor--readme--promise-queues-and-buffers](../sections/gtor--readme--promise-queues-and-buffers.md) | gtor README | The asynchronous linked-list queue (get-before-put); a two-queue buffer realizes back-pressure as a returned acknowledgement promise. |
| [gtor--readme--promise-iterators-and-generators](../sections/gtor--readme--promise-iterators-and-generators.md) | gtor README | The readable/writable stream sides; async map/forEach/reduce/pipe; forEach returns a task so cancellation flows upstream; remote iterators. |
| [gtor--readme--asynchronous-generator-functions](../sections/gtor--readme--asynchronous-generator-functions.md) | gtor README | await + yield compose into a promise iterator (Promise<Iteration<T>>); the whole stream algebra reduces to one `next`. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | frb README | Typed change records propagate through a compiled observer tree so each layer needs only the delta. |
| [frb--readme--properties](../sections/frb--readme--properties.md) | frb README | "Incremental" and "reactive" among FRB's six design adjectives. |
| [frb--readme--tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | frb README | `view(start, length)` projects a sliding window over a SortedSet, reacting to content and window-position changes. |

## Concepts

- [[change-propagation]] — the keystone through-line: FRB observers ↔ pubsub topics ↔ propagators as three faces of delta propagation; the shared abstractions and the tensions.
- [[changes-versus-latest]] — lossless deltas (signal / `makeChangeTopic`) vs lossy current value (behavior / `makeLatestTopic`); the notifier lossy/forward-lossless/fully-lossless taxonomy.
- [[endo-pubsub]] — `@endo/pubsub`'s sink/spring primitive and the two topic factories (PR #513); the notifier-pubsub-migration design (#507).
- [[sliding-window-topic]] — ordered-collection windows as incrementally-maintained derived topics; FRB `view` as the synchronous precedent, collection-change propagation as the async future direction.

## See also

- [reactive-bindings](reactive-bindings.md) — FRB specifically: the synchronous, in-process face.
- [streams](streams.md) — the `@endo/stream` Reader/Writer transport and `@endo/exo-stream` CapTP bridge that carry async changes.
- [data-structures](data-structures.md) — the `kriskowal/collections` ordered substrate (SortedSet, sorted maps/sets) windows and FRB observers project over.
