---
ts: 2026-06-04T03:46:50Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--e2458c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/418
---

# dispatch: fixer — #418 lint fix (post-rebase)

Maintainer directive (kriskowal, 2026-06-04T03:46:11Z):

> Please continue the shepherd. This needs a fix for lint as
> described in the CI log.

#418 post-rebase has 1 failing job: `lint`. Failure cause per
maintainer is in the CI log; investigate and fix.

## Target

- PR: endojs/endo-but-for-bots#418
- Branch: `fix/endo-make-node-evasive-runtime`
- Head: `ecc79b3ed` (post weaver rebase).
- Base: `llm-2bd9e0c`.

## Procedure

1. Pull the lint failure log:
   ```
   gh run list --repo endojs/endo-but-for-bots --branch fix/endo-make-node-evasive-runtime --workflow CI --limit 3
   gh run view <id> --repo endojs/endo-but-for-bots --log-failed
   ```
   Look at the lint job specifically.
2. Identify the cause (likely from the fixer 091a1a's
   evasive-parser injection refactor — e.g., an unused
   import, a JSDoc reference that didn't update, an eslint
   rule violation in the refactor).
3. Apply the surgical fix.
4. Run `yarn workspace @endo/daemon lint` locally.
5. Commit (regular append):
   ```
   fix(daemon): clear lint per CI feedback
   ```
   (Or a more specific subject naming the actual fix.)
6. Push.

## Per-action authorizations

- Read CI log + relevant files. Authorized.
- Edit files needed to clear lint (likely
  `packages/daemon/src/` or `packages/daemon/test/`).
  Authorized.
- One regular-append commit + push. Authorized.

## Not authorized

- Modifying files outside `packages/daemon/`.
- Touching upstream.
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--e2458c/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--e2458c/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `fix/endo-make-node-evasive-runtime`
(head `ecc79b3ed`).

## Report

A `result` journal entry. Include:

- Lint failure cause from CI log.
- Files touched + summary.
- New head SHA.
- Local lint exit code.
- Judgment calls.
