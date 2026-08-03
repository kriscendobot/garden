---
order: serial
children: garden-budget-ratecard garden-budget-ledger garden-budget-prs garden-budget-triple garden-budget-omega
on-child-failure: halt
state: complete
created_by: producer
created_at: 2026-08-02T21:05:57Z
---

# orchestration garden-budget-attribution

5 children (serial), on-child-failure=halt.

## COMPLETE — 2026-08-03T02:49:25Z

All 5 children reached `jobs/tada/`, in order, no failures:

| # | child | commit | true cost |
|---|---|---|---|
| 1 | garden-budget-ratecard | 7ebe53e6d0 / 211de0db97 | ~$0.21 |
| 2 | garden-budget-ledger   | 82a9a3a068 | ~$0.17 |
| 3 | garden-budget-prs      | c879177dd2 | ~$0.29 |
| 4 | garden-budget-triple   | a7c9c8d11a | ~$0.04 |
| 5 | garden-budget-omega    | 4bc13ba73d | ~$0.05 |

**Driven by hand, not by the orchestrate watcher.** `garden-orchestrate.service`
carries `ExecCondition=is-main-host.sh` (leader-only) and `orchestrate.sh:66` is
`fleet_draining && exit 0`; the leader `endolin-garden2-5bcdff64` was deliberately
drained to keep the foreman from backfilling, so the watcher exited every tick.
The liaison promoted each child with `promote-plan.sh` after verifying the
previous one landed. `state:` is set here for the record — no watcher wrote it.
