---
ts: 2026-05-29T02:21:57Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--a987c3
refs:
  - entries/2026/05/29/021400Z-dispatch-general-contractor-bf3a91.md
  - jobs/claimed/20260529T021105Z--endolinbot--general-contractor--dde2--d830d2--endo-gateway-where-slice-1-337.md
---

# Fixer result: PR #337 summary-fix bundle (job d830d2)

Addressed the two-item `summary-fix` bundle on PR
[endojs/endo-but-for-bots#337](https://github.com/endojs/endo-but-for-bots/pull/337)
`feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)`,
branch `feat/endo-gateway`. PR remains OPEN and un-drafted.

## Branch head

- Before: `304ee587c` (origin/feat/endo-gateway at fetch time; the dispatch
  worktree was prepared at the earlier `3e3468638` but origin had advanced
  with `bf4890e92` and `304ee587c`; reset to the PR head before applying
  edits so the result lands on the live tip).
- After: `73a8ecb4ac5133abc2d0fcd9afa99de150b27007`.

## Per-item commit mapping

1. **PR title scope rewrite** (no commit). Applied via the per-action
   authorization carried in the dispatch:

   ```sh
   gh pr edit 337 -R endojs/endo-but-for-bots --title 'feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)'
   ```

   New title (verified via `gh pr view`):
   `feat(where): Endo Gateway host-scope path functions (scaffolding slice 1)`.

2. **DRY the Windows `info.home\..\..\ProgramData` fallback in
   `packages/where/index.js`**. Commit `73a8ecb4a`
   (`refactor(where): DRY Endo Gateway Windows ProgramData fallback`).
   Hoists `whereGatewayProgramData(env, info)` alongside the existing
   `whereHomeWindows` helper; the three duplicated synthesis branches
   (`whereEndoGatewayState`, `whereEndoGatewayEphemeralState`,
   `whereEndoGatewayCache`) each collapse to a single
   `${whereGatewayProgramData(env, info)}\Endo Gateway[\Run|\Cache]`
   call. JSDoc shape and parameter names follow the suggested-helper
   shape from the claimed-job body. The `whereEndoGatewayRegistrarSock`
   path is unchanged (it derives from `whereEndoGatewayEphemeralState`
   on POSIX and uses a Windows named-pipe constant on `win32`, so it
   never touched the synthesis).

## Local gates

- `yarn install` (workspace root): clean.
- `yarn test` in `packages/where`: 30 tests passed (the cleaner-added
  PROGRAMDATA-undefined Windows fallback tests and the registrar-socket
  composition test from `bf4890e92` and `304ee587c` are part of the
  30; the claimed-job body's "28-test set" wording predated those two
  commits).
- `yarn lint` in `packages/where`: clean (silent pass).
- `bash garden/skills/pre-push-gates/pre-push-gates.sh --summary .`:
  the `yarn format` and `yarn lint --fix` auto-fix stages produced
  tree-wide drift (touched `packages/evasive-transform/src/index.js`
  and `packages/ses/src/compartment.js`). Reverted both per the
  2026-05-20 fixer note; only `packages/where/index.js` was staged.
  Probes against the resulting staged diff plus baseline (`git stash`
  comparison) showed three findings (`no-inline-import-jsdoc` on
  pre-existing `@type {typeof import(...)}` annotations in
  `packages/where/index.js`; `filename-no-stutter` on pre-existing
  `where-endo-*.test.js` test filenames; `security-md-hash-uniform`
  on pre-existing divergent SECURITY.md files in
  `immutable-arraybuffer`, `bytes`, `hex`, `panic`). **None of these
  findings are caused by the fixer's change**; all three were already
  failing on `304ee587c` and are out of scope for this summary-fix
  bundle.

## Push

`git push origin HEAD:feat/endo-gateway` succeeded:
`304ee587c..73a8ecb4a  HEAD -> feat/endo-gateway`. GitHub's response
included a Dependabot vulnerability advisory header (47 vulnerabilities
on the default branch); informational, not blocking.

## Status

PR remains un-drafted. The bundle was non-blocking for un-draft (per
the claimed-job framing); no further panel round is expected. The
maintainer's review is the next venue.

Self-improvement: `yarn format` and `yarn lint --fix` continue to
produce tree-wide drift across packages the fixer did not touch; the
2026-05-20 fixer note documenting the revert-before-staging step is
correctly carried in the dispatch prompt and remains load-bearing. No
new skill update warranted this turn.
