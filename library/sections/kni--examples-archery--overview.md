---
title: "Fletcher shop and archery range"
source: examples/archery.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

> Abstract: A two-location economy graph (`@shop` and `@range`) whose menu options each fuse a guard with a state mutation — buy arrows for gold, sell arrows for gold, shoot for a random score — and whose narrative is re-rendered on every loop as a deterministic function of the accumulated `gold`, `arrow`, and `score` variables.

Each option carries an inline guard-and-consequence pair: `{-gold} {+3arrow}` only offers the purchase when `gold` is positive and, when taken, decrements gold and adds three arrows. The shop and range labels each end by looping back to themselves (`->shop`, `->range`), so the same accumulated state is repainted every turn. Reusable procedures `->arrow()` and `->gold()` render a count with correct grammar ("no arrows", "an arrow", "N arrows"), and the `@exit` label tallies the final score with pluralization derived from the `score` variable.

This is a compact example of the two halves an agent-context loop needs at once: a bounded, precondition-filtered menu that records each decision as a state mutation, and a rendering step that reflects the gathered totals back to the interlocutor before the next choice. The randomized hit/miss (`{~ ...||}`) shows where a non-deterministic outcome is spliced into an otherwise deterministic walk.

Source: [examples/archery.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/archery.kni) at commit `435ec3cf`.
