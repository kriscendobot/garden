---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement finding from endo-minion-town-guest-locator-federation-supervisor
(2026-09-23), surfaced via the maintainer inbox:

`scripts/jobs/orchestrate.sh`'s serial parked-child branch calls
`promote-plan.sh` on the next child without checking whether that child's own
gate is `blocked` (e.g. `block-job.sh`'d on an unmerged upstream PR).
`promote-plan.sh` correctly refuses to promote an `awaiting-maintainer` gate,
but it does NOT refuse a `blocked` gate the same way — so an orchestrated
child that is ALSO blocked on an external artifact (via `blocked_on`) can be
repeatedly re-promoted by the orchestration watcher ahead of
`unblock.sh`'s artifact check actually clearing.

This does not cause an incorrect deployment (per-child specs recheck
approvals/merge status on every resume and refuse to proceed regardless), but
it wastes claims and clutters the board with premature retries. This is live
right now on the freshly-launched `endo-minion-town-guest-locator-federation`
orchestration, whose children may hit exactly this shape (dependent PRs
#684/#1124 still draft).

Fix: make `orchestrate.sh`'s serial-promotion path (or `promote-plan.sh`
itself) refuse to promote a still-`blocked` child, mirroring the existing
`awaiting-maintainer` refusal, so a blocked-and-orchestrated child waits for
`unblock.sh` to clear its `blocked_on` artifact rather than being promoted on
the orchestration's own cadence. Add regression coverage alongside the
existing orchestration/promote-plan test suites.
