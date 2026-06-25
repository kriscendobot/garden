---
title: "Notifier pubsub migration: the problem and the local-layer reorientation"
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

> Abstract: Endo ships no pubsub primitive, at either the local async-iterator (`@endo/stream`) layer or the passable (`@endo/exo-stream`) layer. The closest in-tree precedents are `formulaChangeTopic` in `packages/daemon/src/daemon.js` (a single-purpose daemon-internal lossless topic) and the `retention-accumulator.js` coalesce-then-deliver primitive from the `daemon-cross-peer-gc` design; neither is reusable across packages nor carries the local-layer `Sink`/`Spring`/`Reader`/`Writer` vocabulary. `@agoric/notifier` (in agoric-sdk) is the design-vocabulary reference for the lossy/lossless taxonomy and the distributed-systems invariants (producer-not-vulnerable-to-consumers, consumers-mutually-independent); this design **borrows the taxonomy and invariants but does not retire `@agoric/notifier`** (its deprecation is the agoric-sdk maintainer's separate call). Revision 4 inverts the prior exo-rooted framing per maintainer direction: start from local pubsub foundations (`@endo/pubsub`) and treat the exo layer (`@endo/exo-pubsub`) as a set of lift/drop adapters rather than a fixed catalog of topic shapes. The whole family incubates on the `llm` branch (later projected to `master`, as `@endo/exo-stream` did) and is greenfield for Endo (no existing consumer migrates as a prerequisite; the eventual `formulaChangeTopic` replacement is a follow-up, not a precondition).

## The problem

Endo does not yet ship a pubsub primitive, either as a local async-iterator toolkit at the `@endo/stream` layer or as a passable interface at the `@endo/exo-stream` layer. The closest in-tree precedents are `formulaChangeTopic` in `packages/daemon/src/daemon.js` (a single-purpose daemon-internal lossless topic) and the `retention-accumulator.js` coalesce-then-deliver primitive from the `daemon-cross-peer-gc` design. Neither is reusable across packages, and neither carries the local-layer vocabulary (`Sink`, `Spring`, `Reader`, `Writer`) the rest of `@endo/stream` already uses.

`@agoric/notifier`, in agoric-sdk, is the de facto pubsub primitive in the broader Agoric ecosystem. It is the design-vocabulary reference for the lossy / lossless taxonomy (latest-only versus every-delta) and for the load-bearing distributed-systems invariants (producer-not-vulnerable-to-consumers, consumers-mutually-independent). This design borrows the taxonomy and the invariants; it does **not** retire `@agoric/notifier`. That package continues to ship from agoric-sdk and the agoric-sdk maintainer's schedule decides any future deprecation independently.

## Reorientation: start at the local layer

Earlier revisions were rooted at the exo layer (`@endo/exo-pubsub`) and treated the local layer as a sibling named in passing. Revision 4 inverts that, per the maintainer's framing on PR #507 review:

> in the way that `@endo/exo-stream` focuses on adapting local async iterators to passable readers, it may make more sense for us to start from local pubsub foundations including async promise queues (`@endo/stream` and `@endo/pubsub` layer) ... as well as adapters for sampling a value and changes to a value on demand. ... In the next iteration, I would like to focus on a broader but tighter set of adapters that lift and drop between passable and local pubsub primitives.

That collapses the prior "two topic shapes as exos" framing into a layered shape:

1. **A local `@endo/pubsub` package** at the `@endo/stream` layer. Two factories (`makeChangesPubSub`, `makeLatestPubSub`) returning a `{ sink, makeSpring }` kit over a shared async promise linked list. No exos, no CapTP, no `Passable` constraint on the value type.
2. **An `@endo/exo-pubsub` package** at the `@endo/exo-stream` layer. Not a fixed catalog of topic shapes, but a **set of adapters** that lift local pubsub primitives to passable topic / publisher exos, drop passable exos back to local readers / writers, and bridge to non-pubsub sources. Composing them is how a caller assembles the topology they need.

## Incubation and scope

Per the maintainer ("Please make the base for this build the llm branch. This will incubate here and later get projected out to a change on the master branch"), the whole package family incubates on the `llm` branch (design and implementation), the same shape `@endo/exo-stream` took. The packages are **greenfield for Endo**: no existing Endo or endo-but-for-bots consumer migrates onto them as a prerequisite. The only in-tree call site they will eventually replace is `formulaChangeTopic` in `packages/daemon/`, and that replacement is a follow-up rather than a precondition.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
