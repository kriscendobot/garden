---
ts: 2026-06-15T06:27:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--6c1cdb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-(kriskowal 2026-06-15T06:25:24Z)
---

# dispatch: shepherd — PR #438 rebase + lint fix + flake handling per kriskowal

Maintainer directive (kriskowal on PR #438, 2026-06-15T06:25:24Z):

> Please rebase and shepherd. There is a remaining lint error. The Mac test is a probable flake.

PR #438 (chore tsgo-lint-types) is DRAFT, base `master-4a04d07` (frozen). Failures:
- `lint` (real per maintainer; investigate)
- `test (22.x, macos-15)` (probable flake per maintainer; rerun)

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`, DRAFT, base `master-4a04d07`, head `4b2055c22`.
- **Title**: chore(types): switch lint:types to tsgo for the dev loop

## Task

Per `garden/roles/shepherd/AGENT.md` (with kriskowal's 4701061078 relaxed-fix authority):

1. Rebase the branch:
   - If base `master-4a04d07` is no longer the live tip, unfreeze to live `master` or whatever the current trunk is for chore-type PRs.
   - Rebase the 4-commit cluster on top of the new base.
   - Force-push with lease.
2. Investigate the lint error: read `gh run view --log-failed` for the failed lint job. Apply the surgical fix (per relaxed shepherd authority).
3. Rerun the Mac flake: `gh run rerun --failed` after the rebase push triggers a fresh CI cycle.
4. Watch CI; report convergence.
5. Post a top-level comment on PR #438 at-mentioning @kriskowal with the rebase summary, lint fix SHA, Mac rerun result.

## Authorizations

- Force-push with lease.
- `gh pr edit --base` if base needs to change.
- Apply surgical lint fix (relaxed shepherd authority).
- Re-run failed CI jobs.
- Top-level comment on PR #438.
- Do NOT mark PR ready/un-ready.
- Do NOT re-request review.

## Out of scope

- Do NOT change the tsgo-lint-types substance.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Rebase path (base change, conflicts).
- Lint fix description + SHA (if applied).
- Mac flake rerun result.
- PR #438 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: nothing` if green; `next: fixer` if lint cascade beyond surgical scope; `next: liaison` if structural.

End your turn with a concise summary back to the orchestrator.
