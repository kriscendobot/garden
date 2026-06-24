---
ts: 2026-05-29T22:14:37Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d808b5
prs:
  - repo: endojs/endo-but-for-bots
    pr: 345
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/345
  - entries/2026/05/29/221321Z-result-shepherd-e2d1ef.md
---

# dispatch: fixer — #345 regenerate composite tsconfig files (shepherd escalation)

Per memory rule `feedback_shepherd_to_fixer_auto_chain.md`: shepherd
`e2d1ef` escalated PR #345's lint failure (different cause than the
prior SECURITY.md drift) as real-and-fixer-fixable. Steward
auto-dispatches.

## Task

Regenerate composite tsconfig files to register the new
`packages/cancel` workspace and update the drifted cli/daemon/root
composites. Per the shepherd's report:

```
Missing: packages/cancel/tsconfig.composite.json
Drift detected: packages/cli/tsconfig.composite.json
Drift detected: packages/daemon/tsconfig.composite.json
Drift detected: tsconfig.composite.json
```

Procedure:

1. `corepack yarn install` (if not already done — the fixer's prep
   may need it).
2. `yarn build:types:gen` — generates / updates the 4 composite
   tsconfig files.
3. Verify via `yarn build:types:check` exit 0.
4. Stage only those tsconfig files (probably 4 files). Commit:
   ```
   chore(cancel,cli,daemon): regenerate composite tsconfig files
   ```
5. Push (regular append, no force): `git push origin
   HEAD:mirror/3032-cancel`.

## Per-action authorizations

- Run `corepack yarn install` and `yarn build:types:gen`. Authorized.
- Edit composite tsconfig files (generated). Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:mirror/3032-cancel`. Authorized.

## Not authorized

- Modifying source files outside the generated composite tsconfigs.
- Force-pushing rewrite.
- Un-drafting / re-drafting.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--d808b5/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--d808b5/garden/roles/fixer/AGENT.md`
3. Skills referenced by the fixer just-in-time.

Project worktree at `project/` on `mirror/3032-cancel` (head
`5238e8a88`).

## Report

A `result` journal entry. Include: new head SHA, list of files
changed (expected 4 composite tsconfigs), `yarn build:types:check`
local exit code, any PR comments.
