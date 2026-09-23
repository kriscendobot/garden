---
title: §"Line numbers, not pointers, for buffer edits" — deterministic ID discipline
source-slug: endo-but-for-bots--llm-designs-endor-bus-tui
section-slug: worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-bus-tui.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endor-bus-tui.md
source-author: Kris Kowal (prompted)
total-lines: 1148
ingest-cycle: 271
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-daemon-verbs-at-worker
---

Design Decision 3 (lines 1056-1061):

> *Line numbers, not pointers, for buffer edits. `editLine` takes a numeric line ID rather than a handle-to-a-line because line numbers survive scrollback eviction deterministically and require no cleanup on the worker side. A line that has scrolled out returns an error on edit; the worker decides whether to append instead.*

§First-explicit-observation in library: **§deterministic-ID-discipline — §when-a-resource-may-be-evicted, §use-a-numeric-ID-rather-than-a-handle-because-the-ID-survives-eviction-deterministically + §the-eviction-IS-implicit + §the-worker-handles-the-eviction-error-rather-than-tracking-the-eviction**.

§Sibling-pattern to many database systems' row-ID conventions; §three-cycles-with-deterministic-ID-discipline (would need cross-check; this is the first explicit observation in the library).

§the-eviction-error-discipline — §when-the-resource-IS-gone, §the-operation-returns-an-error + §the-worker-decides-whether-to-recover-by-appending; §three-cycles-with-error-as-the-protocol-for-evicted-resources-where-the-worker-decides-whether-to-recover (would need cross-check).
