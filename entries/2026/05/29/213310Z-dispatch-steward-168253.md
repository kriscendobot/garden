---
ts: 2026-05-29T21:33:10Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--168253
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/345
  - entries/2026/05/29/210029Z-result-fixer-7ec73e.md
  - entries/2026/05/29/210130Z-result-steward-177fb0.md
---

# dispatch: shepherd — #345 post-retcon CI classification

The retcon completed at 21:00; CI on the new head `73332aae` finished
with 2 failures (`lint`, `test-xs`) out of 25 checks.

Likely classification per the fixer's pre-push gates note (result
`7ec73e`): the `lint` failure is the pre-existing filename-stutter
probe on `packages/cancel/src/cancel-kit.js` — ~14 other repo files
trip the same probe; addressing it would violate the retcon's
net-diff invariant. The `test-xs` failure is the recurring flake on
this repo (last seen on #244, #357).

But classification is the shepherd's job, not the steward's. The
shepherd reads logs, decides, acts.

## Task

Pull the failing-job logs:

- `lint`:
  https://github.com/endojs/endo-but-for-bots/actions/runs/26661945706/job/78586474172
- `test-xs`:
  https://github.com/endojs/endo-but-for-bots/actions/runs/26661945706/job/78586474275

Classify each as flake / known-pre-existing / real-failure /
fixer-fixable. Take the right action per
`garden/skills/pr-ci-watch/SKILL.md`:

- Re-enqueue flakes via `gh run rerun <run-id> --failed`.
- Comment with classification if known pre-existing.
- Escalate to fixer if real-and-fixer-fixable. Per memory rule
  `feedback_shepherd_to_fixer_auto_chain.md`, surface the escalation
  explicitly in the report so the steward dispatches the fixer next
  cycle.

If the `lint` failure is the filename-stutter probe and addressing it
would break the retcon's net-diff invariant, comment on the PR
flagging this as a follow-up rename candidate (separate from the
retcon) — do not escalate to fixer this cycle.

## Per-action authorizations (forwarded)

- Re-enqueue CI jobs via `gh run rerun --failed`. Authorized.
- Posting an explanatory comment on PR #345 with classification.
  Authorized.

## Not authorized

- Modifying any source file (fixer's job if needed).
- Force-pushing to the PR branch.
- Un-drafting or re-drafting.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--168253/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--168253/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`
4. `garden/skills/ci-status-summary/SKILL.md` as needed.

Project worktree at `project/` on `mirror/3032-cancel` (head
`73332aaef`, post-retcon).

## Report

A `result` journal entry. Include: per-failure classification with
log evidence, action taken (comment / re-enqueue / escalate),
comment IDs of any posted comments, and any fixer-fixable escalation
flagged for the steward.
