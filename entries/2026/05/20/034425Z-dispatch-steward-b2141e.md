---
ts: 2026-05-20T03:44:25Z
kind: dispatch
role: steward
to: fixer
dispatch_id: b2141e
dispatch_root: /home/kris/dispatches/fixer--b2141e
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch fixer b2141e — 2 lint warnings break #75 CI post-rebase

After weaver 7cc22c rebased PR #75 onto fresh master (`e8fa0ec7a`), CI's `lint` job fails with "0 errors, 2 warnings" (warnings treated as errors). Both auto-fixable per the message:

- Line 25:1 — `jsdoc/check-alignment`: "Expected JSDoc block to be aligned"
- Line 340:3 — `jsdoc/require-param`: Missing JSDoc @param "args" declaration

File location isn't in the log snippet — fixer must run `yarn lint` in the project worktree to identify the file. Likely a file touched by the rebase merge with master's import-x migration.
