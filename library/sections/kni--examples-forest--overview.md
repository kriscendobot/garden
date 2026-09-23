---
title: "State-indexed procedural forest walk"
source: examples/forest.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A three-choice loop whose displayed tree is a stable hash-derived function of the current `x` coordinate, showing a decision graph rendering context from state while east and west choices update that state.

At each pass, the graph hashes `x` into one of four tree descriptions. East increments `x`, west decrements it, and leave exits; the loop returns to `start` after every non-exit choice. The rendered local context is therefore deterministic for a location without storing a separate world table.

For graph-driven context gathering, this isolates a useful pattern: derive the feedback shown to a user or agent from compact state, mutate that state through explicit options, then re-render. It also demonstrates that kni's graph can combine controlled decisions with deterministic procedural variation.

Source: [examples/forest.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/forest.kni) at commit `435ec3cf`.
