# Finish kriskowal/kni examples ingestion (batch 2)

Continue after `scholar-ingest-kni-examples` (read, calc, door-lock, forest, maze) and `scholar-ingest-kni-examples-remainder` (batch 1: archery, bottles, troll, spacestation, ship, space, coin, hilo, loop, door, subroutine, nominal). File under `decision-graph-authoring`; add `automatic-agentic-loop` ONLY where the example demonstrates elicitation or deterministic rendering of gathered feedback. Per-file idempotency check before writing (all listed below are new).

Remaining `.kni` files (16), grouped by value:

- Procedural generation / coordinate-hash (medium value): `examples/hilbert.kni`, `plane.kni`, `distribution.kni`.
- Control-flow / structure (medium value): `liftoff.kni` (stateful sequence + loop), `tree.kni` (recursive spatial procedure), `tetrominoes.kni` (rich orientation/position state machine with guarded options), `paint.kni` (coordinate-addressed variable grid), `list.kni` (dynamic variable names emulating arrays), `option-styles.kni` (the Q/A/QA option-notation reference), `fish.kni` (non-option `*` + End exit).
- Text / rendering only, low decision-graph value (consider a brief section each or skip with a noted rationale; already covered by the MANUAL text-space-and-symbols section): `ascii.kni`, `canon.kni`, `german.kni`, `hyperlinks.kni`, `poem.kni`, `stars.kni` (stars.kni is a comment-only data-schema sketch, no kni code).

None warrant `automatic-agentic-loop` on first read (none elicit-and-render gathered feedback); confirm per file. Model files on the existing `library/sources/kni--examples-*.md` + `library/sections/kni--examples-*--overview.md` pairs; add topic-page rows via insert-sections-table-row.sh; regenerate sections index + topics counts as the final landing step.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  worker_kind: gardener
  claimed_at: 2026-07-21T05:24:32Z
