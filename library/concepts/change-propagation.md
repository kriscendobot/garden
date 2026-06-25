---
id: change-propagation
aliases: ["change propagation", "incremental change propagation", "change-propagation through-line", "propagation of change", "delta propagation", "reactive change propagation", "three faces of reactivity", "frb pubsub propagators", "observers topics propagators"]
topics: [change-propagation]
status: current
---

# change-propagation

The unifying through-line across a cluster of garden / Endo work: **how a change in one place is incrementally and reliably reflected elsewhere** — between data structures and between agents — without recomputing the whole derived state. Three concrete systems in the corpus are three faces of this one idea, and they differ only along the axes gtor's reactivity taxonomy names (singular/plural, spatial/temporal, push/pull, broadcast/unicast):

1. **FRB observers** (`kriskowal/frb`) — *synchronous, spatial, in-process.* A binding compiles a query (`map`/`filter`/`sorted`/`group`/`sum`/`view`...) into a tree of observer functions; a typed change record (property/range/map change) enters at the collection layer and propagates stage-to-stage as a **delta**, each stage folding only the changed element into its output. Consistency is restored in the same statement that caused the change. See [[frb-incremental-update]], [[frb-compiled-observer-tree]].
2. **pubsub topics** (`@endo/pubsub`, PR #513; the `@endo/exo-pubsub` design #507) — *asynchronous, temporal, possibly cross-vat.* A **sink** accepts published values; **springs** are independent subscriber readers over a shared async promise linked list. A `makeChangeTopic` delivers every change after subscription (lossless, a stream of deltas); a `makeLatestTopic` retains only the most recent value (lossy). See [[endo-pubsub]], [[changes-versus-latest]].
3. **Propagators** — *multi-directional constraint/dataflow propagation* (Sussman/Radul lineage). Cells hold partial information and merge incoming contributions toward convergence; computation is the network settling, not a one-shot evaluation. **Only partially grounded in the garden corpus** — the one in-corpus instance is FRB's **two-way bindings** (`<->`), which are constraint propagation in the small (an invariant maintained by propagating each change in whichever direction it originated). The fuller multi-directional, lattice-merge propagator model is named here as the adjacent external lineage, not transcribed from a garden source. See *Common confusions* below.

## The shared abstractions

- **The producer/consumer dual.** gtor: "the duality of a getter and a setter — a producer and a consumer, a writer and a reader — exists in every reactive primitive." FRB pairs a *binder* (applies a change to a target) with an *observer* (emits change records from a source); pubsub pairs a *sink*/writer with *springs*/readers. Change propagation is always a setter-side delta flowing to getter-side observers.
- **Incremental delta vs full recomputation.** Every system propagates the *change*, not a fresh snapshot. FRB's defining adjective is "incremental" (a derived value is maintained by folding the delta, never re-derived); pubsub's change-topic ships per-change deltas; a propagator merges the new partial contribution into a cell. The bias is delta-maintenance, with named exceptions (FRB's `has` recomputes but is cheap).
- **Push vs pull.** gtor's signal (discrete, pushed) vs behavior (continuous, polled) is the axis. FRB is push within a synchronous statement; pubsub's change-topic pushes while its latest-topic is sampled on demand; a behavior is pulled.
- **changes vs latest.** The deepest recurring duality, broken out as its own page: a *changes* stream is lossless and order-significant; a *latest* value is lossy and convergent. gtor shows they are two faces of one signal (an observable's `forEach` vs its `next`). See [[changes-versus-latest]].
- **Ordered-collection windows as derived topics.** A sliding window over an ordered collection is itself an incrementally-maintained derived view that reacts to both content changes and window-position changes — FRB's `view(start, length)` over a `SortedSet` is the synchronous precedent, and the pubsub-side "collection-change propagation" future direction (range-change records over a topic) is its temporal counterpart. See [[sliding-window-topic]].

## The tensions (where they differ and why)

- **Synchronous vs asynchronous time axis.** FRB restores consistency *in the statement that caused the change* (spatial); pubsub propagates *over time* across the microtask queue and potentially across vats (temporal). Same delta model, different axis (gtor's spatial↔temporal rotation).
- **Broadcast vs unicast / pressure.** A stream is unicast and back-pressured (every value significant, the consumer can push back); a pubsub topic is broadcast and discontinuous (the publisher does not wait, a late subscriber misses earlier values). FRB is neither — it is synchronous fan-out with no queue. The choice of transport is "domain specific" per the meaning of the data.
- **Idempotent convergence vs order-significance.** A latest-topic / behavior / propagator-cell is naturally convergent — re-delivering the latest value (or re-merging a partial) lands the same state, so it tolerates loss and reordering. A changes-topic / stream is order-and-completeness-sensitive — every delta is significant and dropping one corrupts the derived state. This is the same divide as gtor's "order may not matter for time-series data."

## Synchronization between agents

The change-propagation cluster is how agents stay synchronized: a query establishes the current state and a subscription delivers subsequent changes — the changes/latest pair is exactly a "give me the current value, then push me every update" contract. `@agoric/notifier`'s distributed-iteration properties (producer not vulnerable to consumers; consumers mutually independent; full ordering across all consumers) are the cross-agent form, and the notifier-pubsub-migration design (#507) is the work moving that contract into Endo on `@endo/stream`'s Reader/Writer symmetry. See [[endo-pubsub]] and the [change-propagation topic page](../topics/change-propagation.md).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gtor--readme--reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | The producer/consumer dual × singular/plural × spatial/temporal grid; broadcast vs unicast; pressure. |
| [gtor--readme--signals-and-behaviors](../sections/gtor--readme--signals-and-behaviors.md) | Discrete pushed signals (changes) vs continuous polled behaviors (latest); the two faces of one signal. |
| [gtor--readme--asynchronous-values-and-functions](../sections/gtor--readme--asynchronous-values-and-functions.md) | Promise (broadcast, no cancel) vs task (unicast, observer cancels upstream); the singular-temporal precedent for the producer/consumer dual. |
| [gtor--readme--promise-queues-and-buffers](../sections/gtor--readme--promise-queues-and-buffers.md) | The async linked-list queue and two-queue buffer that make pressure concrete; the substrate beneath @endo/stream and @endo/pubsub. |
| [gtor--readme--promise-iterators-and-generators](../sections/gtor--readme--promise-iterators-and-generators.md) | Reader/writer stream sides; async map/forEach/reduce/pipe carry the deltas; cancellation flows upstream through the unicast task. |
| [gtor--readme--asynchronous-generator-functions](../sections/gtor--readme--asynchronous-generator-functions.md) | await + yield compose into a promise iterator; the stream algebra reduces to one `next` primitive. |
| [gtor--readme--iterators-and-generators](../sections/gtor--readme--iterators-and-generators.md) | The synchronous-spatial column the temporal primitives mirror; the iterator/generator-function backward channel is the spatial precedent for reader push-back. |
| [gtor--readme--progress-and-estimated-completion](../sections/gtor--readme--progress-and-estimated-completion.md) | A worked example of the changes-vs-latest divide: progress as a discrete pushed signal vs a continuous polled behavior. |
| [gtor--readme--summary-and-glossary](../sections/gtor--readme--summary-and-glossary.md) | The recap of the taxonomy plus gtor's open-questions backlog (primitive coercions, operator lifting, hot/cold observables) and term glossary. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | Typed change records propagate through a compiled observer tree so each layer needs only the delta. |
| [frb--readme--properties](../sections/frb--readme--properties.md) | "Incremental" and "reactive" among FRB's six self-described adjectives. |
| [frb--readme--tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | `view(start, length)` projects a sliding window over a SortedSet, reacting to content and window-position changes. |
| [endo-but-for-bots--pkg-pubsub-readme--change-and-latest-topics](../sections/endo-but-for-bots--pkg-pubsub-readme--change-and-latest-topics.md) | The async, temporal face made concrete: `makeChangeTopic` (lossless deltas) vs `makeLatestTopic` (lossy latest) Reader/Writer topics, the [[changes-versus-latest]] duality in shipped-package form. |
| [endo-but-for-bots--pkg-pubsub-readme--sink-and-spring](../sections/endo-but-for-bots--pkg-pubsub-readme--sink-and-spring.md) | The producer/consumer dual realized: one sink, many independent spring cursors over one async promise linked list (gtor's broadcast shape). |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--local-pubsub-foundations](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--local-pubsub-foundations.md) | The changes vs latest kits as a design contract; latest-always-replays is the "give me the current value then push every update" synchronization shape. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--asymmetric-passability](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--asymmetric-passability.md) | The producer/consumer dual at the wire: one facet crosses CapTP, rarely both; the cross-agent form of the dual. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--back-pressure-and-wire-protocol](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--back-pressure-and-wire-protocol.md) | The idempotent-convergence vs order-significance tension at the transport: changes accumulate on the slow consumer, latest carries one cell; producer-not-vulnerable-to-consumers. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation.md) | Ordered-collection windows as derived topics: the FRB range-change shape named as pubsub's out-of-scope future. |

## See also

- [[changes-versus-latest]] — the lossless-deltas vs lossy-current-value duality at the heart of the cluster.
- [[endo-pubsub]] — the async, temporal face: sink/spring topics over a shared promise linked list.
- [[sliding-window-topic]] — ordered-collection windows as incrementally-maintained derived topics.
- [[frb-incremental-update]] — the synchronous, spatial face: delta-not-recompute over generic collections.
- [[functional-reactive-bindings]] — the library whose observer trees are one face of change propagation.
- [[content-change-listener]] — the synchronous change-notification interface (property/range/map change) the deltas ride on.
- [[exo-stream]] — the CapTP bridge that carries a stream of changes across vats.

## Common confusions

- **Propagators are only partially grounded here.** The garden corpus (gtor, FRB, @endo/pubsub) does *not* ingest the Sussman/Radul propagator model. The one grounded instance of multi-directional constraint propagation is FRB's two-way (`<->`) bindings, which maintain an equality-shaped invariant by propagating a change in whichever direction it originates (e.g. the `reversed()` two-way example). The general propagator network — arbitrary-arity cells merging partial information over a lattice toward a fixed point — is named as the adjacent lineage and shares "incremental delta propagation through a network of nodes," but its *multi-directional, merge/convergence* character is a real difference from the directional getter→setter flow of streams, topics, and one-way bindings. Do not assert a tighter equivalence than the sources support.
- **FRB is synchronous; pubsub is asynchronous.** They are the same delta model on opposite sides of gtor's spatial/temporal axis, not competitors. FRB cannot cross a vat boundary; a pubsub topic (or an `@endo/exo-stream` ref) can.
