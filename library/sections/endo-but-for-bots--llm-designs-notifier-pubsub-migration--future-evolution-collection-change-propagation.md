---
title: "Notifier pubsub migration: future evolution toward FRB collection-change propagation, and open questions"
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
topics: [change-propagation, streams, reactive-bindings]
status: current
notes: Unmerged draft PR #507, revision 5; see the source-index file for the lifecycle caveat. This section is the explicit design-side bridge to the sliding-window-topic concept.
---

> Abstract: The longer-term direction the maintainer names for `@endo/pubsub` / `@endo/exo-pubsub` ("Please also read in https://github.com/kriskowal/frb for how this might later evolve into a system for propagating changes to collections through transform relations with automated subscription and unsubscription"). FRB provides incremental collection-change propagation: arrays and collections dispatch granular change records (additions, removals, splices), transforms (`map`, `filter`, `sum`, `sorted`) propagate changes incrementally rather than recomputing, and bindings manage listener lifecycles automatically. A future evolution could carry that shape: a `ChangesPubSub<Splice<T>>` whose values are FRB-style range-change records (`{ plus, minus, index }`); transform adapters that consume a topic over change records and produce a derived topic over change records (so `topicFromReader(reader).map(fn)` is incremental, not full re-broadcast); and automatic subscription / unsubscription managed by the binding graph. **This evolution is explicitly NOT in scope** for the current iteration (which ships the `@endo/pubsub` substrate and the `@endo/exo-pubsub` adapter set); naming it ensures the substrate's value-type is not foreclosed, since the kits and adapters are parameterized on `T` and a future `T = SpliceChange<U>` instantiation is the migration onto FRB shape. The design's open questions are all resolved by revision 5 (cancel-kit home is `@endo/cancel`; latest always replays; hot/cold variants); the one cross-PR prerequisite is the `@endo/cancel` package, and the one parallel work item is the `@endo/pubsub` implementation PR (#513).

## Future evolution: collection-change propagation

The maintainer's review names a longer-term direction:

> Please also read in https://github.com/kriskowal/frb for how this might later evolve into a system for propagating changes to collections through transform relations with automated subscription and unsubscription.

FRB (Functional Reactive Bindings) provides incremental collection-change propagation: arrays and collections dispatch granular change records (additions, removals, splices), transforms (`map`, `filter`, `sum`, `sorted`) propagate changes incrementally rather than recomputing, and bindings manage listener lifecycles automatically (when a property path is replaced, old listeners detach and new ones attach to the updated graph).

A future evolution of `@endo/pubsub` / `@endo/exo-pubsub` could carry that shape:

- A `ChangesPubSub<Splice<T>>` whose values are FRB-style range-change records (`{ plus, minus, index }`) rather than opaque deltas.
- Transform adapters that consume a topic over change records and produce a derived topic over change records (the `topic.map(fn)` of a `topicFromReader(reader).map(fn)` chain would be incremental, not full re-broadcast).
- Automatic subscription / unsubscription managed by the binding graph, so a property-path replacement that affects a downstream topic detaches the old upstream and attaches a new one without the caller writing the wiring by hand.

This evolution is **not in scope for this design.** The current iteration ships the substrate (`@endo/pubsub`) and the adapter set (`@endo/exo-pubsub`). Once both are mature on `llm` and projected to `master`, the FRB-shaped extension is a sibling design that builds on top. Naming it here ensures the substrate's value-type is not foreclosed: the kits and adapters are parameterized on `T`, and a future `T = SpliceChange<U>` instantiation is the migration onto FRB shape.

## Open questions

The revision-4 open questions are resolved by the revision-5 review and folded into the design prose:

- **Home for `makeCancelKit`** is `@endo/cancel` (a prerequisite package, not yet on `llm`).
- **Latest replays to a late subscriber**, always.
- **The exo-stream-sourced topic has both a hot and a cold variant** (`hotTopicFromExoStream` / `coldTopicFromExoStream`).

No design-level open questions remain. The one cross-PR prerequisite is the `@endo/cancel` package; the one parallel work item is the `@endo/pubsub` implementation PR (#513), which this design stays aligned with.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
