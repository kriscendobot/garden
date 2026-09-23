---
title: "@endo/pubsub cancellation, layering, and provenance"
source: packages/pubsub/README.md
source_repo: endojs/endo-but-for-bots
source_branch: feat/endo-pubsub
source_commit: d15e34cba55a24ff03f5ac414dae7a14d534d555
source_pr: endojs/endo-but-for-bots#513
source_pr_state: open
source_date: 2026-06-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-25
ingested_by: scholar
topics: [change-propagation, streams]
status: current
notes: |
  Unmerged open PR #513. Records the load-bearing change from earlier garden
  notes: @endo/pubsub does NOT ship its own makeCancelKit. The bundled
  cancel-kit and barrel index were dropped per review (commit d15e34cb,
  "drop bundled cancel-kit and barrel index per review"); makeCancelKit now
  lives in @endo/cancel.
---

> Abstract: Three closing facets of the `@endo/pubsub` README. **Cancellation:** `@endo/pubsub` does NOT ship its own cancellation primitive (a change from earlier revisions, which bundled `makeCancelKit`); a consumer pairs the topic with `@endo/cancel`'s `makeCancelKit` to terminate a consumer-driven iteration without disturbing the topic or its peer subscribers, racing its own `next()` against `cancelled` to break out of a `for await`. **Layering:** `@endo/pubsub` is the local-only layer (async-iterator-shaped objects, not passable over CapTP); the CapTP-passable counterpart is `@endo/exo-pubsub`, which lifts a local topic to a topic exo the same way `@endo/exo-stream`'s `PassableReader` / `PassableWriter` lift `@endo/stream`'s local `Reader<T>` / `Writer<T>`. **Provenance:** the async-promise-linked-list convention originally landed on `@endo/stream` in commit `cbbd57c03` (*"feat(stream): Introduce pubsub topics"*) and was removed during the `@endo/harden` refactor; the `notifier-pubsub-migration` design revisits the lossy/lossless taxonomy from `@agoric/notifier` and names this package's local-layer role.

## Cancellation

`@endo/pubsub` does not ship its own cancellation primitive. Pair it with [`@endo/cancel`](https://github.com/endojs/endo-but-for-bots/blob/d15e34cba55a24ff03f5ac414dae7a14d534d555/packages/pubsub/README.md)'s `makeCancelKit` to terminate a consumer-driven iteration without disturbing the topic itself or peer subscribers.

```js
import { makeCancelKit } from '@endo/cancel';

const { cancel, cancelled } = makeCancelKit();
// ... later
cancel(Error('done'));
// `cancelled` rejects with that error.
```

Subscribers can race their own `next()` against `cancelled` to break out of a `for await` loop that should stop on a local signal.

This is a deliberate change from earlier revisions of the package, which bundled a `makeCancelKit` export and a barrel index; commit `d15e34cb` ("refactor(pubsub): drop bundled cancel-kit and barrel index per review") removed both. The home for `makeCancelKit` is now `@endo/cancel`, a sibling package the design (#507) names as a prerequisite.

## Layering

`@endo/pubsub` is the local-only layer. Producers and subscribers are async-iterator-shaped JavaScript objects; they are not passable over CapTP. For the CapTP-passable counterpart, see `@endo/exo-pubsub` (proposed in the companion `notifier-pubsub-migration` design), which lifts a local topic to a topic exo via a `from-iterator`-style factory in the same way `@endo/exo-stream`'s `PassableReader` / `PassableWriter` lift `@endo/stream`'s local `Reader<T>` / `Writer<T>`.

## Provenance

The async-promise-linked-list convention this package uses originally landed on `@endo/stream` itself in commit `cbbd57c03` (*"feat(stream): Introduce pubsub topics"*) and was removed during the `@endo/harden` refactor. The `notifier-pubsub-migration` design document on the `llm` branch revisits the lossy / lossless taxonomy from `@agoric/notifier`'s notifier-pair and subscription-pair, names this package's local-layer role, and proposes `@endo/exo-pubsub` as its exo-layer sibling.

Source: [packages/pubsub/README.md](https://github.com/endojs/endo-but-for-bots/blob/d15e34cba55a24ff03f5ac414dae7a14d534d555/packages/pubsub/README.md) at commit `d15e34cb` (unmerged PR #513, branch `feat/endo-pubsub`).
