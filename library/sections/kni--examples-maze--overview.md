---
title: "Coordinate-derived maze navigation"
source: examples/maze.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A looping coordinate maze that computes neighboring cell hashes, derives which directional options are open, and only renders movement choices whose guard is true.

The graph renders the current `(x, y)` position, calculates hashes for the current and four adjacent cells, derives four `.open` booleans from those values, then exposes a movement option for each open direction. Each selected option updates a coordinate and loops back to recompute the visible neighborhood.

This is a concrete example of feedback rendering as a deterministic function of gathered state. An agent-facing graph could use the same shape to calculate the applicable next questions from a context vector, present only legal branches, record the selected action, and render the newly relevant context on the next turn.

Source: [examples/maze.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/maze.kni) at commit `435ec3cf`.
