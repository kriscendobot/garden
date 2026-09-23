---
title: "Notifier pubsub migration: @endo/pubsub local foundations (changes / latest kits, termination, cancellation)"
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
topics: [change-propagation, streams]
status: current
notes: Unmerged draft PR #507, revision 5; see the source-index file for the lifecycle caveat.
---

> Abstract: The design's specification of the local `@endo/pubsub` package: two factory functions over the existing `@endo/stream` Sink/Spring/Queue primitives, each returning a kit shape modeled on `packages/daemon/src/pubsub.js`'s `makeChangePubSub`. **`makeChangesPubSub<T>()`** is the lossless-deltas variant returning `{ sink, makeSpring, finish, fail }`: every subscriber sees every value delivered after its spring is minted, and a late spring sees only post-mint values (no history replay). **`makeLatestPubSub<T>()`** is the lossy variant with the identical kit shape but a latest-only retention policy: a spring sees the most recent value (if any) on first drain, then waits for the next publish. **Latest always replays to a late subscriber** is a settled decision, not an option (maintainer: "'Latest' should always replay latest to a late subscriber"); a caller wanting strictly-future values uses `makeChangesPubSub` instead. The kit-level `finish()` / `fail(error)` add producer-side termination so subscribers see a clean `done: true` or a thrown error rather than a hung spring. For consumer-side cancellation the design adopts `makeCancelKit()` whose home is **`@endo/cancel`** (a prerequisite package not yet on `llm`), so the design is gated on that package landing.

The local package exports two factory functions over the existing `@endo/stream` Sink / Spring / Queue primitives. Each returns a kit shape modeled on `packages/daemon/src/pubsub.js`'s `makeChangePubSub`.

## `makeChangesPubSub<T>()`

The lossless-deltas variant. Every subscriber sees every value delivered after its spring is minted. A spring minted late sees only values published after the mint; it does not replay history.

```ts
type ChangesPubSub<T> = {
  sink: AsyncSink<T>;
  makeSpring(): AsyncSpring<T>;
  finish(value?: undefined): void;
  fail(reason: Error): void;
};
```

```js
import { makeChangesPubSub } from '@endo/pubsub/changes-pubsub.js';

const { sink, makeSpring, finish, fail } = makeChangesPubSub();
sink.put('a');
const earlySpring = makeSpring();
sink.put('b');
const lateSpring = makeSpring();
sink.put('c');
finish();
// earlySpring sees: a, b, c, done
// lateSpring sees: c, done
```

Wrapping the spring with `makeStream(spring, nullIteratorQueue)` (the existing pattern in `packages/daemon/src/pubsub.js`) recovers a `Reader<T>` that a `for await` consumer drains. This package re-homes the daemon primitive to a reusable location and adds termination (`finish` / `fail`) at the kit level. The daemon's existing function keeps its current name during the migration window so this design's landing does not churn unrelated daemon call sites.

## `makeLatestPubSub<T>()`

The lossy variant. Every subscriber sees the most recent value (if any) on first drain, then waits for the next publish. Intermediate values that arrived while the subscriber was not drained are dropped. The kit shape is identical to `makeChangesPubSub`; the retention policy differs. Internally, `makeLatestPubSub` maintains one cell (the most recent published value) plus a "next" promise that resolves on the next publish.

```js
import { makeLatestPubSub } from '@endo/pubsub/latest-pubsub.js';

const { sink, makeSpring, finish } = makeLatestPubSub();
sink.put(1);
sink.put(2);
const spring = makeSpring();
const a = await spring.get();  // 2 (latest, not 1)
sink.put(3);
const b = await spring.get();  // 3
finish();
```

**Latest always replays to a late subscriber.** This is a settled decision, not an option. A spring minted after at least one value has been published resolves its first `get()` immediately with the most recent cell, then waits for the next publish. The maintainer's framing on the revision-4 review: *"'Latest' should always replay latest to a late subscriber."* There is no from-now-forward variant of `makeLatestPubSub`; a caller who wants strictly-future values without the initial replay uses `makeChangesPubSub` (whose late springs see only post-mint values).

## Termination and cancellation

`finish()` / `fail(error)` on each kit are the producer-side termination surface. `finish()` settles every active spring's pending `get()` with the terminal sentinel (the `Reader`-wrapping yields `{ done: true, value: undefined }`); `fail(error)` settles them with a rejection.

For **consumer-side cancellation**, the design adopts `makeCancelKit()` (maintainer: "Consider using `makeCancelKit`"):

```ts
type CancelKit = {
  cancel(reason?: Error): void;
  cancelled: Promise<never>;
};
```

A consumer that wants to stop draining a spring constructs a `CancelKit`, passes `cancelled` to the draining wrapper, and calls `cancel(reason)` when ready. This replaces the `makePromiseKit()` + manual-rejection idiom earlier revisions used inline.

**Home: `@endo/cancel`.** The maintainer expected `@endo/cancel` to already exist on `llm`; it does not (no `packages/cancel/`, no `makeCancelKit` export anywhere in the tree as of revision 5). The design is therefore **gated on the `@endo/cancel` package landing on `llm`**: `@endo/pubsub` and `@endo/exo-pubsub` take it as a workspace dependency and import `makeCancelKit` from it; neither re-homes the primitive nor ships an internal copy. Creating `@endo/cancel` is a prerequisite sibling PR.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
