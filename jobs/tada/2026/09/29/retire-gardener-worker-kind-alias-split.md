orchestration-status: halted-resumed
halt-failed-child: retire-gardener-worker-kind-alias-env-fallback
halt-parked-remainder: retire-gardener-worker-kind-alias-verify-docs
# orchestration retire-gardener-worker-kind-alias-split — HALTED

Serial run halted at child 1/2 **retire-gardener-worker-kind-alias-env-fallback**: stalled in flight for 2517s on host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1).
0/2 children completed before the failure.

Left 1 not-yet-run downstream child(ren) parked under their held orchestrated gate: retire-gardener-worker-kind-alias-verify-docs

on-child-failure policy: halt.

---

RESUMED 2026-09-30T22:17:16Z: the halt above was premised on child retire-gardener-worker-kind-alias-env-fallback, which has since
completed successfully (tada report present, no gated-failure). The
not-yet-run remainder has been re-posted as orchestration retire-gardener-worker-kind-alias-split-resume to
continue the campaign:

- retire-gardener-worker-kind-alias-verify-docs

Consult retire-gardener-worker-kind-alias-split-resume and the board for live status; do not read the halt
narrative above as current.
