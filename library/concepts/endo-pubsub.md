---
id: endo-pubsub
aliases: ["@endo/pubsub", "endo pubsub", "makePubSub", "pubsub", "sink and spring", "sink/spring", "Sink", "Spring", "makeChangeTopic", "makeLatestTopic", "makeCancelKit", "@endo/cancel", "nullSink", "nullSpring", "async promise linked list", "@endo/exo-pubsub", "exo-pubsub", "notifier-pubsub-migration", "makeChangesPubSub", "makeLatestPubSub", "topicFromReader", "topicFromSpring", "hotTopicFromExoStream", "coldTopicFromExoStream", "readerFromTopic", "patcherFromTopic", "coalesceReader", "publisherFromIterator", "publisherFromUpdateSampler", "publisherFromChangeSampler", "asymmetric passability", "hot and cold topics"]
topics: [change-propagation, streams]
status: current
---

# endo-pubsub

`@endo/pubsub` (built in `endojs/endo-but-for-bots#513`, on the `llm` branch) is the local-layer foundation for broadcast change propagation in Endo. Its primitive is **`makePubSub()`**: one **sink** (the producer/writer side) feeding many independent **springs** (subscriber/reader sides) over a single **shared async promise linked list** — the broadcast publish/subscribe shape from gtor (one setter, many getters, information flowing one direction, no continuity guarantee for a late subscriber). The linked list is the "async-singly-linked-list queue" that `@endo/stream`'s `makeQueue` realizes as promise-chain cons-cells (named in endo#1444). Two topic factories sit on this primitive and realize the [[changes-versus-latest]] duality:

- **`makeChangeTopic()`** — lossless deltas: every subscriber sees every value published after its iteration begins. Wraps `makeStream` over `makePubSub`, plus terminal-disposition tracking so a subscriber created after `return`/`throw` synthesizes the terminal rather than blocking on a never-resolving tail.
- **`makeLatestTopic()`** — lossy: only the most-recent value is retained (latest-cell + per-subscriber index tracking + replay-on-iterate), so a late subscriber sees the latest immediately and then blocks for future values.

Both factories return `{ publisher, subscribe }`, where the publisher is a local `@endo/stream` `Writer<TValue, TReturn>` and each `subscribe()` mints an independent `Reader<TValue, TReturn>`. The low-level entry point `makePubSub()` returns `{ pub, sub }` (`pub.put(value)` extends the shared async promise linked list, `sub()` mints a cursor). **The package ships no cancellation primitive of its own.** Earlier garden notes recorded a bundled `makeCancelKit` and `nullSink` / `nullSpring` helpers; commit `d15e34cb` ("drop bundled cancel-kit and barrel index per review") removed the bundled cancel kit and the barrel index. The README now directs callers to pair the topic with **`@endo/cancel`'s `makeCancelKit`** (a sibling package the design names as a prerequisite), racing a subscriber's own `next()` against `cancelled` to break out of a `for await`. See the ingested README sections below.

**Factory-name divergence to watch.** The #513 *implementation* (README at `d15e34cb`) names its factories `makeChangeTopic` / `makeLatestTopic` returning `{ publisher, subscribe }`; the #507 *design* names them `makeChangesPubSub` / `makeLatestPubSub` returning `{ sink, makeSpring, finish, fail }`. The two had not reconciled names as of 2026-06-25; both forms are recorded here from source. Re-check on the next cycle.

## Relationship to the design and the migration

The package implements the contract from the **notifier-pubsub-migration** design (`designs/notifier-pubsub-migration.md`, PR #507; now at **revision 5**, ingested as a library source — see the section table below), which gives Endo a pubsub primitive borrowing `@agoric/notifier`'s lossy/lossless taxonomy and distributed-systems invariants **without retiring `@agoric/notifier`** (its deprecation is the agoric-sdk maintainer's separate call). The design's revision 4 reorients to **two packages**: `@endo/pubsub` (local foundation; `makeChangesPubSub` / `makeLatestPubSub` kits of `{ sink, makeSpring, finish, fail }`) and `@endo/exo-pubsub` (an exo-layer **adapter set** lifting/dropping topics across CapTP, with "asymmetric passability" — a topic *or* its publisher is passable, rarely both). The adapter set is organized by direction and facet: topic-facet adapters (`topicFromReader` dropping back-pressure, `topicFromSpring`, hot/cold `*TopicFromExoStream`, `readerFromTopic`, `patcherFromTopic` for a local mirror, `coalesceReader` consumer-side coalescing middleware) and publisher-facet adapters (`publisherFromIterator`, `publisherFromUpdateSampler`, `publisherFromChangeSampler`). The design's *Future evolution: collection-change propagation* section names the FRB shape (range-change records, incremental transforms, automatic subscription/unsubscription) as the explicitly-out-of-scope future direction for pubsub — the bridge to [[sliding-window-topic]] and the synchronous FRB world.

Revision 5 settled three points from the revision-4 review: **`makeCancelKit`'s home is `@endo/cancel`** (a prerequisite package that does not yet exist on `llm`, so the design is gated on it landing); **latest always replays to a late subscriber** (no from-now-forward latest variant; a caller wanting strictly-future values uses the changes kit); and the **exo-stream-sourced topic has both a hot and a cold variant** (not a `{ hot: boolean }` toggle). Earlier-revision facts that no longer hold: the single-package `@endo/exo-pubsub` framing (revision 1) is superseded by the two-package split, and `makeUpdateTopic` (forward-lossless) is retired and recovered by composition. Remote-subscriber severance via `E.whenSevered(subscriberPresence)` (presence-severance-observation design #450) is **out of reach for this iteration** because #450 has not landed; cancellation uses `makeCancelKit` and a future revision wires severance onto it.

## Sections that touch this concept

As of 2026-06-25 the `@endo/pubsub` README (#513) and the notifier-pubsub-migration design (#507) are ingested as proper library sources (both from unmerged PR branches; re-check freshness against PR head per the source-index `notes:`). The gtor README sections ground the *mechanism* the package realizes (the async promise linked list, the sink/spring broadcast shape, the back-pressure handshake).

Ingested package and design sections:

| Section | One-line summary |
|---|---|
| [endo-but-for-bots--pkg-pubsub-readme--overview-and-topic-variants](../sections/endo-but-for-bots--pkg-pubsub-readme--overview-and-topic-variants.md) | The two topic factories (`makeChangeTopic` lossless, `makeLatestTopic` lossy) over a shared async promise linked list; both return `{ publisher, subscribe }`. |
| [endo-but-for-bots--pkg-pubsub-readme--sink-and-spring](../sections/endo-but-for-bots--pkg-pubsub-readme--sink-and-spring.md) | A topic decomposes into a publisher-side sink and per-subscriber spring cursors over one async promise linked list; `makePubSub()` → `{ pub, sub }`. |
| [endo-but-for-bots--pkg-pubsub-readme--change-and-latest-topics](../sections/endo-but-for-bots--pkg-pubsub-readme--change-and-latest-topics.md) | The Reader/Writer topic API and shared termination contract (`return`/`throw` settle every subscriber; late subscribers see the terminal without blocking). |
| [endo-but-for-bots--pkg-pubsub-readme--cancellation-layering-and-provenance](../sections/endo-but-for-bots--pkg-pubsub-readme--cancellation-layering-and-provenance.md) | No bundled cancel kit (pair with `@endo/cancel`); local-only layer; `cbbd57c03` provenance. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--problem-and-local-layer-reorientation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--problem-and-local-layer-reorientation.md) | Why Endo needs pubsub; borrow notifier's taxonomy/invariants without retiring it; the local-layer-first reorientation; greenfield/incubate-on-llm scope. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--asymmetric-passability](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--asymmetric-passability.md) | One of topic/publisher crosses the wire, rarely both; why each adapter returns one facet. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--vocabulary-and-layering](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--vocabulary-and-layering.md) | Sink/Spring/Queue/Reader/Writer/Passable* glossary; the package dependency graph. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--local-pubsub-foundations](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--local-pubsub-foundations.md) | `makeChangesPubSub` / `makeLatestPubSub` kits; latest-always-replays; `finish`/`fail`; cancel via `@endo/cancel`. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-topic-facet-adapters](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-topic-facet-adapters.md) | `topicFromReader`/`topicFromSpring`/hot+cold `*TopicFromExoStream`/`readerFromTopic`/`patcherFromTopic`/`coalesceReader`. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-publisher-facet-adapters](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-publisher-facet-adapters.md) | `publisherFromIterator`/`publisherFromUpdateSampler`/`publisherFromChangeSampler`; how the set composes asymmetric topologies. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--back-pressure-and-wire-protocol](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--back-pressure-and-wire-protocol.md) | Consumer-side backlog accumulation; producer-not-vulnerable-to-consumers; consumer-owned overflow policy. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--cross-design-coordination-and-compatibility](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--cross-design-coordination-and-compatibility.md) | Neighboring designs (#450 not landed); the `@endo/cancel` prerequisite; endo#1035 bundler avoidance; durable pubsub deferred. |
| [endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation.md) | The FRB collection-change-propagation direction (out of scope; the bridge to [[sliding-window-topic]]). |
| [gtor--readme--promise-queues-and-buffers](../sections/gtor--readme--promise-queues-and-buffers.md) | The asynchronous linked-list promise queue is exactly the "async-singly-linked-list queue" `makeQueue` realizes as cons-cells and the sink/spring linked list rides on. |
| [gtor--readme--promise-iterators-and-generators](../sections/gtor--readme--promise-iterators-and-generators.md) | The reader (spring/getter) and generator (sink/setter) sides; `forEach` returns a unicast task that cancels upstream; a promise iterator can proxy a *remote* reader. |
| [gtor--readme--reactivity-taxonomy](../sections/gtor--readme--reactivity-taxonomy.md) | Broadcast publish/subscribe (one setter, many getters, no continuity for a late subscriber), distinct from a unicast back-pressured stream. |

Primary journal citations (the design and build work itself):

- `entries/2026/06/23/164225Z-result-builder-801cc4.md` — the #513 build: package shape, factory names, the sink/spring + change/latest implementation, `makeCancelKit`, 30 passing tests, the graveyard-cursor trick on `throw`.
- `entries/2026/06/23/162601Z-result-designer-beaa6d.md` — design revision 4: the two-package layering, gtor vocabulary anchor (`Sink<T>`/`Spring<T>`/`Reader<T>`/`Writer<T>`), asymmetric passability, the collection-change-propagation future direction.
- `entries/2026/06/23/000406Z-result-researcher-a4a14d.md` — the research grounding: `@endo/stream` Reader/Writer symmetry, the notifier lossy/forward-lossless/fully-lossless taxonomy, the keyword writebacks.
- `entries/2026/06/23/002400Z-result-designer-372a37.md` — the earlier single-package framing (revision 1; superseded by the two-package reorientation).

(The earlier follow-on `scholar-ingest-endo-pubsub` ask is now satisfied: both sources were ingested 2026-06-25 by the `scholar-continue-change-propagation` cycle. Because both still live on unmerged PR branches — #513 open, #507 draft — the next cycle that touches this concept re-checks the PR heads per each source-index `notes:` and re-ingests on any material revision, especially a reconciliation of the factory-name divergence.)

## See also

- [[change-propagation]] — the async, temporal face of the through-line.
- [[changes-versus-latest]] — the duality the two topic factories realize.
- [[exo-stream]] — the CapTP bridge (`PassableReader`/`PassableWriter`) topics ride to cross vats.
- [[sliding-window-topic]] — the collection-change-propagation future direction the design names.
- [[functional-reactive-bindings]] — the synchronous, in-process counterpart whose range-change records the future direction borrows.

## Common confusions

- **`makeCancelKit` is NOT an `@endo/pubsub` export.** Earlier garden notes (and an earlier package revision) listed a bundled `makeCancelKit`; commit `d15e34cb` removed the bundled cancel kit and the barrel index per review. Its home is `@endo/cancel`, a sibling package the design names as a prerequisite that does not yet exist on `llm`. Do not assert `@endo/pubsub` ships cancellation.
- **`@endo/pubsub` vs `@endo/exo-pubsub`.** The first is the local-layer foundation (sink/spring, no CapTP); the second is the exo-layer adapter set that lifts topics to remote-passable refs. The two-package split is design revision 4; revision 1's single-package `@endo/exo-pubsub` framing is superseded.
- **Implementation and design names diverge.** #513's code uses `makeChangeTopic` / `makeLatestTopic` (`{ publisher, subscribe }`); #507's design uses `makeChangesPubSub` / `makeLatestPubSub` (`{ sink, makeSpring, finish, fail }`). Unreconciled as of 2026-06-25; cite whichever source you are reading and flag the divergence rather than assuming one name set is canonical.
- **Broadcast, not a stream.** A pubsub topic does not buffer for an absent subscriber the way a unicast stream does; a late subscriber to a change-topic sees only the future, and to a latest-topic sees only the latest. This is gtor's broadcast/discontinuity property, not a bug.
