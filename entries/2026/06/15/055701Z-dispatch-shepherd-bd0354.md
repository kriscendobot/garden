---
ts: 2026-06-15T05:57:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--bd0354
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/3
  - https://github.com/kriscendobot/agoric-sdk/pull/3#issuecomment-4493971710
---

# dispatch: shepherd — resume shepherd on PR #3 per kriskowal

Maintainer directive (kriskowal on PR #3, 2026-05-20T02:27Z):

> Resume shepherd.

(Now ~26 days later; user re-rsvp'd 2026-06-15T05:55Z.)

PR #3 (kriscendobot/agoric-sdk fix/node-sqlite-builtin) is DRAFT. A prior
shepherd was apparently working on driving CI to green and was paused. This
dispatch resumes that work.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#3`, DRAFT, head `af25210c0`.
- **Title**: chore(swing-store): migrate from better-sqlite3 to node:sqlite (built-in)
- **CI failures**: lint-primary, lint-rest, test-boot (node-old), test-cosmic-swingset (node-old), test-fast-usdc-deploy (node-old), and probably others.

## Task

In your `project/` worktree:

1. Read prior shepherd journal entries (search `entries/2026/0[45]/*-result-shepherd-*` for the PR #3 work that was paused).
2. Read the current failing CI jobs (gh run view).
3. Pick up where the prior shepherd left off: classify each failure (flake vs real), rerun flakes, surface real failures as `next: fixer`.
4. Post a top-level comment on PR #3 at-mentioning @kriskowal with the verdict.

## Authorizations

- `gh run rerun` failed jobs.
- Push small surgical fixes per shepherd's relaxed authority (kriskowal directive 4701061078).
- Top-level comment on PR #3 @-mentioning @kriskowal.
- Do NOT mark PR ready/un-ready.

## Out of scope

- Do NOT touch upstream Agoric/agoric-sdk (boatman territory).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Prior shepherd entries cited.
- Per-failing-job diagnosis + classification.
- Any reruns/fixes applied.
- PR #3 verdict comment URL.
- Recommended next stage.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
