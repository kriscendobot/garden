---
ts: 2026-06-17T22:34:42Z
kind: result
role: fixer
worktree: dispatches/fixer--7bc120/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/220700Z-dispatch-fixer-7bc120.md
---

Addressed kriskowal's CHANGES_REQUESTED review on PR #442 ("Rebase on latest LLM, retcon, and remove the unrelated work on registry"): rebased onto live `llm` (f9ff85c55), dropped two registry-capability commits (PR #403 carries them), retconned the remaining daemon-cas work into 3 sensibly grouped commits.

## SHAs

- Pre-retcon head: `42f3a179e` (10 commits on top of `origin/llm-c85d618`).
- Post-retcon head: `e4d85534c` (3 commits on top of `origin/llm` = `f9ff85c55`).

## Retcon mapping (10 to 3)

- `c73edd2cf` `feat(daemon-cas): new package extracting CAS surface from daemon` — folds `6a8c455a9` + `f472c43c5` (prettier) + `6a5a377df` (ses-ava wrap) + `cd7adacd8` (joinPath tests) + an inline-import-to-`@import` fix on `test/content-store.test.js` for the pre-push-gates probe.
- `7f9a94b35` `feat(daemon): delegate CAS to @endo/daemon-cas` — folds `536a6fb5d` + `42f3a179e` (composite tsconfig regenerate).
- `e4d85534c` `chore: Update yarn.lock` — replaces `d2d3e11b9`, regenerated against the rebased base.

## Registry commits dropped

- `02cba42aa` `feat(registry-capability): EndoRegistry capability + JS reference backend (#358 layer 1)`.
- `5215d7a26` `chore(registry-capability): prettier-format types.d.ts`.

These remain on `feat/registry-capability` (PR #403) where they belong; this branch was not their source of truth. The corresponding `packages/registry-capability/*` paths, the `.gitignore` line for that package's types, and the `tsconfig.composite.json` entry are out of `feat/daemon-cas-extraction`'s net diff. PR #403 is untouched.

## Net diff invariant

Verified within daemon-cas scope: per-file `git show HEAD:<path>` vs `git show pre-retcon-7bc120:<path>` is byte-identical on all 17 daemon-cas-scoped files (`packages/daemon-cas/*`, `packages/daemon/{package.json, src/daemon-persistence-powers.js, tsconfig.composite.json}`). The two root-level files (`.gitignore`, `tsconfig.composite.json`) differ by exactly the registry-capability lines (correctly dropped) plus the trunk-side additions/removals that landed on `llm` between `llm-c85d618` and `f9ff85c55` (chacha12, exo-playwright, random, tar tsconfig entries; `/dist/` removed from .gitignore).

## Test results

- `packages/daemon-cas/` `yarn ava`: 9/9 passing.
- `packages/daemon-cas/` `yarn lint`: 0 errors (2 pre-existing `any` warnings on test-side type assertions).
- `packages/daemon-cas/` `yarn lint:types` (tsc): 0 errors.
- Trunk-wide `yarn lint` from the daemon package surfaces a pre-existing `@endo/tar/reader.js` error (master sync removed `@endo/tar` but daemon's `tar-checkin.js` still imports it). Verified by running `yarn lint` on a clean `origin/llm` checkout: same error. Not introduced by this retcon.

## Pre-push-gates result

Clean on all `packages/daemon-cas/*` files after the inline-import fix on the test file. Remaining gate findings are pre-existing trunk issues unrelated to this PR's scope (`packages/chacha12-fast-check-test/package.json` test-package-no-main; sentence-per-line violations across many unrelated docs).

## PR housekeeping

- Title: dropped the "(PR #403 follow-on)" suffix; PR now stands alone.
- Body: rewritten to reflect rebased base and dropped registry-capability framing.
- Base: retargeted from `llm-c85d618` to `llm` (via `gh pr edit 442 --base llm`).
- Force-pushed `42f3a179e...e4d85534c` to `feat/daemon-cas-extraction` with `--force-with-lease`.
- Top-level summary comment posted: https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4736117662.

## Authorizations exercised

Per dispatch brief: force-push with lease, `gh pr edit` (base + body + title), top-level PR comment. Did not touch upstream `endojs/endo`. Did not un-draft (PR was already non-draft; the maintainer's review will determine the next state). Did not touch PR #403.

## Next stage

`next: liaison` — kriskowal asked for the rebase + retcon + scope-narrowing; the result is on the PR with the top-level summary cross-mapping pre-retcon to post-retcon. Liaison should surface the PR to the maintainer (the comment @-mentions kriskowal) and either re-request review or wait for the maintainer's response.

Self-improvement: nothing this time.
