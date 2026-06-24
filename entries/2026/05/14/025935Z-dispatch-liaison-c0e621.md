---
ts: 2026-05-14T02:59:35Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: target
---

# Dispatch: fixer renames @endo/syrups → @endo/syrup-frame on PR #109

Dispatch root: `dispatches/fixer--rename-syrups-to-syrup-frame--20260514-025933--c0e621/`. Project worktree at `endojs/endo-but-for-bots` on branch `feat/syrups-package`.

Maintainer feedback (this session): "The syrups package should be named syrup-frame."

## Per-action authorization

Standing on endo-but-for-bots per `journal/README.md` § Pre-staged authorizations. The fixer may push and comment freely on this repo.

## Task

Rename `@endo/syrups` to `@endo/syrup-frame` on the `feat/syrups-package` branch (PR #109). The rename is mechanical but touches many files:

1. **Package directory**: `git -C project mv packages/syrups packages/syrup-frame`. Confirm via `ls project/packages/`.
2. **`packages/syrup-frame/package.json`**: change `"name": "@endo/syrups"` → `"name": "@endo/syrup-frame"`. Also adjust the package's description if it currently names "syrups."
3. **All imports/exports of `@endo/syrups`** across the branch: `git -C project grep -l '@endo/syrups'` to find call sites; rewrite each `from '@endo/syrups'` / `require('@endo/syrups')` / `import('@endo/syrups')` to `@endo/syrup-frame`. Don't miss type-import paths (`@import { ... } from '@endo/syrups'`) or `package.json` dependency / workspace references.
4. **Documentation**: README and any prose that names the package; rename inline. Don't change protocol-level names (e.g. "Syrup" / "Syrups" as the wire-format name remains; only the package name changes).
5. **Workspace dependency lists**: `yarn.lock` will need regeneration. `cd project && yarn install` if available; commit the resulting lockfile in a SEPARATE commit per the `yarn-lock-separate-commit` skill.
6. **Manually apply underscored thousands** within the package's diff. The maintainer's directive: numeric literals should delimit groups of three with underscores (`1_000` not `1000`); hex literals should delimit groups of four (`0xFFFF_FFFF` not `0xFFFFFFFF`). Apply this **only to numerics inside the syrup-frame package's source** (not across the whole repo; the Prettier-rule builder dispatch will handle repo-wide). This anticipates the Prettier rule landing so the rebase is smooth.

## Validation

`cd project && yarn lint && yarn lint:types && yarn ava packages/syrup-frame/`. All must be clean. If the package's tests now expect different package-name strings in fixtures, update them.

## Commits

Suggested split (your call on slicing):

- `refactor(syrup-frame): rename @endo/syrups package to @endo/syrup-frame` — the rename itself (package dir mv, package.json name, all import-rewrites, docs).
- `chore: Update yarn.lock` — separate commit per `yarn-lock-separate-commit` skill.
- `chore(syrup-frame): delimit thousands with underscores` — if the underscore-thousands edit is large enough to warrant its own commit; otherwise fold into the rename commit.

Push to `feat/syrups-package` (force-push acceptable; this is a force-push-allowed garden-internal branch). Identity kriscendobot.

## Out of scope

- Do NOT update PR #242 (the consumer); that will rebase naturally after #109's rename lands.
- Do NOT update the upstream ferry (endojs/endo#3257); the maintainer will re-ferry after #109 lands renamed.
- Do NOT modify cbors (sister fixer dispatch).
- Do NOT change the wire-format name "Syrup" / "Syrups"; only the npm package name.
- Do NOT add the Prettier rule itself (separate builder dispatch).

## Report

PR #109 URL (unchanged), commit SHAs on the branch, files renamed count, import-rewrite count, lockfile-commit SHA, local-validation outcome, one-line confirmation that the rename is complete and underscored-thousands applied within the package's source.
