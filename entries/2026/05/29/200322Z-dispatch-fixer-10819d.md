---
ts: 2026-05-29T20:03:22Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--10819d
short_id: 10819d
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/244
---

# dispatch: fixer — rebase #244 (chore eslint underscore numeric literals) and drive CI to green

## Task

Rebase `endojs/endo-but-for-bots#244` onto current `master` (the PR
is `DIRTY` per `mergeStateStatus`), then drive its CI to green. The
sole failing check is `lint` (workflow run
26208662592, job 77114062759, completed 2026-05-21T06:14:43Z). All
other checks pass on the current head.

PR metadata:
- Title: `chore(eslint-plugin): require underscore-delimited groups in numeric literals`.
- Base: `master`. Branch: `chore/eslint-numeric-separators-style-master`.
- State: OPEN, not draft. No reviews; no `reviewDecision`.

## Maintainer directive

> Please dispatch a fixer to rebase and shepherd
> https://github.com/endojs/endo-but-for-bots/pull/244

## Discipline

- Per `roles/fixer/AGENT.md` § Operating norms, rebase before
  follow-up (`skills/rebase-before-followup/SKILL.md`).
- Use `skills/conflict-resolution/SKILL.md` for any conflicts the
  rebase surfaces.
- After the rebase, fix the lint failure. The repo's lint script
  is `yarn lint` (likely with `--fix` available to auto-resolve a
  subset); the fixer reads the failing job log and applies the
  minimum diff to clear the check.
- Run the standing pre-push gate
  (`skills/pre-push-gates/SKILL.md`) before pushing.
- The repo's standing relaxation
  (`journal/projects/endo-but-for-bots/README.md` § Standing
  authorizations) covers any reactjis or comments the fixer needs
  to post on the PR.
- Per `roles/fixer/AGENT.md` § "After fix-up commits land, drive
  CI to green BEFORE re-requesting maintainer review" — the fixer
  drives CI green here, but the PR has no pending review request,
  so no re-request is needed. If CI cannot be made green by the
  fixer's own work (e.g., a deeper test breakage surfaces),
  escalate per the role's `shepherd → fixer auto-chain` rule via a
  message-to-liaison rather than continuing to thrash.

## Acceptance

- Rebase clean on current `endojs/endo-but-for-bots:master`.
- `lint` check passing on the new head.
- All other checks remain green.
- `chore: Update yarn.lock` separate commit if dependencies move.
- Result entry naming the rebased head SHA, the fix-up commit
  SHA(s), and the final CI status.

## Report

Return:
- Rebased head SHA.
- Fix-up commit SHA(s) and a one-line description of each.
- Final CI rollup (all green / partial / red with reason).
- Final `Self-improvement: ...`.

The liaison writes the matching `result` entry on your return and
tears down this dispatch root.
