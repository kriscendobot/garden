---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: weaver
split_source_handler_timeout: 7200
split_orchestration: weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-01T21:43:17Z
---

# Deliberate overrun decomposition for `weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101`

This ordinary job hit its applied 7200s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-split`, then record `weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 7200 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-11-01T19:30:34Z
arc: minion-town-claude-api
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR #1563 (https://github.com/endojs/endo-but-for-bots/pull/1563) onto the current head of its parent PR #1560 (branch build/exo-agent-factory-core, now 21d142af2d, CI fully green). #1563 is still based on the stale frozen snapshot build/exo-agent-factory-core-8c4a87e (head 50 commits behind #1560) and its CI is red (build, test ubuntu, sandbox-drivers, cover). Snapshot #1560's head to a frozen base (build/exo-agent-factory-core-21d142a already exists, as used by #1625), rebase, resolve conflicts, force-push with lease, move the PR base, then drive CI green. Found by shepherd-endojs-endo-but-for-bots-pr1560-ci-after-weave-20261101.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T21:54:42Z
