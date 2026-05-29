---
ts: 2026-05-29T02:14:00Z
kind: dispatch
role: general-contractor
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--a987c3
refs:
  - jobs/claimed/20260529T021105Z--endolinbot--general-contractor--dde2--d830d2--endo-gateway-where-slice-1-337.md
  - contractor-slots/endolinbot/slot-2.md
  - entries/2026/05/22/232757Z-result-cleaner-d38b8f.md
---

# Dispatch fixer on PR #337 — summary-fix bundle (job d830d2)

Cycle 2 of the 2026-05-29 re-adoption, second dispatch (slot-2). Slot-2
claims job `d830d2` (`endo-gateway-where-slice-1-337`, posted
2026-05-22T23:35:20Z by barrister on endolinbot) and dispatches a fixer
to address the two-item summary-fix bundle.

## Subject

PR [endojs/endo-but-for-bots#337](https://github.com/endojs/endo-but-for-bots/pull/337)
`feat(daemon,cli): Endo Gateway — system-service multi-user host (scaffolding slice 1)`,
branch `feat/endo-gateway`, head `3e3468638` at dispatch time.

PR is un-drafted (first-round panel returned zero `must-fix-loop`
items). No maintainer review activity since 2026-05-22T23:33Z (verified
`gh pr view` reviews list; only kriscendobot panel reviews on record).

## Worktree triple

- `DISPATCH_ROOT=/home/kris/dispatches/fixer--a987c3/`
- `project/` at `3e3468638` (origin/feat/endo-gateway)
- `garden/` detached at main
- `journal/` detached at cycle-2 journal HEAD

## Bundle (two items, summary; full body in claimed job)

1. **PR title scope mis-narrowed.** Title claims `daemon,cli` but the
   slice ships entirely in `@endo/where`. Rewrite title via
   `gh pr edit 337 -R endojs/endo-but-for-bots --title 'feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)'`.
2. (second item lives in the full claimed-job body).

## Authorizations

Per the claimed job: `identity_switch: false`, `comment_repos: []`.
The job body explicitly calls for `gh pr edit --title` which is a PR
metadata change. Per `roles/COMMON.md` § External-repo etiquette, "PR
or issue opens, edits, or closes" requires per-action authorization.

**Per-action authorization carried in this dispatch**: `gh pr edit
<number> --title <new>` on PR #337 to apply the title-scope rewrite the
job body specifies. This is implicit in the claimed job (the body
mandates the exact title) but is being made explicit here per the
external-repo-etiquette discipline. The fixer applies the title change
once the second-item commit lands. No PR comments or reactjis carried.

Push to the PR branch is implicit per fixer-role norms.

## Expected report

A `result` entry naming the new head SHA on `feat/endo-gateway`, which
of the two items each commit addresses, the new PR title, and local
lint/test results. PR remains un-drafted.

Self-improvement: nothing this entry.
