---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: fixer
split_source_handler_timeout: 10800
split_orchestration: ironhorse-ci2-refresh-1298-1534-20261117-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-17T10:03:40Z
---

# Deliberate overrun decomposition for `ironhorse-ci2-refresh-1298-1534-20261117`

This ordinary job hit its applied 10800s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by ironhorse-ci2-refresh-1298-1534-20261117-split`, then record `ironhorse-ci2-refresh-1298-1534-20261117-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 10800 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by ironhorse-ci2-refresh-1298-1534-20261117-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS ironhorse-ci2-refresh-1298-1534-20261117-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: ironhorse-ci2-refresh-1298-1534-20261117-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
role: fixer
tier: mentor
posted_at: 2026-11-17T05:31:59Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T05:34:49Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse CI: refresh #1298 and #1534 onto llm

Repo endojs/endo-but-for-bots. Maintainer ask (kriskowal, liaison session 2026-11-16/17): clear the remaining CI reds on kriscendobot ironhorse PRs, per the report in the completed job ironhorse-ci-4-remaining-20261116 (journal tada/2026/11/16). The first attempt at this work exited plainly twice without a report, so: work in small steps, push as you go, and write a report (per PR: before/after check state, cause, commit pushed) even if you finish only part. Run CI-equivalent checks locally before pushing. Push only to kriscendobot-authored heads. Do not merge; nothing merges until the ratchet improves the base. The two oracle lanes (test-ironhorse-oracle, ironhorse-oracle-sanitizers: stage3-math 054/055, ubuntu-26.04 glibc) stay red until #1613 reaches the base; leave them alone. Do not weave unless the task below says so.

Task: #1298 and #1534 carry old bwrap dash/ulimit and parent-death reds already fixed on llm. Refresh each onto current llm (a plain rebase of the head; keep the PR base as it is unless the PR cannot go green otherwise, and say so), resolve conflicts, then re-check. Also diagnose the undiagnosed build red on #1534 and fix it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-17T10:04:14Z
