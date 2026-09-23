---
ts: 2026-05-29T21:38:36Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b16192
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/345
  - entries/2026/05/29/213642Z-result-shepherd-7e6309.md
---

# dispatch: fixer — #345 align packages/cancel/SECURITY.md with canonical (shepherd escalation)

Per memory rule `feedback_shepherd_to_fixer_auto_chain.md`: shepherd
`7e6309` escalated PR #345's lint failure as real-and-fixer-fixable.
Steward auto-dispatches the fixer.

## Task

Fix the `bash scripts/check-security-md.sh` lint failure on PR #345.
Per the shepherd's report:

- `packages/cancel/SECURITY.md` line 24 drifts from the canonical
  (4-package-majority) version by a one-character capitalization:
  `public Github issues` should be `public GitHub issues`.
- Fix: either edit the one character, or replace the file with
  `packages/ses/SECURITY.md` (the canonical reference). Use judgment
  on which is cleaner.

Commit as a single chore commit:

```
chore(cancel): align SECURITY.md with canonical
```

Force-with-lease push to `mirror/3032-cancel`. (Force-with-lease
because the push appends; not a rewrite. But the branch is shared so
`--force-with-lease` is still the correct push form.)

Actually: a regular append push works here too (no rewrite). Use
`git push origin HEAD:mirror/3032-cancel` without --force-with-lease.

## Verify

Before pushing, run `bash scripts/check-security-md.sh` locally and
confirm exit 0.

## Per-action authorizations (forwarded)

- Edit `packages/cancel/SECURITY.md`. Authorized.
- Push (regular, append) to
  `endojs/endo-but-for-bots:mirror/3032-cancel` under bot identity.
  Authorized.

## Not authorized

- Modifying other files (this is a single-file alignment fix).
- Force-pushing rewrite (the append doesn't need it).
- Rewriting any of the retcon's 3 commits (would break their
  per-package boundaries).
- Un-drafting or re-drafting.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--b16192/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--b16192/garden/roles/fixer/AGENT.md`
3. Skills referenced by the fixer role just-in-time.

Project worktree at `project/` on `mirror/3032-cancel` (head
`73332aaef`).

## Report

A `result` journal entry. Include: new head SHA after push, the
single-line change content, `scripts/check-security-md.sh` exit code
locally, any PR comments posted.
