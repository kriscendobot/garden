In `scripts/jobs/scheduler.sh` (the `[ -x "$pf" ]` else-branch around line 126), a schedule whose `preflight:` names a script absent from *this host's deployed root* — the exact live case: `xs2rust-endor-press.md` references `gardening/xs2rust-endor-press-preflight.sh`, which exists on `origin/main2` but not in endolinbot2's 61-commit-behind deployed root — logs `WARN ... treating as work-present` and dispatches unconditionally on **every** due tick, silently defeating the no-work gate for the entire deploy-lag window (multiple unnecessary fable press-driver wakes at cadence 30m). Harden: (1) deduplicate this WARN via a per-`(schedule, resolved-path)` stamp under `$GARDEN_STATE` so it fires once, not every tick; and (2) because a named-but-missing preflight whose script is present on `origin/main2` is a **deploy-lag** symptom, emit it as a distinct one-shot actionable signal (post via the message bus / into the upgrade-ready deploy surface) so the pending deploy is diagnosed as the cause, rather than buried as recurring noise. Keep the conservative fail-open dispatch (never starve real work).

---
claim:
  host: endolinbot2
  gardener: 18
  claimed_at: 2026-07-03T12:53:08Z
