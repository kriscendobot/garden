---
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
section_count: 4
status: current
notes: |
  Sourced from an unmerged open PR (#513, branch feat/endo-pubsub), which
  incubates on the llm roadmap line. Re-check freshness against PR head before
  relying on details:
    git --git-dir=worktrees/endojs-endo-but-for-bots.git fetch origin pull/513/head:refs/pull/513/head
    git --git-dir=worktrees/endojs-endo-but-for-bots.git log -1 --format=%H refs/pull/513/head -- packages/pubsub/README.md
  On force-push → re-ingest from new HEAD. On merge → rewrite source_branch to
  the default branch, refresh source_commit, set source_pr_state: merged, drop
  the unmerged caveat. On close-without-merge → mark this source and all
  endo-but-for-bots--pkg-pubsub-readme--* sections stale.

  Naming divergence to watch: this implementation (#513) names its factories
  makeChangeTopic / makeLatestTopic returning { publisher, subscribe }; the
  companion design #507 names them makeChangesPubSub / makeLatestPubSub
  returning { sink, makeSpring, finish, fail }. The two had not reconciled
  names as of this ingest (2026-06-25). makeCancelKit was removed from this
  package (now lives in @endo/cancel).
---

> Abstract: The README of `@endo/pubsub`, the local-layer pubsub package built in `endojs/endo-but-for-bots#513` (branch `feat/endo-pubsub`, incubating on the `llm` roadmap line). It documents two topic factories over a shared async promise linked list — `makeChangeTopic` (lossless deltas) and `makeLatestTopic` (lossy latest-only) — both returning `{ publisher, subscribe }` with the publisher a `Writer<T>` and each subscriber a `Reader<T>` from `@endo/stream`. The package decomposes a topic into a publisher-side sink and per-subscriber springs over a single async promise linked list (the primitive `@endo/stream` introduced in `cbbd57c03` and later removed). It ships no cancellation primitive of its own (pair with `@endo/cancel`'s `makeCancelKit`) and is the local sibling of `@endo/exo-stream`; the exo-layer counterpart `@endo/exo-pubsub` is proposed in the `notifier-pubsub-migration` design (#507). This is the implementation companion to that design; see the source-index file for [notifier-pubsub-migration](endo-but-for-bots--llm-designs-notifier-pubsub-migration.md).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-topic-variants](../sections/endo-but-for-bots--pkg-pubsub-readme--overview-and-topic-variants.md) | change-propagation, streams | current |
| [sink-and-spring](../sections/endo-but-for-bots--pkg-pubsub-readme--sink-and-spring.md) | change-propagation, streams | current |
| [change-and-latest-topics](../sections/endo-but-for-bots--pkg-pubsub-readme--change-and-latest-topics.md) | change-propagation, streams | current |
| [cancellation-layering-and-provenance](../sections/endo-but-for-bots--pkg-pubsub-readme--cancellation-layering-and-provenance.md) | change-propagation, streams | current |

## See also

- [endo-but-for-bots--llm-designs-notifier-pubsub-migration](endo-but-for-bots--llm-designs-notifier-pubsub-migration.md) — the companion design (#507): the `@endo/pubsub` + `@endo/exo-pubsub` layering, the adapter set, and the `@endo/cancel` gating.
- [endo--pkg-stream-readme](endo--pkg-stream-readme.md) — the `@endo/stream` Reader/Writer/Sink/Spring substrate this package builds on.
