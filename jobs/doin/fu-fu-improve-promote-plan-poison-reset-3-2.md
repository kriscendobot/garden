In the garden's own repo (`kriscendobot/garden`, `main2`), harden `scripts/jobs/annotate-plan.sh`: it appends producer-supplied note text to a parked plan verbatim, so a producer piping a job body as a note can reintroduce cycle markers into the parked body. Apply the same `strip_cycle_markers` sanitization to the appended note text.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-29T02:29:25Z
