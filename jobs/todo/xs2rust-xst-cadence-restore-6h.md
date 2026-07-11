# Restore xst-validation-orchestrator cadence to 6h (Saturday drop-back)

The maintainer temporarily boosted standing schedules to a **30-minute** cadence on
2026-07-10 and asked to drop them back on Saturday morning. Restore
`xst-validation-orchestrator` to `6h`, WITHOUT clobbering its body / prefix /
preflight line.

**AMENDED 2026-07-11:** `xs2rust-endor-press` was **deliberately removed** from this
drop-back. The maintainer set it to a standing **hourly** cadence on 2026-07-11,
which supersedes the 6h plan for that effort — do **NOT** touch
`xs2rust-endor-press`. This job now restores only `xst-validation-orchestrator`.

Journal + local config ONLY — no project repo, no upstream. `set-schedule.sh` does
the fetch → apply → commit → push-with-retry CAS, and it auto-preserves
`last_dispatched` and any `preflight:` line; only the body must be fed back
explicitly.

For schedule `xst-validation-orchestrator`:

1. Extract its current body = everything AFTER the first `---` line of the live
   schedule (read it from origin/journal2 for the freshest copy):

       git -C <your-journal-clone> show origin/journal2:schedules/xst-validation-orchestrator.md \
         | awk 'seen{print} /^---$/ && !seen{seen=1}' > /tmp/xst.body

2. Re-register at 6h, preserving the body:

       scripts/jobs/set-schedule.sh xst-validation-orchestrator 6h xst-validation-orchestrator /tmp/xst.body

3. Verify `schedules/xst-validation-orchestrator.md` now reads `cadence: 6h` and the
   full body (its inner header + charter) is intact.

Notes:
- If `xst-validation-orchestrator` is no longer in `schedules/` by Saturday (e.g.
  paused again), SKIP it and say so. Do NOT reset `last_dispatched`.
- Report the cadence you restored.
