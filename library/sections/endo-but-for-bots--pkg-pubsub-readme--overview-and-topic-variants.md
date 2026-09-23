---
title: "@endo/pubsub overview and topic variants"
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
  Sourced from an unmerged open PR (#513, branch feat/endo-pubsub). Re-check
  freshness against the PR head before relying on details. On force-push →
  re-ingest; on merge → rewrite source_branch to the default branch and refresh
  source_commit; on close-without-merge → mark this source and all
  endo-but-for-bots--pkg-pubsub-readme--* sections stale. The implementation in
  #513 names its factories makeChangeTopic / makeLatestTopic returning
  { publisher, subscribe }; the companion design #507 names them
  makeChangesPubSub / makeLatestPubSub returning { sink, makeSpring, finish, fail }.
  The two had not converged on names as of this ingest.
---

> Abstract: `@endo/pubsub` is the local-layer pubsub package being built in `endojs/endo-but-for-bots#513` (branch `feat/endo-pubsub`, incubating on the `llm` roadmap line). It ships two topic factories over a shared async promise linked list: `makeChangeTopic` (lossless deltas: every value published after a subscriber begins iterating reaches that subscriber, with slow subscribers accumulating undrained nodes in their own cursor closure rather than in the producer's state) and `makeLatestTopic` (lossy: a slow subscriber observes only the most recent value, intermediate values overwritten). Both return `{ publisher, subscribe }` where the publisher is a local `Writer<TValue, TReturn>` from `@endo/stream` and `subscribe()` returns an independent local `Reader<TValue, TReturn>`; publishers and subscribers compose with `pump`, `makePipe`, and `prime` from `@endo/stream`. The package is a sibling of `@endo/exo-stream` at the local layer; the exo-layer counterpart `@endo/exo-pubsub` (proposed in the `notifier-pubsub-migration` design) lifts the same topology onto CapTP-passable exo refs.

`@endo/pubsub` ships two topic variants:

- `makeChangeTopic` builds a **lossless deltas** topic. Every value published after a subscriber begins iterating reaches that subscriber. Slow subscribers accumulate undrained nodes in their own cursor closure rather than in the producer's state.
- `makeLatestTopic` builds a **lossy** topic. A slow subscriber observes only the most recent value the producer has published; intermediate values are overwritten.

Both factories return `{ publisher, subscribe }` where the publisher is a local `Writer<TValue, TReturn>` from `@endo/stream` and `subscribe()` returns an independent local `Reader<TValue, TReturn>`. Publishers and subscribers compose with `pump`, `makePipe`, and `prime` from `@endo/stream` at the local layer.

`@endo/pubsub` is a sibling of `@endo/exo-stream` at the local layer; the exo-layer counterpart `@endo/exo-pubsub` (proposed in the `notifier-pubsub-migration` design on the `llm` roadmap branch) lifts the same topology onto CapTP-passable exo refs.

Source: [packages/pubsub/README.md](https://github.com/endojs/endo-but-for-bots/blob/d15e34cba55a24ff03f5ac414dae7a14d534d555/packages/pubsub/README.md) at commit `d15e34cb` (unmerged PR #513, branch `feat/endo-pubsub`).
