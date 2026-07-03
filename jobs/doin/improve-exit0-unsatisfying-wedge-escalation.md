In `scripts/jobs/gardener.sh` the exit-0-unsatisfying branch (lines 337-355) requeues a job whose handler exited 0 without the completion sentinel and explicitly emits `... (no escalation)`, relying solely on the reaper's poison threshold (5 cycles) to eventually surface a wedged job. The rc!=0 transient branch (lines ~490-604) already carries an elapsed-constancy check that escalates ONE kind:error when elapsed is near-constant across requeue cycles (a deterministic overrun misclassified as a blip). The exit-0 path has no such early signal — precisely the wedge the `xs2rust-endor-press` note flagged ("repeated exit-0-unsatisfying cycles with no further HEAD movement would mean the child is wedged, not working"), where a job burns ~2000s per cycle silently up to five times before the reaper poisons it. Mirror the elapsed-constancy escalation into the exit-0-unsatisfying branch so a stuck exit-0 job surfaces a kind:error to the gardener inbox well before silent reaper poison, giving the maintainer/driver an early wedge signal instead of a quiet 5-cycle burn.

---
claim:
  host: endolinbot2
  gardener: 6
  claimed_at: 2026-07-03T06:22:50Z
