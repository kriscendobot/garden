orchestration-status: halted-superseded
halt-parked-remainder: endojs-endo-but-for-bots-pr282-fixture-parity endojs-endo-but-for-bots-pr282-registry-default-followup
# orchestration pr282-flag-gated-reconciliation — HALTED

Serial run halted at child 1/3 **endojs-endo-but-for-bots-pr282-pin-rebase-reconcile**: stalled after 3 requeues on host endolin-garden2-5bcdff64 (limit 2, no progress hint this cycle).
0/3 children completed before the failure.

Left 2 not-yet-run downstream child(ren) parked under their held orchestrated gate: endojs-endo-but-for-bots-pr282-fixture-parity endojs-endo-but-for-bots-pr282-registry-default-followup

on-child-failure policy: halt.

---

SUPERSEDED 2026-08-17T04:22:30Z: the halt above was accurate when written (2026-08-16T07:04:06Z —
child 1 had stalled and children 2 & 3 were still parked under their gate) but no
longer reflects the board. Both parked-remainder children were promoted ~18h later
by a **manual** `promote-plan.sh` on host endolin-garden-ece02cb4 (2026-08-17
01:46–01:47Z, not this orchestration) and completed:

- endojs-endo-but-for-bots-pr282-fixture-parity — completed (tada 2026-08-17T02:06:50Z; landed a 40-entry parity manifest plus a drift safeguard)
- endojs-endo-but-for-bots-pr282-registry-default-followup — completed (tada 2026-08-17T01:52:56Z; landed a design-record correction, commit 86745db2b0)

Only child 1 (pin-rebase-reconcile) never ran to completion. The gate genuinely
held during the halt; this is a "never-superseded record", not a halt-policy bug.
Do not read "0/3 completed" or the parked-remainder list above as current.
This record was corrected by hand for the pre-existing halt; future halts are
superseded automatically by orchestrate.sh's supersede_stale_halts pass.
