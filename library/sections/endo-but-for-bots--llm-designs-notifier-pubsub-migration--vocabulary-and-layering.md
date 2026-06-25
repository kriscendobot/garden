---
title: "Notifier pubsub migration: vocabulary and package layering"
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

> Abstract: The design's term glossary and the package dependency graph. The vocabulary is the one `@endo/stream` and `@endo/exo-stream` already establish, plus gtor framing: `Sink<T>` (producer-facing half of an async queue, one method `put(value)`), `Spring<T>` (consumer-facing half, one method `get()` returning `Promise<T>`), `Queue<T>` (a Sink and Spring over one async promise linked list, from `makeQueue()`), `Reader<T>` / `Writer<T>` (the symmetric local async-iterator stream halves), and `PassableReader<T>` / `PassableWriter<T>` (their exo-layer duals over CapTP). The "pubsub" arrangement in this vocabulary is **one sink and many springs sharing one async promise linked list** — the shape `packages/daemon/src/pubsub.js` (`makeChangePubSub`) already uses, here generalized. Layering: `@endo/pubsub` and `@endo/exo-stream` are siblings, each built on `@endo/stream`; `@endo/exo-pubsub` builds on **both**, lifting and dropping between `@endo/pubsub`'s local kits and `@endo/exo-stream`'s passable readers/writers. The package boundaries match the line of "what can pass over CapTP" and "what cannot."

## Vocabulary

This design uses the vocabulary already established by `@endo/stream` and `@endo/exo-stream`, plus the framing from *A General Theory of Reactivity* (gtor). A reader unfamiliar with the terms reads gtor first.

| Term | Source | Meaning |
|---|---|---|
| `Sink<T>` | `@endo/stream` `types.d.ts` (`AsyncSink`) | The producer-facing half of an async queue. One method: `put(value)`. No return value; resolution is implicit. |
| `Spring<T>` | `@endo/stream` `types.d.ts` (`AsyncSpring`) | The consumer-facing half of an async queue. One method: `get()`, returns `Promise<T>`. |
| `Queue<T>` | `@endo/stream` | A `Sink<T>` and a `Spring<T>` over the same async promise linked list. `makeQueue()` returns the pair. |
| `Reader<T>` | `@endo/stream` | A local async iterator that yields `T`. A `Stream<T, undefined>` consumed via `for await`. |
| `Writer<T>` | `@endo/stream` | A local async iterator that consumes `T`. A `Stream<undefined, T>` driven via `next(value)`. |
| `PassableReader<T>` | `@endo/exo-stream` | The exo-layer dual of `Reader<T>`. An exo over CapTP whose `stream(synHead)` method yields the bidirectional-promise-chain head a remote consumer drains. |
| `PassableWriter<T>` | `@endo/exo-stream` | The exo-layer dual of `Writer<T>`. An exo whose `stream(synHead)` accepts the head a remote producer pushes onto. |
| stream (gtor) | gtor | The asynchronous-and-plural primitive combining iteration and promises with bidirectional flow control. A `Reader<T>` and `Writer<T>` together. |
| queue (gtor) | gtor | The asynchronous-plural primitive with `get`/`put` and no termination guarantees; the substrate `makeQueue` provides. |
| observable (gtor) | gtor | The synchronous-plural push primitive (`onNext`/`onReturn`/`onThrow`); the conceptual ancestor of a pubsub topic's "many subscribers, pushed values" shape. |

The "pubsub" arrangement, in this vocabulary, is **one sink and many springs sharing one async promise linked list**. The producer puts onto the sink; each subscriber's spring holds an independent cursor on the shared chain. This is the existing shape `packages/daemon/src/pubsub.js` (`makeChangePubSub`) uses; this design generalizes it.

## Layering

```
@endo/stream      (makeQueue, makeStream, makePipe, pump, prime)
  ├── @endo/pubsub      (local pubsub kits: makeChangesPubSub, makeLatestPubSub)
  └── @endo/exo-stream  (PassableReader, PassableWriter, iterateReader, ...)
        └── @endo/exo-pubsub  (adapter set: topic / publisher lifts and drops)
              └── (also builds on @endo/pubsub)
```

`@endo/pubsub` and `@endo/exo-stream` are siblings, each built on `@endo/stream`. `@endo/exo-pubsub` builds on **both**: it lifts and drops between `@endo/pubsub`'s local kits and `@endo/exo-stream`'s passable readers and writers. The package boundaries match the boundaries of "what can pass over CapTP" and "what cannot": a `Reader<T>` from `@endo/stream` cannot pass; a `PassableReader<T>` from `@endo/exo-stream` can; the local pubsub kit cannot; the passable topic / publisher exos that `@endo/exo-pubsub` mints can. The adapter set's job is to convert across the line, in either direction, one facet at a time.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
