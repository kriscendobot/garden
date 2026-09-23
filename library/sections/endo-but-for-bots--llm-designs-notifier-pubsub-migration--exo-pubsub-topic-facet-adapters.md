---
title: "Notifier pubsub migration: @endo/exo-pubsub topic-facet adapters"
source: designs/notifier-pubsub-migration.md
source_repo: endojs/endo-but-for-bots
source_branch: design/notifier-pubsub-migration
source_commit: 8c2a46bed3fb072b25d10e96cae16859e63b6812
source_pr: endojs/endo-but-for-bots#507
source_pr_state: draft
source_date: 2026-06-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-25
ingested_by: scholar
topics: [change-propagation, streams, captp]
status: current
notes: Unmerged draft PR #507, revision 5; see the source-index file for the lifecycle caveat.
---

> Abstract: The `@endo/exo-pubsub` package is **not** a fixed catalog of topic shapes but a set of adapters, one module per direction-and-facet (no barrel exports, per the project `CLAUDE.md`). This section covers the **topic-facet adapters** (consumer fan-out becomes passable, or comes from passable): `topicFromReader(reader, options?)` mints a passable topic from a local `Reader<T>`, **dropping the back-pressure channel** so a slow remote subscriber piles cells on its own side without slowing the source (symmetric `topicFromWriter` for a writer-shaped source); `topicFromSpring(spring, options?)` is the simplest adapter, exposing a `makeSpring`-output spring directly to the exo layer, the spring's underlying retention discipline deciding changes-style vs latest-style; `hotTopicFromExoStream` / `coldTopicFromExoStream` lift a remote `PassableReader<T>`'s wire protocol into a topic, the **hot variant draining eagerly on construction** and the **cold variant lazily on first subscriber (cancelling when the last leaves)** — sibling adapters, not a `{ hot: boolean }` toggle, hot/cold preferred over eager/lazy as the established reactive-streams term; `readerFromTopic(topic, cancelled)` drops a passable topic back to a local `Reader<T>` (introspecting the exo's interface to pick `sinkChanges` vs `sinkLatest`); `patcherFromTopic(topic, initial, applyDelta, cancelled)` patches a local mirror value from a remote delta subscription, offering `current()` and `subscribe(observer)`; and `coalesceReader(reader, reduce, options?)` is consumer-side reader-to-reader middleware that folds bursts between drains into one accumulated value (a general `reduce` can express an operational transform; `debounceMs` adds time-based coalescing), the reusable generalization of the `retention-accumulator.js` coalesce-then-deliver primitive.

The exo-layer package is a set of adapters that decide, per-direction and per-facet, what crosses the wire and what stays local. Each adapter is one module under `packages/exo-pubsub/` (no barrel exports, per the project `CLAUDE.md`). The set is organized by **direction** (what is local, what is passable) and **facet** (publisher facet, topic facet); the asymmetric-passability framing explains why each adapter returns one facet rather than a pair.

## `topicFromReader(reader, options?)` — drop back-pressure to mint a topic from a single source

Given a local `Reader<T>`, mint a passable topic exo that fans the reader's iterations out to many remote subscribers. The adapter **drops the back-pressure channel** of the underlying reader: the topic consumes the reader as fast as it can and broadcasts to all attached subscribers. A slow remote subscriber piles cells on its own side without slowing the source.

```ts
function topicFromReader<T>(reader: Reader<T>, options?: { valuePattern?: Pattern, returnPattern?: Pattern }): PassableChangesTopicExo<T>;
```

Symmetric variant: `topicFromWriter(writer)` for the rare case where the adapter is given a writer-shaped local source. Underlying machinery: a `makeChangesPubSub` whose sink is fed by the reader's iteration loop, plus the topic-from-pubsub passable lift.

## `topicFromSpring(spring, options?)` — mint a topic from a single async promise linked list

Given a local `AsyncSpring<T>`, mint a passable topic exo whose subscribers each receive a fresh cursor on the spring's underlying chain; late subscribers begin at the chain's current head. This is the simplest adapter: it directly exposes the `makeSpring`-output of `@endo/pubsub` to the exo layer. The spring's underlying retention discipline determines whether the topic is changes-style (from `makeChangesPubSub`) or latest-style (from `makeLatestPubSub`). The convention is encoded in the exo's interface guard: a changes topic carries a `sinkChanges` method, a latest topic a `sinkLatest` method.

## `hotTopicFromExoStream` / `coldTopicFromExoStream` — lift a passable reader's wire protocol into a topic

Given a `PassableReader<T>` exo, lift it to a passable topic exo that fans the reader's remote iteration out to many subscribers on the receiving side. The adapter drains the passable reader once per topic and broadcasts to each subscriber's local spring — connecting a remote producer's exo-stream output to a local fan-out without forcing the producer to know how many consumers exist.

**Two variants, hot and cold** (maintainer: "We should have both ... I have seen the labels 'hot' versus 'cold' as well as 'lazy' versus 'eager'"). The distinction is *when the underlying passable reader starts draining*, the reactive-streams hot/cold axis (production independent of subscription vs deferred to it):

- **`hotTopicFromExoStream`** drains eagerly, on adapter construction, regardless of subscribers. Values flow off the wire immediately; a late subscriber begins at the chain's current head. This matches the "drop the back-pressure" framing.
- **`coldTopicFromExoStream`** drains lazily, starting on the first subscriber and stopping (cancelling the underlying exo-stream subscription) when the last subscriber leaves. No cost while no subscriber is attached, at the expense of per-first-subscriber start latency.

These are sibling adapters, not a `{ hot: boolean }` toggle. Hot/cold is preferred over eager/lazy because it is the established reactive-streams term for "production independent of subscription" versus "production deferred to subscription"; eager/lazy is retained only as the in-prose gloss.

```ts
type ExoStreamTopicOptions = { valuePattern?: Pattern, returnPattern?: Pattern, buffer?: number };
function hotTopicFromExoStream<T>(passableReader: ERef<PassableReader<T>>, options?: ExoStreamTopicOptions): PassableChangesTopicExo<T>;
function coldTopicFromExoStream<T>(passableReader: ERef<PassableReader<T>>, options?: ExoStreamTopicOptions): PassableChangesTopicExo<T>;
```

## `readerFromTopic(topic, cancelled)` — drop a passable topic to a local reader

The inverse: given a passable topic exo, drop it to a local `Reader<T>` on the consumer side (earlier revisions called this `iterateChanges` / `iterateLatest`; this revision keeps a single direction-named adapter).

```ts
function readerFromTopic<T>(topic: ERef<PassableChangesTopicExo<T> | PassableLatestTopicExo<T>>, cancelled: Promise<never>): Reader<T>;
```

The adapter introspects the topic exo's interface (via `__getMethodNames__()`) to decide which sink method to call (`sinkChanges` versus `sinkLatest`). The `cancelled` argument is the rejection-side of a `CancelKit`; settling it releases the per-consumer producer-side state.

## `patcherFromTopic(topic, applyDelta, cancelled)` — patch a local value from a remote subscription

Maintainer: "We can likewise create a patcher for a local value from a remote subscription." Given a passable changes topic and a delta-applying function, drain the topic against a caller-supplied initial value, applying each delta in arrival order.

```ts
function patcherFromTopic<T, D>(topic: ERef<PassableChangesTopicExo<D>>, initial: T, applyDelta: (current: T, delta: D) => T, cancelled: Promise<never>): { current(): T; subscribe(observer: (snapshot: T) => void): () => void; };
```

`current()` reads the patched value at any time; `subscribe(observer)` notifies on each delta apply. This is the local-side counterpart to a remote source publishing deltas to a topic: the caller patches a local mirror without writing the drain loop by hand.

## `coalesceReader(reader, reduce, options?)` — consumer-side coalescing middleware

Maintainer: "Let's specifically add the coalescing accumulator middleware ... The consumer of differential updates should have the option of providing a reducer function, including potentially an operational transform, that can relieve pressure or debounce updates." This is **consumer-side reader-to-reader middleware**, not a topic shape. Given a local `Reader<T>` (typically a `readerFromTopic` output on a changes topic) and a `reduce(accumulated, next)`, mint a downstream `Reader<A>` that folds the bursts the upstream delivers between drains into one accumulated value.

```ts
function coalesceReader<T, A>(reader: Reader<T>, reduce: (accumulated: A | undefined, next: T) => A, options?: { initial?: A, debounceMs?: number, cancelled?: Promise<never> }): Reader<A>;
```

- Between two consumer `get()` calls, the middleware drains everything ready and folds each value with `reduce`; the consumer sees one coalesced value, not the burst.
- `reduce` is general enough to express an **operational transform** (two array splices composed into one, two counter deltas summed). A `reduce` of `(_, next) => next` degenerates to latest-wins; a delta-composing `reduce` preserves losslessly while collapsing the count.
- `debounceMs` adds time-based coalescing: hold the accumulator up to the window, emit on window close or upstream termination.
- `cancelled` settles the middleware and propagates cancellation upstream.

The middleware is the reusable form of the `retention-accumulator.js` coalesce-then-deliver primitive from `daemon-cross-peer-gc`, generalized to a caller-provided `reduce` rather than that primitive's fixed microtask-batched set union. It lives on the consumer side by design: the consumer knows its own memory budget and staleness tolerance, so the consumer chooses the reducer and window; the topic bakes in no coalescing policy.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
