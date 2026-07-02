Board refresh complete — investigated thoroughly; no reconciliation was needed and no code change was warranted.

## What I did

Read the `botanist` role brief and inspected the live job board (read-only, via `origin/journal2`) and the reconciliation tooling/services.

## Findings

**The job is a category error.** `roles/botanist/AGENT.md` (identical in the deployed root and on `main2`) is strictly a **Dependabot-PR-review** role — read the lockfile diff, install with scripts disabled, check advisories, render MERGE-NOW/EMBARGO/REJECT. It has **no board-tending procedure**. Board reconciliation is fully owned by deterministic services:
- `foreman` — idle pump (posts the next unblocked milestone step)
- `reaper` — requeues stale `doin` claims past `GARDEN_CLAIM_TTL` back to `todo`
- `unblock` — CAS lane moves
- `watchman` — ff-wedge resolution

There is also **no board-view / dependency-graph artifact** anywhere in the journal to "update" — the four git lanes (`todo`/`doin`/`plan`/`tada`) *are* the board and git state *is* reality.

**The board is healthy — nothing to prune, recover, or reconcile:**
- `todo`: empty (`.gitkeep` only)
- `doin`: 4 real jobs, all claimed <10 min ago by gardeners 81/12/29/66 — **every owner confirmed alive** on the bus (`inbox-list`). Zero stranded/stale claims.
- `plan`: 9 parked items — never-claimed, never-reaped by design
- `tada`: 830 completed — permanent record, no archival by design

**Not recurring:** no schedule generates this job (`schedules/` holds only daily-progress-summary, librarian-audit, plan-recalibrate, scholar-cycle), so it's a one-off, not a repeating defect.

## Changes
- **main2:** none. Nothing on the board needed changing; committing make-work would have been wrong.
- **Message bus:** sent the `liaison` a concise note flagging the misfiled job type and recommending it not be regenerated (target `foreman`/`watchman` or a dedicated board-audit script if a real audit is ever wanted).

## Follow-ups
- If board audits are genuinely desired as a role, they belong on `foreman`/`watchman` or a new deterministic script — not `botanist`. Left this recommendation with the liaison.
