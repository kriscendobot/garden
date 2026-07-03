`scripts/jobs/scheduler.sh` (line ~126) logs `WARN schedule <name> preflight '<path>' not found/executable … treating as work-present` and fails open — so a schedule whose preflight script is missing (observed: `xs2rust-endor-press.md` → `gardening/xs2rust-endor-press-preflight.sh`) silently dispatches unconditionally on every cadence forever, defeating the gate and hiding a config/deploy drift behind a WARN nobody reads. Keep the fail-open (correct safety default) but add a deterministic, deduplicated escalation to the maintainer inbox (a `WARN`-once marker keyed on schedule name, or a maintainer-inbox note via the same path the reaper uses for poison) so a missing preflight surfaces as an actionable signal exactly once instead of an infinite silent fail-open.

---
claim:
  host: endolinbot2
  gardener: 12
  claimed_at: 2026-07-03T13:22:29Z
