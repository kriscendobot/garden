---
title: "Notifier pubsub migration: @endo/exo-pubsub publisher-facet adapters and adapter-set asymmetry"
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

> Abstract: The **publisher-facet adapters** of `@endo/exo-pubsub` (producer becomes passable, or comes from passable), plus how the adapter set carries asymmetric passability structurally. `publisherFromIterator(iterator, options?)` mints a passable publisher exo from a local async iterator (the dual of `@endo/exo-stream`'s `writerFromIterator`); a remote producer's `E(publisher).next(value)` routes through the iterator's `next(value)` for local side effects, then puts on a caller-controlled sink. `publisherFromUpdateSampler(sample, schedule, options?)` mints a publisher from a value sampler: each `schedule` firing emits the current `sample()`, wired into a `makeLatestPubSub` so remote subscribers see only the most recent (suitable for "latest" surfaces); returns `{ publisher, stop }`. `publisherFromChangeSampler(sample, diff, schedule, options?)` mints a publisher from a differential change sampler: each non-null `diff(prev, next)` is emitted, wired into a `makeChangesPubSub` (suitable for "changes" surfaces; the adapter the daemon-cross-peer-gc retention-accumulator pattern would lift to). Asymmetry as structure: a caller wanting passable-topic + local-publisher assembles `topicFromSpring(spring)` plus the kit's local `sink`; a caller wanting passable-publisher + local-topic assembles `publisherFromIterator` plus the kit's local `makeSpring()`; both-passable requires composing two adapters explicitly so the unusual topology is acknowledged.

## Publisher facet adapters

### `publisherFromIterator(iterator, options?)` — mint a passable publisher from a local async iterator

```ts
function publisherFromIterator<T>(iterator: AsyncIterator<T>, options?: { writePattern?: Pattern, writeReturnPattern?: Pattern }): PassablePublisherExo<T>;
```

The dual of `@endo/exo-stream`'s `writerFromIterator`. A remote producer calls `E(publisher).next(value)`; the adapter routes the value through the iterator's `next(value)` for any local acknowledgement or side-effect, then puts on a sink the caller controls.

### `publisherFromUpdateSampler(sample, schedule, options?)` — mint a publisher from a value sampler

Maintainer: "We can create a publisher from an async iterator or an update sampler." Given a synchronous-or-async `sample()` returning the current value, plus a `schedule(callback)` that fires whenever the thing might have changed, mint a passable publisher exo that emits the current sample on each schedule firing.

```ts
function publisherFromUpdateSampler<T>(sample: () => T | Promise<T>, schedule: (callback: () => void) => () => void, options?: { valuePattern?: Pattern }): { publisher: PassablePublisherExo<T>; stop(): void; };
```

Suitable for "latest" surfaces: the publisher is wired into a `makeLatestPubSub` so each remote subscriber sees only the most recent sample. `stop()` releases the schedule subscription and finalizes the underlying pubsub.

### `publisherFromChangeSampler(sample, diff, schedule, options?)` — mint a publisher from a differential change sampler

Maintainer: "... or a differential change sampler given a diff function." Given a `sample()`, a `diff(prev, next)` returning the change (or a sentinel `null`/`undefined` for "no change"), and a `schedule(callback)`, mint a passable publisher exo that emits the diff on each non-null change.

```ts
function publisherFromChangeSampler<T, D>(sample: () => T | Promise<T>, diff: (prev: T, next: T) => D | undefined, schedule: (callback: () => void) => () => void, options?: { deltaPattern?: Pattern }): { publisher: PassablePublisherExo<D>; stop(): void; };
```

Suitable for "changes" surfaces: wired into a `makeChangesPubSub` so each subscriber receives every diff. This is the adapter the daemon-cross-peer-gc retention-accumulator pattern would lift to, were its current single-mutation-surface refactored onto the new package.

## Asymmetry in the adapter set

The set carries the asymmetric-passability framing as a structural property:

- A caller wanting a **passable topic and a local publisher** assembles `topicFromSpring(spring)` to expose the topic facet; the local kit's `sink` is the local publisher and needs no adapter.
- A caller wanting a **passable publisher and a local topic** assembles `publisherFromIterator(iterator)` (or a sampler variant) to expose the publisher facet; the local kit's `makeSpring()` is the local topic / fan-out and needs no adapter.
- A caller wanting **both facets passable** (the unusual case) composes two adapters in the same process, both reading or writing the same underlying local kit. The design provides no single-call factory for this; the composition is explicit so the caller acknowledges the topology.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
