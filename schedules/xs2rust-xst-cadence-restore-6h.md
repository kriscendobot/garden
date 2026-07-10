once: 2026-07-11T16:00:00Z
job_basename_prefix: xs2rust-xst-cadence-restore-6h
---
# Restore xs2rust + xst-validation orchestrator cadences to 6h (Saturday drop-back)

The maintainer temporarily boosted two standing schedules to a **30-minute** cadence on
2026-07-10 and asked to drop them back down on Saturday morning. Restore **both** to
`6h`, WITHOUT clobbering either schedule's body / prefix / preflight line.

Journal + local config ONLY — no project repo, no upstream. `set-schedule.sh` already does
the fetch → apply → commit → push-with-retry CAS, and it auto-preserves `last_dispatched`
and any `preflight:` line; only the body must be fed back explicitly.

For EACH schedule `<name>` in {`xs2rust-endor-press`, `xst-validation-orchestrator`}:

1. Extract its current body = everything AFTER the first `---` line of the live schedule
   (read it from origin/journal2 so you have the freshest copy), e.g.:

       git -C <your-journal-clone> show origin/journal2:schedules/<name>.md \
         | awk 'seen{print} /^---$/ && !seen{seen=1}' > /tmp/<name>.body

2. Re-register at 6h, preserving the body:

       scripts/jobs/set-schedule.sh <name> 6h <name> /tmp/<name>.body

3. Verify `schedules/<name>.md` now reads `cadence: 6h` and the full body (the inner
   `model:`/`role:` header + charter) is intact.

Notes:
- `xs2rust-endor-press` carries a `preflight:` gate — set-schedule.sh preserves it; confirm
  it's still present after the write.
- If a schedule is no longer in `schedules/` by Saturday (e.g. paused again), SKIP it and
  say so in the report. Do NOT reset `last_dispatched`.
- Report which cadences you restored.
