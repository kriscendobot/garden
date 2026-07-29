In the garden's own repo (kriscendobot/garden, branch `main2`, no PR workflow), extend the plan-poison reset to `scripts/jobs/post-plan.sh`: its re-parking paths still pass job bodies through verbatim, so a body carrying `<!-- garden-deadline-overrun: N -->` (or a comparable poison marker) survives a re-park and re-poisons the next promotion. Apply the same `clean_body`-style stripping used by the promote path, keep it idempotent, and land directly on `main2`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-29T02:19:17Z
