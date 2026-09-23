orchestration-status: halted-superseded
halt-parked-remainder: credit-controls-panel-seat-metering-and-tiering
# orchestration credit-controls-20260916 — HALTED

Serial run halted at child 3/4 **credit-controls-stale-pr-viability-gate**: stalled in flight for 2505s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
2/4 children completed before the failure.

Left 1 not-yet-run downstream child(ren) parked under their held orchestrated gate: credit-controls-panel-seat-metering-and-tiering

on-child-failure policy: halt.

---

SUPERSEDED 2026-09-16T23:16:04Z: the halt above was accurate when written but no longer
reflects the board. 1 of the parked-remainder child(ren) have since
progressed beyond their held orchestrated gate via another promotion path
(a human promote, a re-post — not this orchestration):

- credit-controls-panel-seat-metering-and-tiering — in flight (queued)

Consult the board for live status; do not read "0/M completed" or the
parked-remainder list above as current.
