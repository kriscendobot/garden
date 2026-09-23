orchestration-status: halted-superseded
halt-parked-remainder: endojs-endo-but-for-bots-pr1085-native-stream-search-fix-5119774721
# orchestration orch-endojs-endo-but-for-bots-pr1085-native-stream-search-5119774721 — HALTED

Serial run halted at child 1/2 **endojs-endo-but-for-bots-pr1085-native-stream-search-design-5119774721**: stalled in flight for 2511s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
0/2 children completed before the failure.

Left 1 not-yet-run downstream child(ren) parked under their held orchestrated gate: endojs-endo-but-for-bots-pr1085-native-stream-search-fix-5119774721

on-child-failure policy: halt.

---

SUPERSEDED 2026-09-05T20:28:34Z: the halt above was accurate when written but no longer
reflects the board. 1 of the parked-remainder child(ren) have since
progressed beyond their held orchestrated gate via another promotion path
(a human promote, a re-post — not this orchestration):

- endojs-endo-but-for-bots-pr1085-native-stream-search-fix-5119774721 — in flight (claimed)

Consult the board for live status; do not read "0/M completed" or the
parked-remainder list above as current.
