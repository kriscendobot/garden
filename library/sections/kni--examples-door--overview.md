---
title: "Two-room shared-flag doorway"
source: examples/door.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Two labeled rooms (`@blue`/`@blue2` and `@red`/`@red2`) share one persistent `door` flag. Each room uses guarded threads — `- {door} ...` versus `- {not door} ...` — to describe the door and offer only the legal actions (walk through when open, close when open, open when closed), with the open/close options mutating the shared flag (`{=0 door}` / `{=1 door}`). Walking through connects the rooms, so the same flag governs both sides.

It is the same guard-filters-legal-actions pattern as `door-lock`, but doubled: because both rooms read and write the one `door` variable, the state carried by walking between them is visibly shared, and each room re-derives its menu from that state on every visit. The `@blue2`/`@red2` re-entry labels are the loop points the mutating options jump back to so the refreshed description renders.

For authoring, `door` is the "shared state across two nodes" reference: a single flag, two consumer nodes each guarding its options on it, and mutation options that loop back to repaint — the multi-room generalization of a single guarded controller.

Source: [examples/door.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/door.kni) at commit `435ec3cf`.
