# Continue kriskowal/kni examples ingestion

Continue `scholar-ingest-kni-examples` after its first five high-value worked examples (`read`, `calc`, `door-lock`, `forest`, `maze`). Ingest the remaining `.kni` corpus with per-file idempotency checks and file it under `decision-graph-authoring`, adding `automatic-agentic-loop` only where the example demonstrates elicitation or deterministic rendering of gathered feedback.

Remaining files: `examples/archery.kni`, `ascii.kni`, `bottles.kni`, `canon.kni`, `coin.kni`, `distribution.kni`, `door.kni`, `fish.kni`, `german.kni`, `hilbert.kni`, `hilo.kni`, `hyperlinks.kni`, `liftoff.kni`, `list.kni`, `loop.kni`, `nominal.kni`, `option-styles.kni`, `paint.kni`, `plane.kni`, `poem.kni`, `ship.kni`, `space.kni`, `spacestation.kni`, `stars.kni`, `subroutine.kni`, `tetrominoes.kni`, `tree.kni`, and `troll.kni`. Prioritize archery, bottles, troll, spacestation, ship/space, and control-flow examples when choosing the next bounded cycle.
