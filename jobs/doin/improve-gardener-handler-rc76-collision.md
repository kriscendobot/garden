---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-gardener-handler-rc76-collision-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-03T20:13:06Z
---

# Deliberate overrun decomposition for `improve-gardener-handler-rc76-collision`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-gardener-handler-rc76-collision-split`, then record `improve-gardener-handler-rc76-collision-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by improve-gardener-handler-rc76-collision-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS improve-gardener-handler-rc76-collision-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-gardener-handler-rc76-collision-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-11-03T19:20:52Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
gardener.sh:1327 reserves rc=76 (GARDEN_HANDOFF_UNVERIFIED_RC) for complete-job. At 07:00:10Z the weave handler for kriscendobot-minion.town-pr199-weave-20261103 also exited rc=76 and was classed as a generic handler FAILED. After a retry that exited rc=75 after 18s, the job was doomed requeue-exhausted at 07:33:05Z, even though the force-push and base move had already landed at 06:33:29Z. Before requeueing or dooming an ordinary job whose handler exits 75/76, check for a durable post-condition (the pushed head equals the expected SHA, or the gauntlet was already staged). If it holds, run complete-job instead of leaving the job in doin for the reaper. Alternatively, make the handler's rc namespace distinct from complete-job's.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-03T20:15:04Z
