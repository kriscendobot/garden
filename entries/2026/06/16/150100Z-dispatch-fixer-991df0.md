---
ts: 2026-06-16T15:01:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--991df0
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
---

# dispatch: fixer — OODA cycle 8 on PR #5 (lockfile drift)

OODA cycle 8 observe shows lint-primary failing on `YN0028 The lockfile would have been modified by this install, which is explicitly forbidden`. The lockfile drifted from package.json — cycles 4-7's per-package edits weren't all reflected in yarn.lock.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `a67ed42db5`.

## Task

In your `project/` worktree at `a67ed42db5`:

1. Run `corepack yarn install` (no `--immutable`) to regenerate yarn.lock.
2. Verify only yarn.lock changed (`git status`).
3. If multichain-testing has its own yarn.lock (it's a standalone yarn project), also regenerate there: `cd multichain-testing && corepack yarn install` (may need `cp -r` to a tmpdir per fixer cb75d8's note).
4. Run `corepack yarn lint:primary` locally to confirm clean.
5. Commit: `chore: Update yarn.lock`.
6. Push to `mirror/12527-endo-sync-refresh` (append only).
7. Post brief top-level comment on PR #5 at-mentioning @kriskowal with SHA + note that lockfile regenerated after cycles 4-7.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT touch substantive code.
- Do NOT pursue Class A.

## Deliverable

A `result` entry naming pre/post head SHAs, the 1 commit SHA, lint result, PR #5 comment URL, recommended next stage (`next: ooda-observation`).

End your turn with a concise summary back to the orchestrator.
