orchestration-status: halted-superseded
halt-parked-remainder: minion-town-clipometer-esbuild-validate minion-town-clipometer-primer-esbuild-update minion-town-clipometer-esbuild-issue-report
# orchestration minion-town-clipometer-esbuild-orchestration — HALTED

Serial run halted at child 1/4 **minion-town-clipometer-esbuild-pipeline**: stalled in flight for 2501s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
0/4 children completed before the failure.

Left 3 not-yet-run downstream child(ren) parked under their held orchestrated gate: minion-town-clipometer-esbuild-validate minion-town-clipometer-primer-esbuild-update minion-town-clipometer-esbuild-issue-report

on-child-failure policy: halt.

---

SUPERSEDED 2026-09-17T03:19:31Z: the halt above was accurate when written but no longer
reflects the board. 1 of the parked-remainder child(ren) have since
progressed beyond their held orchestrated gate via another promotion path
(a human promote, a re-post — not this orchestration):

- minion-town-clipometer-esbuild-validate — in flight (claimed)

Consult the board for live status; do not read "0/M completed" or the
parked-remainder list above as current.
