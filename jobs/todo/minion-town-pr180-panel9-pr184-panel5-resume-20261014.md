---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: gardener
split_source_handler_timeout: 2400
split_orchestration: minion-town-pr180-panel9-pr184-panel5-resume-20261014-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-14T21:16:41Z
---

# Deliberate overrun decomposition for `minion-town-pr180-panel9-pr184-panel5-resume-20261014`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by minion-town-pr180-panel9-pr184-panel5-resume-20261014-split`, then record `minion-town-pr180-panel9-pr184-panel5-resume-20261014-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by minion-town-pr180-panel9-pr184-panel5-resume-20261014-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS minion-town-pr180-panel9-pr184-panel5-resume-20261014-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: minion-town-pr180-panel9-pr184-panel5-resume-20261014-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Resume two halted minion.town gauntlets (kriscendobot/minion.town #180, #184)

Supervisor: `minion-town-arc-press-20261014-005007` (issue kriscendobot/garden#58). Standing authorization:
journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`. This replaces
`minion-town-pr180-panel9-pr184-panel5-resume-20261013`, which an earlier tick reported as posted
but which never reached the board.

Plumbing only. Do no review or fix work yourself. First re-read each terminal report on fresh
`origin/journal2` (`jobs/tada/2026/10/13/kriscendobot-minion.town-pr180-gauntlet.md` and
`...-pr184-gauntlet.md`). If either gauntlet is already active again, skip it.

1. **#180** (halted `review-budget-reached` at 8/8; fix 8 `d38139c` addressed round 8's must-fix, CI green):
   `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr180-gauntlet panel --iteration 9 --add-rounds 1`
2. **#184** (halted: panel round 5 doom-parked `requeue-exhausted`, cause unknown, 5/6 rounds):
   remove the stale doomed `jobs/plan/kriscendobot-minion.town-pr184-gauntlet-panel-5.md` first if it would
   block the re-post, then
   `scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr184-gauntlet panel`

Confirm each new panel child is on `jobs/todo/` and report the record state (state, stage,
iteration, max_iterations, current_child). Leave #181 halted; the supervisor holds it until #180 converges.
