Add preflight existence validation to `scripts/jobs/set-schedule.sh` so a schedule cannot be registered pointing at a nonexistent gate. Today `set-schedule.sh` writes the `preflight:` frontmatter line verbatim from `GARDEN_SCHEDULE_PREFLIGHT` with no check; when the referenced script (e.g. `gardening/xs2rust-endor-press-preflight.sh`) is absent from the deploy tree, `scheduler.sh` line ~126 logs `WARN … not found/executable at $pf; treating as work-present` on every tick and dispatches unconditionally, silently defeating the gate. In `set-schedule.sh`, resolve the preflight path the same way `scheduler.sh` does (relative to `$HERE`/script dir, absolute passed through) and, when a preflight is supplied via the env var, refuse to write the schedule (non-zero exit with a clear message) if it is not found/executable — fail loudly at set time instead of silently every tick. Leave the preserve-existing-preflight path intact so already-registered schedules are unaffected.

---
claim:
  host: endolinbot2
  gardener: 2
  claimed_at: 2026-07-03T04:52:14Z
