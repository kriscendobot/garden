---
title: "Labeled-room navigation with a configured variant"
source: examples/ship.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A large spatial state machine (~180 lines) in which each ship compartment is a returning label reached by a menu option, and a single variable `bridge.location`, set once at random on entry (`{~{=(forward) bridge.location}|{=(dorsal) bridge.location}}`), switches how several rooms describe themselves and where their "walk forward" edge leads. It shows how to author a sizeable navigable graph as many small labeled procedures sharing one configuration variable.

Movement options read like `+ [You c[C]limb upward.] ... ->dorsal.airlock`: the bracketed second-person text is the option surface and the trailing `->label` is the edge. Rooms are defined as returning labels (`- @hub ... <-`) so control flows back to the caller, letting compartments be composed. The conditional threads `- {?bridge.location == forward} ... - ...` select between two descriptions and two destinations for the same physical room depending on the configured layout — a clean pattern for "the same node behaves differently under a persistent configuration flag."

For decision-graph authoring, `ship` is the scaling example: dozens of nodes stay legible because each is a short label, edges are explicit `->` jumps, and cross-cutting variation is funneled through one variable rather than duplicated node sets. It is the interactive counterpart to `spacestation`'s static compartment outline.

Source: [examples/ship.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/ship.kni) at commit `435ec3cf`.
