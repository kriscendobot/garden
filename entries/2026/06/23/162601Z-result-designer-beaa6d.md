---
ts: 2026-06-23T16:26:01Z
kind: result
role: designer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--beaa6d/project
---

Revision 4 of `designs/notifier-pubsub-migration.md` landed on
`design/notifier-pubsub-migration` at HEAD `528458a29`, force-pushed
with lease anchor `7688d2ac1`. The PR (#507) remains DRAFT pending the
maintainer's review of the reorientation.

## What changed in revision 4

Centroid shift: from "a single `@endo/exo-pubsub` package with two
topic-shape factories" to "two packages (local foundation + exo-layer
adapter set) with structural asymmetric passability." The shift
responds to kriskowal's CHANGES_REQUESTED review (id 4554406302, three
inline comments) on revision 3.

### Sections added or rewritten

- *What is the Problem Being Solved?* — narrowed framing; centered on
  the local-layer gap as well as the exo-layer gap.
- *Reorientation: start at the local layer* — new section; carries the
  maintainer's verbatim direction and inverts the prior framing.
- *Asymmetric passability* — new section; encodes "topic OR publisher
  passable, rarely both" as a structural property of the adapter set.
- *Incubation on `llm`* — new section; explicit
  incubate-on-`llm`-project-to-`master` framing per inline comment
  3460690829.
- *Vocabulary* — new section; gtor anchor with a per-term table
  (`Sink<T>` / `Spring<T>` / `Reader<T>` / `Writer<T>` / `PassableReader<T>` /
  `PassableWriter<T>` / stream / queue / observable from gtor) and the
  pubsub definition (one sink, many springs over one async promise
  linked list).
- *Layering* — replaced. New mermaid graph: `@endo/pubsub` and
  `@endo/exo-stream` as siblings on `@endo/stream`; `@endo/exo-pubsub`
  builds on both.
- *`@endo/pubsub`: local pubsub foundations* — new top-level section;
  describes `makeChangesPubSub` and `makeLatestPubSub` (kits with
  `{ sink, makeSpring, finish, fail }`).
- *Termination and cancellation* — new section; adopts `makeCancelKit`
  per inline comment 3460690829 and names its home (`@endo/promise-kit`
  vs. `@endo/pubsub`-internal) in *Open questions*.
- *`@endo/exo-pubsub`: the adapter set* — replaces the prior *The topic
  shapes* section. Recasts the exo-layer package as a set of
  lift/drop adapters.
- *Future evolution: collection-change propagation* — new section;
  frames FRB shape (range-change records, incremental transforms,
  automatic subscription / unsubscription) as future direction. Out
  of scope for this iteration.
- *Open questions* — rewritten; three questions for the maintainer's
  judgment.

### Sections removed

- *Scope and home* (the prior single-package framing).
- *The topic shapes* (subscriber surface; `makeLatestTopic`;
  `makeChangeTopic`; `makeUpdateTopic (eliminated)`).
- *Producer as a passable `PassableWriter<T>`*.
- *Topic exo and iterator adapters*.
- *Exo-streams coherence* (the constraint is now a per-adapter
  property rather than a separate coherence section).
- *Method-name evolvability* (the adapter-set framing makes
  evolvability a per-adapter sibling-add story, not a single section).

## gtor concepts used

From gtor's classification framework:

- `Stream` (async, plural, bidirectional). The substrate `@endo/stream`
  models with `Reader`+`Writer` and the exo layer
  `@endo/exo-stream` lifts.
- `Queue` (async, plural, bidirectional, no termination guarantees).
  The substrate `makeQueue` provides; the kits build on it.
- `Observable` (sync, plural, push). The conceptual ancestor of the
  pubsub "many subscribers, pushed values" shape. Not directly used
  but cited for the per-facet adapter motivation.
- The plural-asynchronous-push vs. plural-asynchronous-bidirectional
  distinction in gtor motivates why the adapter set decides
  per-facet rather than per-pair.

## Adapter set enumerated

Topic-facet adapters (consumer fan-out becomes passable, or comes from
passable):

- `topicFromReader(reader)` — drops back-pressure.
- `topicFromWriter(writer)` — symmetric variant for writer-shaped
  sources.
- `topicFromSpring(spring)` — topic from a Spring.
- `topicFromExoStream(passableReader)` — topic from the exo-stream
  wire protocol.
- `readerFromTopic(topic, cancelled)` — drop a passable topic to a
  local Reader.
- `patcherFromTopic(topic, initial, applyDelta, cancelled)` — patcher
  for a local value from a remote subscription.

Publisher-facet adapters (producer becomes passable, or comes from
passable):

- `publisherFromIterator(iterator)` — passable publisher from a local
  async iterator.
- `publisherFromUpdateSampler(sample, schedule)` — publisher from a
  value sampler (latest-style).
- `publisherFromChangeSampler(sample, diff, schedule)` — publisher
  from a differential change sampler.

All nine adapters are named in inline comment 3460790765 (line 318) or
its references.

## Inline replies and top-level summary

Replied on each of the three inline comments:

- Reply to 3460676479 (line 98, builder direction): comment id
  3461290844.
- Reply to 3460690829 (line 320, `makeCancelKit` + incubate-on-llm):
  comment id 3461291343.
- Reply to 3460790765 (line 318, full reorientation): comment id
  3461295422.

Top-level summary comment @-mentioning @kriskowal posted at
`https://github.com/endojs/endo-but-for-bots/pull/507#issuecomment-4781274678`.

## Lease anchor

`7688d2ac1` (the revision-3 HEAD). Force-with-lease push succeeded
on first attempt; no conflict.

## New HEAD

`528458a29`.

## Self-improvement

The dispatch prompt enumerated all nine adapters from inline comment
3460790765 ahead of time, which made the *Adapter set* section a
direct translation of the prompt's bullet list. The library
references at the bottom of the design document (the prior
*Library and project references* section from revision 3, kept and
trimmed) carried the gtor framing forward correctly: the next
designer touching a similar pubsub/stream/observable framing has a
gtor reference path ready. Nothing this time.
