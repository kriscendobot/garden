---
ts: 2026-06-04T04:11:23Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--1a370f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/411
---

# dispatch: fixer — #411 extend retry per-attempt timeout (kriskowal directive)

Maintainer directive (kriskowal, 2026-06-04T04:10:31Z):

> Looks like the attempt is still making progress when it
> times out and starts a retry. Let's extend the timeouts to
> see the real time constraint and adjust after an
> observation.

The earlier shepherd diagnosis read "no log lines" as "hang"
but the maintainer observes the install IS making progress
(slow but real) — DEBUG=pw:install probably revealed slow
progress that looked like silence in the raw log.

## Target

- PR: endojs/endo-but-for-bots#411
- Branch: `ci/cache-playwright-browsers`
- Head: `3fbe0af31` (latest fixer; bot CI green here but
  upstream still failing).
- Base: `master-07aff33`.

## Required change

Current retry config (`.github/workflows/browser-test.yml`):
- `nick-fields/retry@v3.0.2` with `timeout_minutes: 15`,
  `max_attempts: 3`.
- Outer job `timeout-minutes: 60`.

Bump per-attempt timeout from 15 to a generous value (e.g.,
30 or 40 minutes) so the install completes within one attempt
rather than getting killed mid-progress and starting over.

Suggested: `timeout_minutes: 30` (gives 30 × 3 = 90 min worst
case, which fits inside the 60-min outer ceiling only if the
outer is also bumped). Sub-options:
- **A**: bump `timeout_minutes: 15 → 30`, keep
  `max_attempts: 3`. Bump outer `timeout-minutes: 60 → 120`
  to accommodate.
- **B**: bump `timeout_minutes: 15 → 40`, reduce
  `max_attempts: 3 → 2`. Worst case 80 min; bump outer to
  100 min.

Both shapes give a single slow attempt enough headroom.
**Recommend A** — keeps the 3-attempt safety net while
giving each attempt enough time.

## Procedure

1. Edit `.github/workflows/browser-test.yml`:
   - Bump install retry `timeout_minutes` from 15 to 30 (or
     similar per judgment).
   - Bump outer job `timeout-minutes` from 60 to 120 to
     accommodate.
   - Update the inline comment block explaining the new
     arithmetic.
2. Commit (regular append):
   ```
   ci(browser-test): extend retry per-attempt timeout to observe real Playwright install time
   ```
3. Push.
4. Reply on issue-comment thread.

## Per-action authorizations

- Edit `.github/workflows/browser-test.yml`. Authorized.
- One regular-append commit + push. Authorized.
- Issue-comment reply. Authorized.

## Not authorized

- Force-pushing.
- Touching upstream.
- Other files.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--1a370f/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--1a370f/garden/roles/fixer/AGENT.md`

Project worktree at `project/` on `ci/cache-playwright-browsers`
(head `3fbe0af31`).

## Report

A `result` journal entry. Include:

- Old → new timeout values.
- New head SHA.
- Reply comment ID.
- Judgment calls (A vs B or other variant).
