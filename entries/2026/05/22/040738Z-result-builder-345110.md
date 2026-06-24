---
ts: 2026-05-22T04:07:38Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--345110/project
refs:
  - entries/2026/05/22/035259Z-dispatch-liaison-345110.md
---

# Result: builder extends Prettier configuration to format Markdown files (PR #357)

PR: https://github.com/endojs/endo-but-for-bots/pull/357 (DRAFT, base `llm`).
Head SHA: `87f1dd96404602f60fa1bc6584e3e14bd9a3e045`.
Branch: `chore/prettier-markdown`.

## Config files edited (commit 1, `30e3d7a7a`)

- `.prettierignore`: drop blanket `*.md`; add narrow `/packages/*/CHANGELOG.md` (changesets-regenerated).
- `package.json` `prettier` field: add `overrides: [{ files: ['*.md', '*.markdown'], options: { proseWrap: 'preserve' } }]`.
- `package.json` scripts (`format`, `lint:prettier`, `lint:workspaces`): widen positional args from `.github packages` to `'*.md' .github docs designs packages`.
- 2 files, +15 -5.

## Format pass (commit 2, `87f1dd964`)

- 302 files changed, +8441 -7464.
- 301 `*.md` files plus `docs/assets/custom.css` (one trivial leading-blank-line trim; picked up because `docs/` joined the format scope).

## Sentence-per-line regressions

None. Multi-sentence-physical-line count across the 301 changed `.md` files: 3674 pre-format -> 3616 post-format (delta -58). No per-file regression: every file's count is unchanged or improved. `proseWrap: 'preserve'` worked as intended; the small improvement comes from `*` -> `-` list-marker normalization (probe excludes list-item lines) and double-space-after-period collapse.

## Pre-push-gates probe status

- `sentence-per-line-md` (PR-scope vs `origin/llm`): strictly improved (-58 findings); pass.
- `no-ascii-banners`, `no-pull-citations`, `no-inline-import-jsdoc`, `filename-no-stutter`, `security-md-hash-uniform`: probes "fail" when run from the working tree without staging but the findings are all pre-existing llm-vs-master deltas, not introduced by this PR (the probes fall back to `origin/master` when no `--cached` diff is present and this branch is detached on llm).

## Local validation

- `yarn format`: idempotent (no diff on a second invocation).
- `yarn lint:prettier`: `All matched files use Prettier code style!`.
- `yarn lint`: 0 errors, 1760 pre-existing warnings (jsdoc, jessie).
- `yarn docs`: 0 errors, 69 pre-existing warnings (anchor mismatches in the api-docs render).
- No root `yarn typecheck` script; `yarn docs` exercises typedoc/tsc.

## Carve-outs added

- `/packages/*/CHANGELOG.md` ignore: changesets regenerates these on release; formatting them would churn on every cut.
- `.prettierrc.json` left untouched. It is dead config (Prettier's lookup picks the `package.json` `prettier` field first in the same dir, so `.prettierrc.json`'s `trailingComma: all` is currently inactive). Untangling the two is out of scope for this PR; consolidation should be a separate change because activating `.prettierrc.json` would change JS-tree formatting (large unrelated diff).

## Decisions

- Override placed on `package.json` `prettier` field (the active config) rather than `.prettierrc.json` (shadowed).
- Format scope widened to include `docs designs` and a top-level `'*.md'` glob, the minimum needed for the dispatch rationale (design corpus on llm). `TADA/`, `PLAN/`, `pivoker/`, `evoke/`, `scripts/`, `.changeset/`, `.claude/` left out as scratch / tool-managed dirs.
- Excluded an out-of-scope yarn-install reformat of `packages/hex-test/package.json` that appeared during `corepack yarn install`; reverted with `git checkout --` before staging commit 1.

Self-improvement: the `.prettierrc.json`-vs-`package.json` shadowing surprise is the kind of latent-bug-disguised-as-redundancy a future builder dispatch will trip on too; worth a `groom` note for a follow-up consolidation PR. No structural lesson for the builder role itself.
