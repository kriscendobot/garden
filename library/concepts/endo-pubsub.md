---
id: endo-pubsub
aliases: ["@endo/pubsub", "endo pubsub", "makePubSub", "pubsub", "sink and spring", "sink/spring", "Sink", "Spring", "makeChangeTopic", "makeLatestTopic", "makeCancelKit", "nullSink", "nullSpring", "async promise linked list", "@endo/exo-pubsub", "exo-pubsub", "notifier-pubsub-migration", "makeChangesPubSub", "makeLatestPubSub"]
topics: [change-propagation, streams]
status: current
---

# endo-pubsub

`@endo/pubsub` (built in `endojs/endo-but-for-bots#513`, on the `llm` branch) is the local-layer foundation for broadcast change propagation in Endo. Its primitive is **`makePubSub()`**: one **sink** (the producer/writer side) feeding many independent **springs** (subscriber/reader sides) over a single **shared async promise linked list** — the broadcast publish/subscribe shape from gtor (one setter, many getters, information flowing one direction, no continuity guarantee for a late subscriber). The linked list is the "async-singly-linked-list queue" that `@endo/stream`'s `makeQueue` realizes as promise-chain cons-cells (named in endo#1444). Two topic factories sit on this primitive and realize the [[changes-versus-latest]] duality:

- **`makeChangeTopic()`** — lossless deltas: every subscriber sees every value published after its iteration begins. Wraps `makeStream` over `makePubSub`, plus terminal-disposition tracking so a subscriber created after `return`/`throw` synthesizes the terminal rather than blocking on a never-resolving tail.
- **`makeLatestTopic()`** — lossy: only the most-recent value is retained (latest-cell + per-subscriber index tracking + replay-on-iterate), so a late subscriber sees the latest immediately and then blocks for future values.

Supporting exports: **`makeCancelKit()`** (a small `{ cancel, cancelled }` primitive over `makePromiseKit`, mirroring the daemon's `Context['cancel']`/`Context['cancelled']` discipline; the maintainer suggested it and no prior such primitive existed) and **`nullSink` / `nullSpring`** helpers. Publisher conforms to the `Stream` shape (`next`/`return`/`throw`); subscriber conforms to `PassableReader` (`stream`, `readPattern`, `readReturnPattern`), so topics ride CapTP via `@endo/exo-stream`.

## Relationship to the design and the migration

The package implements the contract from the **notifier-pubsub-migration** design (`designs/notifier-pubsub-migration.md`, PR #507), which migrates `@agoric/notifier`'s topic shapes out of agoric-sdk into Endo. The design's revision 4 reorients to **two packages**: `@endo/pubsub` (local foundation; `makeChangesPubSub` / `makeLatestPubSub` kits of `{ sink, makeSpring, finish, fail }`) and `@endo/exo-pubsub` (an exo-layer adapter set lifting/dropping topics across CapTP, with "asymmetric passability" — a topic *or* its publisher is passable, rarely both). The design's *Future evolution: collection-change propagation* section names the FRB shape (range-change records, incremental transforms, automatic subscription/unsubscription) as the future direction for pubsub — the explicit bridge to [[sliding-window-topic]] and the synchronous FRB world. `makeUpdateTopic` (forward-lossless) is retired and recovered by composition (changes + one-shot `latestSnapshot()`). Remote-subscriber severance is handled via `E.whenSevered(subscriberPresence)` per the presence-severance-observation design (#450), treated as an implicit `return()`.

## Sections that touch this concept

The `@endo/pubsub` package and the notifier-pubsub-migration design are not yet ingested as library sources, but the gtor README sections below ground the *mechanism* the package realizes (the async promise linked list, the sink/spring broadcast shape, and the back-pressure handshake):

| Section | One-line summary |
|---|---|
| [gtor--readme--promise-queues-and-buffers](../sections/gtor--readme--promise-queues-and-buffers.md) | The asynchronous linked-list promise queue (`head` promise / `tail` deferred, get-before-put) is exactly the "async-singly-linked-list queue" `makeQueue` realizes as cons-cells and the sink/spring linked list rides on; the two-queue buffer realizes pressure as a returned acknowledgement promise. |
| [gtor--readme--promise-iterators-and-generators](../sections/gtor--readme--promise-iterators-and-generators.md) | The reader (spring/getter) and generator (sink/setter) sides; `forEach` returns a unicast task that cancels upstream; a promise iterator can proxy a *remote* reader (the `@endo/exo-stream` `PassableReader` seam). |
| [gtor--readme--reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | Broadcast publish/subscribe (one setter, many getters, no continuity for a late subscriber) is the shape a pubsub topic instantiates, distinct from a unicast back-pressured stream. |

Primary journal citations (the design and build work itself):

- `entries/2026/06/23/164225Z-result-builder-801cc4.md` — the #513 build: package shape, factory names, the sink/spring + change/latest implementation, `makeCancelKit`, 30 passing tests, the graveyard-cursor trick on `throw`.
- `entries/2026/06/23/162601Z-result-designer-beaa6d.md` — design revision 4: the two-package layering, gtor vocabulary anchor (`Sink<T>`/`Spring<T>`/`Reader<T>`/`Writer<T>`), asymmetric passability, the collection-change-propagation future direction.
- `entries/2026/06/23/000406Z-result-researcher-a4a14d.md` — the research grounding: `@endo/stream` Reader/Writer symmetry, the notifier lossy/forward-lossless/fully-lossless taxonomy, the keyword writebacks.
- `entries/2026/06/23/002400Z-result-designer-372a37.md` — the earlier single-package framing (revision 1; superseded by the two-package reorientation).

A follow-on `scholar-ingest-endo-pubsub` job should ingest the `@endo/pubsub` README + the notifier-pubsub-migration design as proper library sources once #513 / #507 stabilize.

## See also

- [[change-propagation]] — the async, temporal face of the through-line.
- [[changes-versus-latest]] — the duality the two topic factories realize.
- [[exo-stream]] — the CapTP bridge (`PassableReader`/`PassableWriter`) topics ride to cross vats.
- [[sliding-window-topic]] — the collection-change-propagation future direction the design names.
- [[functional-reactive-bindings]] — the synchronous, in-process counterpart whose range-change records the future direction borrows.

## Common confusions

- **`@endo/pubsub` vs `@endo/exo-pubsub`.** The first is the local-layer foundation (sink/spring, no CapTP); the second is the exo-layer adapter set that lifts topics to remote-passable refs. The two-package split is design revision 4; revision 1's single-package `@endo/exo-pubsub` framing is superseded.
- **Broadcast, not a stream.** A pubsub topic does not buffer for an absent subscriber the way a unicast stream does; a late subscriber to a change-topic sees only the future, and to a latest-topic sees only the latest. This is gtor's broadcast/discontinuity property, not a bug.
