---
ts: 2026-05-20T01:20:06Z
kind: result
role: fixer
worktree: dispatches/fixer--11aa39/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Fixer on endojs/endo-but-for-bots#75: 10 inlines from kriskowal's 00:38Z CHANGES_REQUESTED

Addressed the ten inline asks from the 2026-05-20T00:38:33Z review (review id `4324296886`).
Eight produced code commits, two are reply-only confirmations of the existing arrangement, and one is partially-landed with an explicit clarification ask back on the thread.

## Per-ask disposition

| inline id | path | disposition | commit / reply |
|---|---|---|---|
| 3270497748 | `.changeset/endo-chacha12.md` | bumped both `@endo/random` and `@endo/chacha12` to `major` so first release is 1.0.0 | `5bd851c84` |
| 3270499077 | `.changeset/endo-chacha12.md` | dropped the stale `@endo/random/fast-check.js` bullet (subpath withdrawn when fast-check integration moved to sibling `@endo/chacha12-fast-check-test`) | `5bd851c84` |
| 3270500584 | `.changeset/endo-chacha12.md` | rewrapped body per CONTRIBUTING.md § Markdown Style Guide (one sentence per line) | `5bd851c84` |
| 3270520557 | `packages/chacha12/test/fill-random-bytes.bench.js` | collapsed portable-timer fallback to `Number(process.hrtime.bigint())`; `Uint8Array.from({length}, ...)`; `padStart`/`padEnd`; dropped duplicate `copywin` variant | `11f8bbd72` |
| 3270527743 | `packages/chacha12/index.js` | reply-only: confirmed thunk filters exports (re-exports only `makeChaCha12` / `makeChaCha12FromState`; not `BLOCK_SIZE` / `chacha12Block` / `chacha12State`). Matches AGENTS.md § Thunk modules reason 2 | reply `3270680709` |
| 3270531154 | `packages/chacha12/src/chacha12.js:151` | reply-only: no, `BLOCK_SIZE` / `chacha12Block` / `chacha12State` should remain unexported through the thunk; kept exportable from `src/chacha12.js` only for the in-package known-answer tests | reply `3270680910` |
| 3270538201 | `packages/random/src/uint.js:34` | partially-landed (consolidation onto one ArrayBuffer already on remote at `1f64e3be8`); reply asks which of three readings of "just the largest of these" the reviewer means before rewriting the staircase (overdraw 8 bytes would break the byte-count tier semantics in `randomInt` + `test/int.test.js:136–186`) | reply `3270681435` |
| 3270550084 | `tsconfig.eslint-base.json:13` | moved `skipLibCheck` from base to `packages/chacha12-fast-check-test/tsconfig.json` with cause comment (fast-check@4 d.ts TS1255); verified `yarn workspaces foreach --all run lint:types` clean post-move | `76b8168d6` |
| 3270551813 | `packages/random/README.md:56` | ran prettier on file (with `--ignore-path=/dev/null` because root `.prettierignore` excludes `*.md`); kept one-sentence-per-line for body | `7130f1178` |
| 3270553775 | `packages/random/README.md:91` | dropped "Reusable scratch buffers" section; V8 element-kind rationale lives in `src/uint.js` header where future maintainers need it | `7130f1178` |

## Commits pushed

In push order on `kriskowal-random-chacha12`:

1. `5bd851c84` `chore(changeset): major bumps, drop stale fast-check.js bullet, one-sentence-per-line (#75)`
2. `11f8bbd72` `bench(chacha12): simplify fill-random-bytes.bench.js on Node.js 22+ (#75)`
3. `76b8168d6` `fix(types): narrow skipLibCheck to chacha12-fast-check-test only (#75)`
4. `7130f1178` `docs(random): prettier-format tables, drop scratch-buffer section (#75)`

Push result: `106c6ba8c..7130f1178  HEAD -> kriskowal-random-chacha12`.

The dispatch was prepared against a project worktree at `9e3a77276` which predated the 16:03–16:13 UTC concurrent refactor round (`a6a47720a` `bobsCoffee64`→`bobsCoffee32`, `1f64e3be8` uint scratch consolidation, `106c6ba8c` bench banner drop, etc.).
A local commit that consolidated `uint.js` was redundant with the already-landed `1f64e3be8` and was skipped on rebase.
The README / changeset on this push reflect the post-rename `bobsCoffee32`.

## Top-level summary

Posted at `endojs/endo-but-for-bots#75` issue comment `4493644326` mapping each inline ask to its addressing SHA, matching the 2026-05-12 round's shape (issue_comment `4427377828` was the template).
The summary table documents the partial-disposition + open-question on the uint.js consolidation and explicitly cites the byte-count tier conflict.

## Local lint and tests

After rebase and before push:

- `yarn lint:prettier` (repo-wide): clean.
- `yarn workspaces foreach --all run lint:types` (repo-wide): clean (validation that removing `skipLibCheck` from the base did not surface latent d.ts errors elsewhere).
- `yarn lint` on `packages/random`, `packages/chacha12`, `packages/chacha12-fast-check-test`: clean.
- `yarn ava` on `packages/random`: 15/15 (one harmless "Failed to exit" noise on `random.bench.js` is pre-existing; the bench file is mis-loaded by ava's `test/**/*.test.*` glob negotiation, not introduced by this dispatch).
- `yarn ava` on `packages/chacha12`: 32/32.
- `yarn ava` on `packages/chacha12-fast-check-test`: 7/7.

## Post-push CI

Sampled 15s after push: `build` PASS in 36s; `lint`, `cover`, `test (matrix x 8)`, `test-async-hooks`, `test-hermes`, `test-xs`, `test262`, `viable-release`, `browser-tests`, `check-action-pins`, `zizmor` all PENDING.
Did not wait for full convergence; the steward's per-cycle CI scan will surface red if any.

## Cross-cutting observations

- **The `skipLibCheck` relaxation was overscope, and the fix is mechanically straightforward** (move from root tsconfig to the one package that depends on the offender). No analogous overscoped relaxations elsewhere in the tree surfaced during the `yarn workspaces foreach --all run lint:types` validation. Worth a future janitorial pass to check whether any other base-level options are similarly carrying single-package costs, but no obvious next target.

- **The `*.md` exclusion in root `.prettierignore` interacts with the maintainer's "prettier" inline review comments in a subtle way.** Prettier won't enforce markdown formatting from `yarn lint:prettier`, but reviewers still expect specific files to be prettier-formatted on request. The `--ignore-path=/dev/null` override is the right tool for one-off applications, but the result has to be hand-curated because prettier's "join sentences into long lines" default conflicts with CONTRIBUTING.md's "start each sentence on a new line" style guide. A future fixer addressing prettier asks on markdown files should expect to merge the two styles manually.

- **The concurrent-rebase mechanics worked cleanly** (rebase + skip the redundant commit + manual table-row conflict resolution + push fast-forward). One conflict on the changeset bullet list, one on the bench `nowNs` declaration, one on the README subpath table, one auto-skipped on `uint.js`. The dispatch prompt's `kriskowal-random-chacha12` branch reference was correct; only the project worktree's starting SHA was stale relative to the upstream's last 16:03–16:13 refactor round.

- **The `randomUint*` "just the largest of these" thread is the only remaining open item.** The reviewer's persistence across rounds (3267743549 → 3270538201) suggests they have a specific simplification in mind that the in-code bench commentary doesn't quite capture. The reply enumerates three readings; whichever the reviewer picks may have implications for `randomInt`'s staircase and the `int.test.js` byte-count test. Not a blocker for this dispatch.

Self-improvement: notes from the field for `skills/review-feedback-followup-commits/SKILL.md`. When a dispatch's project worktree is prepared against a branch tip that the prior round of fixer commits has moved past, the rebase machinery already handles the merge cleanly, but the fixer's commit messages and inline replies need to be written with the post-rebase commit SHAs (gathered after `git rebase --continue` finishes, not from the local pre-rebase log). Citing pre-rebase SHAs in replies would confuse the reviewer. The skill currently doesn't say this; "Notes from the field" is the right home for the lesson. Routing as a `message: fixer → liaison` after this entry lands.
