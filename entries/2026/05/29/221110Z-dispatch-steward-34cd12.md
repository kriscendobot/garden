---
ts: 2026-05-29T22:11:10Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--34cd12
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/345
  - entries/2026/05/29/214130Z-result-steward-7e6309.md
---

# dispatch: shepherd — #345 post-SECURITY.md-fix CI (new lint failure surfaced)

After the SECURITY.md fix on `5238e8a88`, CI ran again. The
`scripts/check-security-md.sh` step now passes. But the `lint` job
*still* fails — different cause: **`Check composite tsconfig files
are up to date`** exits 1. The lint itself reports `0 errors / 2060
warnings` (warnings only); the failing step is the composite tsconfig
check.

Plus `test-xs` is still failing — same recurring esvu engine-install
flake.

## Task

Classify both failures per `garden/skills/pr-ci-watch/SKILL.md`:

- `lint`:
  https://github.com/endojs/endo-but-for-bots/actions/runs/26663589007/job/78591852754
  — failing step: "Check composite tsconfig files are up to date".
  Almost certainly the cancel-package addition needs a tsconfig
  composite update. If so: real, fixer-fixable; surface for the steward
  to dispatch a fixer next cycle.
- `test-xs`:
  https://github.com/endojs/endo-but-for-bots/actions/runs/26663589007/job/78591852765
  — likely the same esvu engine-install flake the prior shepherd
  re-enqueued. If still flaking: this is the same upstream-fix-needed
  issue, and re-enqueuing in a tight loop wastes runner time.
  Recommendation: classify as known-pre-existing-flake with upstream
  fix in flight (PR #3291); do NOT re-enqueue again. Comment if not
  already commented.

## Per-action authorizations

- Re-enqueue CI via `gh run rerun --failed` (use judgment; second
  re-enqueue of the same flake is wasteful).
- Posting an explanatory comment on PR #345 with classification.
  Authorized.

## Not authorized

- Modifying source files (fixer's job).
- Force-pushing.
- Un-drafting / re-drafting.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/shepherd--34cd12/garden/roles/COMMON.md`
2. `/home/kris/dispatches/shepherd--34cd12/garden/roles/shepherd/AGENT.md`
3. `garden/skills/pr-ci-watch/SKILL.md`

Project worktree at `project/` on `mirror/3032-cancel` (head
`5238e8a88`).

## Report

A `result` journal entry. Include: per-failure classification with log
evidence, action taken, comment IDs, fixer-fixable escalation flagged
for steward (likely YES for lint, NO for test-xs).
