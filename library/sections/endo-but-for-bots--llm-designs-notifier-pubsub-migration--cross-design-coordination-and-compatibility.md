---
title: "Notifier pubsub migration: cross-design coordination, compatibility, durable pubsub deferred"
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

> Abstract: The design's coordination with neighboring work, its bundler-compatibility reasoning, and its scoped-out concerns. **Cross-design:** `daemon-message-streaming` is the closest exo-shaped streaming precedent (its `append`/`setPhase`/`end`/`abort` taxonomy collapses onto `next`/`return`/`throw`); `daemon-cross-peer-gc`'s `formulaChangeTopic` is the direct precedent for the changes-pubsub kit and `retention-accumulator.js` for consumer-side coalescing; `presence-severance-observation` (PR #450) is out of reach this iteration (not landed), so cancellation uses `makeCancelKit` and a future revision can wire `E.whenSevered(consumerPresence)` to settle the cancel kit when a CapTP session severs; `@endo/exo-stream` and `@endo/stream` are the composed substrate; and `@endo/cancel` is the not-yet-existing prerequisite home for `makeCancelKit`. **Compatibility:** the original endo#1035 motivation was a Parcel-bundler interaction with `@agoric/notifier`'s `@endo/marshal` dependency; the new packages avoid it — `@endo/pubsub` does not depend on `@endo/marshal` at all (local layer), and `@endo/exo-pubsub` depends on it only transitively through the exo layer, with no symlink-sensitive layouts and one module per export. **Durable pubsub is deferred** (it needs durable exos, a separate later design).

## Cross-design coordination

| Design | Relationship |
|---|---|
| `daemon-message-streaming` | The closest in-tree precedent for an exo-shaped streaming interface. Its four-event taxonomy (`append` / `setPhase` / `end` / `abort`) collapses onto the `next` / `return` / `throw` triple, which `publisherFromIterator`'s underlying iterator follows. A consumer wanting fan-out (one streaming source, many UI surfaces) wraps the source's local reader with `topicFromReader` to mint a passable topic. |
| `daemon-cross-peer-gc` | `formulaChangeTopic` is the direct in-tree precedent for the changes-pubsub kit. The `retention-accumulator.js` coalesce-then-deliver primitive is the precedent for the optional consumer-side delta-coalescing. The new packages generalize `formulaChangeTopic` from a single-purpose daemon-internal topic into a reusable kit plus adapter set. |
| `presence-severance-observation` (PR #450) | Out of reach for this iteration; the presence-severance design has not landed, so the adapters cannot rely on `E.whenSevered(presence)` to observe a remote consumer's CapTP severance. Cancellation uses `makeCancelKit`; once presence-severance lands, a future revision can wire `E.whenSevered(consumerPresence)` to settle the cancel kit's promise automatically, treating a severed remote consumer identically to a graceful cancellation. |
| `@endo/exo-stream` (`packages/exo-stream/`) | The new adapter set composes with it: `topicFromReader` calls `readerFromIterator` internally; `readerFromTopic` mirrors `iterateReader`'s consumer-side iterator construction. The packages depend on it for the bidirectional-promise-chain protocol primitives. |
| `@endo/stream` (`packages/stream/`) | The new local package is a sibling; both build on the Sink / Spring / Queue substrate. `@endo/pubsub` re-homes the existing `packages/daemon/src/pubsub.js` `makeChangePubSub` into a reusable location and adds the lossy variant. `makeQueue` and `makeStream` are the substrate; the new package does not reimplement them. |
| Earlier `@endo/stream` `makePubSub` + `makeTopic` (commit `cbbd57c03`, since removed) | Design-consistency anchor. The new `makeChangesPubSub` matches the removed `makePubSub` shape (sink + many independent springs over a shared async linked list); the kit-with-finish/fail surface is the additional discipline this design adds. |
| `@endo/cancel` (prerequisite, not yet on `llm`) | The home for `makeCancelKit`. The design is gated on the `@endo/cancel` package landing; both pubsub packages take it as a workspace dependency and import `makeCancelKit` rather than re-homing the primitive. Creating `@endo/cancel` is a separate prerequisite PR. |

## Compatibility considerations

The original endo#1035 motivation was a Parcel-bundler interaction where `@agoric/notifier`'s dependency on `@endo/marshal` re-used `@endo/marshal`'s identity across the agoric-sdk boundary in a way Parcel could not resolve through symlinks. The new packages avoid re-creating that pain:

- **`@endo/pubsub` does not depend on `@endo/marshal` at all.** It is a local-layer package; marshal involvement is impossible by layering.
- **`@endo/exo-pubsub` does not depend on `@endo/marshal` directly.** Pattern guards come from `@endo/patterns`; the exo machinery from `@endo/exo` (via `defineExoClassKit`); the stream contracts from `@endo/stream` and `@endo/exo-stream`. Marshal involvement is transitive at most.
- **No symlink-sensitive layouts.** Both packages are siblings of existing `@endo/*` packages in `packages/`, ship the same `tsconfig.composite.json` / `tsconfig.build.json` / `package.json` shape, and expose one module per exported function (no barrel exports).

## Durable pubsub deferred

Persistence of unread changes in `makeChangesPubSub` across a daemon restart, or persistence of the latest cell in `makeLatestPubSub`, is not in scope. The maintainer's framing: *"Not relevant at this layer. Durable pubsub is another concern that would require durable exos. We can introduce these later."* A future tracking issue revisits durable pubsub once durable exos exist; that work is a separate sibling design.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
