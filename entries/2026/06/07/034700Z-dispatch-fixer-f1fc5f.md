---
ts: 2026-06-07T03:47:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f1fc5f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/426
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641290562
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641292826
  - https://github.com/endojs/endo-but-for-bots/pull/426#issuecomment-4641329669
  - entries/2026/06/07/034000Z-dispatch-fixer-c71c70.md
  - entries/2026/06/07/034500Z-result-fixer-c71c70.md
---

# dispatch: fixer — directly address eslint-plugin-unicorn root-devDep gap on PR #426's branch

Maintainer's follow-up directive on `endojs/endo-but-for-bots#426`
at 2026-06-07T03:40:04Z (kriskowal):

> Please also address the problem directly on this PR. Do not wait
> for the fix on master.

This is the second of two directives kriskowal posted in quick
succession; the first (03:38:27Z) asked for a fresh PR against
master and the prior fixer dispatch `c71c70` discovered master
already provides the dep
(`entries/2026/06/07/034500Z-result-fixer-c71c70.md`). This dispatch
addresses the second directive.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#426`
  (`chore: merge actual/master into llm (2026-06-06)`), DRAFT,
  base `llm`, head `merge/actual-master-into-llm-20260606` at
  `61804678` (12 commits). Full SHA:
  `61804678682fe140ef433ef74f31f9e8ab6a8a66`.
- **Bot master**: `4a04d078` (already provides
  `eslint-plugin-unicorn ^56.0.1` in root `package.json` devDeps
  line 32, per the prior fixer's verification).
- **CI on PR #426**: 20 SUCCESS, 5 FAILURE (lint + 4 test-matrix);
  all 5 share the unicorn-peerDep-without-root-devDep root cause
  the prior shepherd `092a08` and the prior fixer `c71c70`
  identified.

## Root cause (from prior dispatches)

When the builder `d94d05`/`101dc2` performed the master-into-llm
merge for PR #426, the merge resolved master's atomic four-piece
unicorn commit (`c423ed37b chore(eslint-plugin): require
underscore-delimited groups in numeric literals`) asymmetrically:
the peerDep on `@endo/eslint-plugin` was adopted, and the internal
`internal.js` rule wiring was adopted, BUT the root `package.json`
devDep on `eslint-plugin-unicorn` was NOT adopted (it was dropped
during the merge per the prior sync's precedent of preserving the
bot fork's curated devDep set).

The result: at the merge's `61804678` tip, `package.json` lacks
the `eslint-plugin-unicorn` entry that the `@endo/eslint-plugin`
peerDep requires.

## Task

In your `project/` worktree on `merge/actual-master-into-llm-20260606`
(currently at `61804678`):

1. **Confirm the gap.** Read root `package.json` and verify
   `eslint-plugin-unicorn` is NOT in `devDependencies`. Verify
   `@endo/eslint-plugin`'s `peerDependencies` does include it.
2. **Add `eslint-plugin-unicorn` to root `package.json` devDeps.**
   Use the version pin from current bot master
   (`^56.0.1` per the prior fixer's reading of master line 32).
   Match the pin exactly; the goal is to replay master's curated
   choice without re-deciding.
3. **Regenerate `yarn.lock`** via `corepack yarn install`.
4. **Verify locally**: `corepack yarn lint` — should now resolve
   the `@endo/internal` extends chain cleanly. Pre-existing
   findings unrelated to this fix are expected; record them in
   your result.
5. **Commit**:
   - `chore: add eslint-plugin-unicorn to root devDeps (close the
     llm-merge asymmetry)` (touches `package.json`).
   - `chore: Update yarn.lock` (touches `yarn.lock`), separate
     commit per the standing convention.
6. **Force-with-lease push** (the branch is the merge's head; a
   regular append is appropriate — no force needed since you're
   adding commits, not rewriting):
   ```
   git push origin HEAD:merge/actual-master-into-llm-20260606
   ```
   (Use plain `push`, not `--force-with-lease`; the new commits
   append to the existing history.)
7. **Reply** on PR #426 with a brief comment acknowledging the
   directive, citing the new commit SHAs, and noting CI is
   re-running on the new tip.

## Authorizations (per-action, forwarded by steward)

- **Push** new commits to `merge/actual-master-into-llm-20260606`
  (the PR head branch). Implicit in the dispatch.
- **Post the reply comment** on PR #426 (`endo-but-for-bots`
  standing broad-comment authorization).

## Out of scope

- Do NOT touch the `llm` branch directly.
- Do NOT open a separate PR; this is a direct-on-#426 fix per the
  maintainer's explicit second directive.
- Do NOT shepherd CI to green; a follow-on shepherd will handle
  CI propagation if needed.

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- Pre- and post-push branch tip SHAs.
- The diff: `package.json` line change(s), `yarn.lock` line count
  change.
- The commit SHAs (separately for the package.json commit and the
  yarn.lock chore).
- Local lint verification output (the cascade should resolve;
  pre-existing findings are fine).
- The reply comment URL on PR #426.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
