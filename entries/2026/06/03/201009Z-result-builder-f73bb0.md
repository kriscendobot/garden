---
ts: 2026-06-03T20:10:09Z
kind: result
role: builder
worktree: dispatches/builder--f73bb0/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Reintroduced the `@endo/evasive-transform` censorship-evasion transform on the
Node-worker archive load path, which regressed when the workflow pivoted to
source-only ZIP archives via `@endo/compartment-mapper`'s `makeArchive`.

Branch chosen: `llm` (not `master`).
The dispatch named `master` as the base, but the ZIP-pivot regression lives only
on `llm` (commit `8cb7eaba8 feat(cli,daemon): makeArchive replaces makeBundle
(source-only ZIP caplets)`).
On `master`, the CLI's `endo make` still calls `bundleSource(filePath)` with no
options, defaulting to `endoZipBase64` with `moduleTransforms` running
`evadeCensor` inside `packages/bundle-source/src/endo.js`, so no regression
exists there.
The fix has to land where the code lives.
Per `skills/frozen-base-branch/SKILL.md`, branched off frozen base
`llm-720a396` and opened PR with that base.

PR: https://github.com/endojs/endo-but-for-bots/pull/418
(DRAFT, base `llm-720a396`, head `fix/endo-make-node-evasive-runtime`)

Two commits:

1. `fix(daemon): apply evasive transform at runtime in Node worker (regressed
   in ZIP-pivot)`
   - New module `packages/daemon/src/worker-archive-parsers.js` exports
     `evasiveParserForLanguage`, which clones the source-archive parsers from
     `@endo/compartment-mapper/import-archive-all-parsers.js` and wraps the
     `mjs` and `cjs` source parsers with an async layer that runs
     `@endo/evasive-transform`'s `evadeCensor` on the module bytes before
     parsing.
     Non-source parsers (`json`, `text`, `bytes`, `pre-mjs-json`,
     `pre-cjs-json`) are untouched.
   - `packages/daemon/src/worker.js` switches both `makeArchive` and
     `makeFromTree` from
     `import('@endo/compartment-mapper/import-archive-all-parsers.js').defaultParserForLanguage`
     to `import('./worker-archive-parsers.js').evasiveParserForLanguage`.
   - `packages/daemon/package.json` gains
     `@endo/evasive-transform: workspace:^` as a direct dependency.
   - Two new test fixtures (`archive-evasive-jsdoc-import`,
     `archive-evasive-endo-errors`) and two new tests in
     `packages/daemon/test/endo.test.js` pin the regression.
   - Changeset `daemon-evasive-runtime-transform.md` declares the patch.

2. `chore: Update yarn.lock` (separate per `skills/yarn-lock-separate-commit/SKILL.md`).

Regression baseline (sabotage probe): swapping the worker's wrapped map back to
the unwrapped `defaultParserForLanguage` makes both new tests fail with:

- `SyntaxError: Possible import expression rejected at
  .../archive-evasive-jsdoc-import/index.js:8. (SES_IMPORT_REJECTED)` —
  the TS JSDoc `import('node:fs').Stats` annotation.
- `SyntaxError: Possible import expression rejected at
  .../errors/index.js:68. (SES_IMPORT_REJECTED)` —
  the `@endo/errors` `index.js` JSDoc shape.

Restored the wrap; both tests pass.
All six `makeArchive` tests and all four `Phase 7: makeFromTree` tests
continue to pass.
`prettier --check`, `tsc --noEmit` clean.
`eslint` clean on touched files (no errors; pre-existing jsdoc-warning style
in adjacent code).

Rust side untouched (no files under `rust/` touched; on the `llm` branch the
Rust supervisor reads the same archive bytes directly and the wrapping does
not affect that path).

The archive blob remains untransformed: the CLI's `makeCompartmentArchive`
call in `packages/cli/src/commands/make.js` continues to pass
`sourceParserForLanguage` (no transforms) when packing.
The transform happens in memory on the way to the compartment.
The archive format is unchanged.

Files modified:
- `packages/daemon/src/worker-archive-parsers.js` (new)
- `packages/daemon/src/worker.js`
- `packages/daemon/package.json`
- `packages/daemon/test/endo.test.js`
- `packages/daemon/test/fixtures/archive-evasive-jsdoc-import/index.js` (new)
- `packages/daemon/test/fixtures/archive-evasive-jsdoc-import/package.json` (new)
- `packages/daemon/test/fixtures/archive-evasive-endo-errors/index.js` (new)
- `packages/daemon/test/fixtures/archive-evasive-endo-errors/package.json` (new)
- `.changeset/daemon-evasive-runtime-transform.md` (new)
- `yarn.lock`

Self-improvement: the dispatch prompt named `master` as the base, but the
ZIP-pivot regression only exists on `llm`.
A builder that branches strictly to the prompt's named base would have produced
a no-op PR (master is not regressed).
The lesson is for the orchestrator that drafts builder dispatches against
endo-but-for-bots: when the maintainer's directive names a feature pivot
("we pivoted to a ZIP based workflow"), check which branch carries the pivot
before assigning the base.
The `llm`-versus-`master` split on endo-but-for-bots is the recurring
fault line; a one-line check via
`git log --oneline endo-upstream/master..endo-upstream/llm -- <pivot-area>`
would have caught it.
Routing this as a `message` to `liaison` rather than a role/skill edit since
the existing builder norm
("A design that lives on the roadmap branch is read, not branched-from")
already covers the design case; this is the *implementation-side*
counterpart that wants a one-line companion bullet on the steward or
liaison's dispatch-construction notes for endo-but-for-bots, not a new
skill.
