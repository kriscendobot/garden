---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: endojs-endo-but-for-bots-no-any-typecheck-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-22T09:23:04Z
---

# Deliberate overrun decomposition for `endojs-endo-but-for-bots-no-any-typecheck`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-no-any-typecheck-split`, then record `endojs-endo-but-for-bots-no-any-typecheck-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-no-any-typecheck-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS endojs-endo-but-for-bots-no-any-typecheck-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: endojs-endo-but-for-bots-no-any-typecheck-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# endojs/endo-but-for-bots: systematically set up no-any in type checking

Repo: endojs/endo-but-for-bots. Maintainer directive (kriskowal, review on #1393):
https://github.com/endojs/endo-but-for-bots/pull/1393#discussion_r4345304671 —
"Unacceptable to fall back to `any`. This is a rule in general. Please post a job to
systematically set up no-any in our type checking."

Task: design and land (as a DRAFT PR off the repo's default branch, through ensure-pr.sh) a
systematic enforcement of no-explicit-`any` across the monorepo's type checking — e.g. an
eslint rule for JSDoc/TS `any` (such as @typescript-eslint/no-explicit-any and/or a JSDoc
type check that rejects `{any}`), wired into the shared lint config and CI. Inventory existing
`any` uses first; if the count is large, land the rule with a ratchet (per-package opt-in or a
baseline of existing violations to burn down) rather than a single huge rewrite, and say so in
the PR body. Do not weaken existing checks. If the right mechanism is a genuine design fork,
write it up and ask the maintainer rather than guessing.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T11:15:24Z
