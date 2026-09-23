---
ts: 2026-05-14T02:59:35Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 111
    role: target
---

# Dispatch: fixer renames @endo/cbors → @endo/cbor-frame on PR #111

Dispatch root: `dispatches/fixer--rename-cbors-to-cbor-frame--20260514-025934--4ae6ff/`. Project worktree at `endojs/endo-but-for-bots` on branch `stack-ocapn-noise/layer-1-ocapn-codec`.

Maintainer feedback (this session): "It naturally follows that cbors should be renamed cbor-frame." (Following the syrups → syrup-frame rename.)

## Per-action authorization

Standing on endo-but-for-bots.

## Task

Rename `@endo/cbors` to `@endo/cbor-frame` on PR #111's branch. Same shape as the syrup-frame rename (sister dispatch):

1. `git -C project mv packages/cbors packages/cbor-frame`.
2. `packages/cbor-frame/package.json` name field.
3. All imports / exports / type-imports / workspace deps across the branch (`git -C project grep -l '@endo/cbors'`).
4. Documentation / README / inline prose mentions.
5. yarn.lock regeneration in a separate commit.
6. **Manually apply underscored thousands** within the package's diff (anticipates the Prettier rule's behavior; rebase is smoother if applied now).

## Validation

`cd project && yarn lint && yarn lint:types && yarn ava packages/cbor-frame/`. All clean.

## Commits

Same shape as syrup-frame: rename commit, yarn.lock commit, optional underscored-thousands commit. Push to `stack-ocapn-noise/layer-1-ocapn-codec`. Identity kriscendobot.

## Out of scope

- Do NOT touch downstream PRs that consume @endo/cbors (#112, #113, etc.); they rebase naturally.
- Do NOT modify syrups (sister fixer dispatch).
- Do NOT change the wire-format name "CBOR"; only the npm package name.
- Do NOT add the Prettier rule itself (separate builder dispatch).

## Report

PR #111 URL (unchanged), commit SHAs on the branch, files renamed count, import-rewrite count, lockfile-commit SHA, local-validation outcome.
