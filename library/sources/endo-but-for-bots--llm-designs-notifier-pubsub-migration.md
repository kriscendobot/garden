---
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
section_count: 8
status: current
notes: |
  Sourced from an unmerged DRAFT PR (#507, branch design/notifier-pubsub-migration),
  revision 5, incubating on the llm roadmap line. Re-check freshness against PR head:
    git --git-dir=worktrees/endojs-endo-but-for-bots.git fetch origin pull/507/head:refs/pull/507/head
    git --git-dir=worktrees/endojs-endo-but-for-bots.git log -1 --format=%H refs/pull/507/head -- designs/notifier-pubsub-migration.md
  On force-push / new revision → re-ingest from new HEAD (the design has revised
  five times; sections may need rewriting if the design changes materially).
  On merge → rewrite source_branch to the default branch, refresh source_commit,
  set source_pr_state: merged. On close-without-merge → mark this source and all
  endo-but-for-bots--llm-designs-notifier-pubsub-migration--* sections stale.

  Implementation companion: PR #513 (@endo/pubsub), ingested as
  endo-but-for-bots--pkg-pubsub-readme. Note the factory-name divergence between
  the two (design: makeChangesPubSub / makeLatestPubSub returning
  { sink, makeSpring, finish, fail }; implementation: makeChangeTopic /
  makeLatestTopic returning { publisher, subscribe }), unreconciled as of
  2026-06-25.
---

> Abstract: The `notifier-pubsub-migration` design (revision 5) on the `llm` roadmap branch of `endojs/endo-but-for-bots` (PR #507, draft). It specifies a two-package family that gives Endo a pubsub primitive borrowing `@agoric/notifier`'s lossy/lossless taxonomy and distributed-systems invariants without retiring `@agoric/notifier`: a local `@endo/pubsub` (two kits `makeChangesPubSub` / `makeLatestPubSub` returning `{ sink, makeSpring, finish, fail }` over a shared async promise linked list) and an exo-layer `@endo/exo-pubsub` reframed (revision 4) from a fixed catalog of topic shapes into a **set of lift/drop adapters** organized by direction and facet. The keystone framing is **asymmetric passability** (one of topic/publisher crosses the wire, rarely both), which makes each adapter return one facet. The adapter set covers topic-facet adapters (`topicFromReader`, `topicFromSpring`, hot/cold `*TopicFromExoStream`, `readerFromTopic`, `patcherFromTopic`, `coalesceReader`) and publisher-facet adapters (`publisherFromIterator`, `publisherFromUpdateSampler`, `publisherFromChangeSampler`). Back-pressure follows `@endo/exo-stream` (consumer-side accumulation). The design is gated on a prerequisite `@endo/cancel` package (home for `makeCancelKit`), defers durable pubsub, and names FRB collection-change propagation as the explicit out-of-scope future direction.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-local-layer-reorientation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--problem-and-local-layer-reorientation.md) | change-propagation, streams | current |
| [asymmetric-passability](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--asymmetric-passability.md) | change-propagation, streams, captp | current |
| [vocabulary-and-layering](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--vocabulary-and-layering.md) | change-propagation, streams | current |
| [local-pubsub-foundations](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--local-pubsub-foundations.md) | change-propagation, streams | current |
| [exo-pubsub-topic-facet-adapters](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-topic-facet-adapters.md) | change-propagation, streams, captp | current |
| [exo-pubsub-publisher-facet-adapters](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--exo-pubsub-publisher-facet-adapters.md) | change-propagation, streams, captp | current |
| [back-pressure-and-wire-protocol](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--back-pressure-and-wire-protocol.md) | change-propagation, streams, captp | current |
| [cross-design-coordination-and-compatibility](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--cross-design-coordination-and-compatibility.md) | change-propagation, streams | current |
| [future-evolution-collection-change-propagation](../sections/endo-but-for-bots--llm-designs-notifier-pubsub-migration--future-evolution-collection-change-propagation.md) | change-propagation, streams, reactive-bindings | current |

(The design's own "Prompt" and "Library and project references" sections are meta-navigation, not library content, and are not ingested as sections.)

## See also

- [endo-but-for-bots--pkg-pubsub-readme](endo-but-for-bots--pkg-pubsub-readme.md) — the `@endo/pubsub` implementation companion (#513).
- [endo--pkg-stream-readme](endo--pkg-stream-readme.md) — the `@endo/stream` Reader/Writer/Sink/Spring substrate.
- [agoric-sdk--pkg-notifier-readme](agoric-sdk--pkg-notifier-readme.md) — the lossy/lossless taxonomy and distributed-operation invariants this design borrows.
- [frb--readme](frb--readme.md) — the FRB collection-change-propagation shape named as the future direction.
