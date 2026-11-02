---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: designer
split_source_handler_timeout: 2400
split_orchestration: daemon-git-clone-bootstrap-design-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-02T11:23:08Z
---

# Deliberate overrun decomposition for `daemon-git-clone-bootstrap-design`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by daemon-git-clone-bootstrap-design-split`, then record `daemon-git-clone-bootstrap-design-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by daemon-git-clone-bootstrap-design-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS daemon-git-clone-bootstrap-design-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: daemon-git-clone-bootstrap-design-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-11-02T09:54:32Z
arc: minion-town-git-remote
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Designer step for endojs/endo-but-for-bots (base branch `llm`): write the new `designs/daemon-git-clone.md` named in `designs/daemon-git-next-steps.md` § Open Work. It covers `provideGitClone` repository bootstrap (mount creation, endpoint policy, sealed credential authority, and clone into the new mount, returning `EndoMount` + `Git`) and the commit-author / identity boundary as a capability shape. It builds on `daemon-git-remotes` § Repository Bootstrap, and it should put any unresolved questions in an Open questions section.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T11:42:26Z
