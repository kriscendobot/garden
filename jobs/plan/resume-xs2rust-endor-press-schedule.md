---
gate: orchestrated
orchestrated_by: xs2rust-endor-orphan-collection-fix
priority: normal
role: fixer
posted_by: producer
posted_at: 2026-07-21T04:58:32Z
---

# fixer — resume the xs2rust-endor-press schedule (runs only after fix+verify pass)

This is the terminal step of orchestration `xs2rust-endor-orphan-collection-fix`
(serial, `on-child-failure: halt`) — it is promoted ONLY after
`fix-handler-reap-spawned-process-group` and `verify-no-orphan-leak-on-handler-timeout`
both reached `jobs/tada/`. Double-check both predecessors' tada reports before acting.

## Do
In the journal (`journal2` branch, via your journal clone), move the schedule back
into active rotation:
```
git mv paused-schedules/xs2rust-endor-press.md schedules/xs2rust-endor-press.md
```
Reset `last_dispatched` is not required (the scheduler treats a re-added schedule
correctly). Commit and push to `origin/journal2` with a CAS rebase loop. The
charter already carries the MANDATORY "Process hygiene" section (per-test
`timeout` + process-group reaping) — do not remove it.

## Verify after
`schedules/xs2rust-endor-press.md` present on `origin/journal2` and ABSENT from
`paused-schedules/`. Report the pushed sha. If you cannot confirm both predecessor
tada reports, do NOT resume — surface instead.
