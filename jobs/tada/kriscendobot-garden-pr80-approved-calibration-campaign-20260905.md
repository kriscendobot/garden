orchestration-status: halted-superseded
halt-parked-remainder: kriscendobot-garden-pr80-conduct-20260905 kriscendobot-garden-pr80-validation-setup-20260905
# orchestration kriscendobot-garden-pr80-approved-calibration-campaign-20260905 — HALTED

Serial run halted at child 1/3 **kriscendobot-garden-pr80-resolve-build-20260905**: stalled in flight for 2500s on host endolin-garden-ece02cb4 (handler-timeout=2400s, multiplier=1).
0/3 children completed before the failure.

Left 2 not-yet-run downstream child(ren) parked under their held orchestrated gate: kriscendobot-garden-pr80-conduct-20260905 kriscendobot-garden-pr80-validation-setup-20260905

on-child-failure policy: halt.

---

SUPERSEDED 2026-09-05T18:07:20Z: the halt above was accurate when written but no longer
reflects the board. 1 of the parked-remainder child(ren) have since
progressed beyond their held orchestrated gate via another promotion path
(a human promote, a re-post — not this orchestration):

- kriscendobot-garden-pr80-validation-setup-20260905 — in flight (queued)

Consult the board for live status; do not read "0/M completed" or the
parked-remainder list above as current.
