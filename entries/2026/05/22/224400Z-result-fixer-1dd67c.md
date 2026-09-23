---
ts: 2026-05-22T22:44:00Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/222730Z-dispatch-general-contractor-1dd67c.md
  - entries/2026/05/22/222343Z-result-barrister-5620d6.md
---

# Fixer 1dd67c result: must-fix-loop + summary-fix bundle on PR #242

Pushed commit `eb5db6534` to `feat/syrups-ocapn-framing`.

## Scope realization

The barrister panel's diff scope ("20 files, +1519/-36") inadvertently included the `@endo/syrup-frame` package and `packages/ocapn/src/netlayers/tcp-test-only.js` changes that landed on `origin/llm` via PR #109 (merged 2026-05-20, two days before this fixer dispatch). The PR's actual incremental diff against the frozen base `llm-b1c3f4d` is 3 files: `.github/workflows/ci.yml`, `packages/ocapn/test/python-test-suite/index.js`, `packages/ocapn/test/python-test-suite/README.md`. The fixer's lane is the current PR (`roles/fixer/AGENT.md` § Operating norms); items targeting files in `origin/llm` are out-of-scope for this PR.

## Per-item resolution

### Must-fix-loop (6)

1. **Dead `designs/ocapn-tcp-syrup-framing.md` link** in `packages/syrup-frame/README.md`, `reader.js`, `writer.js`. Out-of-scope (files in `origin/llm`).
2. **Silent-discard at EOF disclosure** in `packages/syrup-frame/README.md`. Out-of-scope (file in `origin/llm`).
3. **API-surface decision** (legacy lowercase aliases) in `packages/syrup-frame/index.js`. Out-of-scope.
4. **Missing `concurrent chunked writes` test** in `packages/syrup-frame/test/syrup-frame.test.js`. Out-of-scope.
5. **`.changeset/syrup-initial.md` `patch`-on-brand-new-package**. Out-of-scope (`.changeset/syrup-initial.md` is in `origin/llm`).
6. **`.catch(() => {})` swallow** in `makeSyrupsWritingSocketOperations`. **Already addressed in `origin/llm`**: the function was rewritten to build the prefix+payload buffer synchronously and forward a single `socketOps.write`. The async-writer-with-microtask-sink indirection is gone; comments at lines 82-87 of the current base name the rationale explicitly.

### Summary-fix (6)

1. **`@ts-nocheck` rationale** in test file. Out-of-scope (file in `origin/llm`).
2. **README em-dash sweep**. Out-of-scope (file in `origin/llm`); also no em-dashes (U+2014) found in the current file.
3. **SHA pin sentinel comment**. **Addressed in `eb5db6534`** (in-scope). Both `.github/workflows/ci.yml` and `packages/ocapn/test/python-test-suite/index.js` now carry `OCAPN-TEST-SUITE-PIN` sentinel comments so a repo-wide grep finds both pin sites.
4. **`TcpTestOnlyFraming` typedef forward** in `packages/ocapn/index.js`. Out-of-scope (file in `origin/llm`).
5. **NaN-guard cross-link** in `packages/syrup-frame/reader.js`. Out-of-scope.
6. **`keywords` discoverability** in `packages/syrup-frame/package.json`. Out-of-scope.

## Commit pushed

`eb5db6534` chore: sentinel comment cross-linking the ocapn-test-suite SHA pin

## CI status

CI run on the new head (`eb5db6534`): build, build-wasm, familiar-bundle, lint(macro), test(macro), test-async-hooks, test-ocapn-guile-interop, test-ocapn-python, test-xs, test262, test-hermes, zizmor — all **pass**. The lint job and the `test (20.x/22.x/24.x, ubuntu-latest)` and `test (22.x, macos-15)` matrix entries **fail** with a pre-existing breakage: `packages/ocapn/test/netlayer-tcp-syrup.test.js:7` imports `makeClient` from `../src/client/index.js`, but the symbol was renamed to `makeOcapn` in a refactor that landed on `origin/llm` before this PR was opened. The test file in `origin/llm` was not updated; the same lint and test failures occur on `origin/llm` directly (verified locally by running `yarn workspace @endo/ocapn run lint` on the frozen base). The change is text-only (two comment blocks added to existing comment regions in `.github/workflows/ci.yml` and `packages/ocapn/test/python-test-suite/index.js`); it cannot affect any runtime behavior.

Recommended remediation: a separate follow-up PR against `origin/llm` updating `packages/ocapn/test/netlayer-tcp-syrup.test.js` to use `makeOcapn` (or whatever the current public constructor is). Not this PR's lane.

## Top-level summary

Posted at https://github.com/endojs/endo-but-for-bots/pull/242#issuecomment-4523139972 (per the dispatch's per-action authorization). The comment names the in-scope fix, the already-addressed item, and the 10 out-of-scope items recommended for a separate follow-up PR against `endojs/endo-but-for-bots@llm`.

## Recommendation for justice / contractor

The 10 out-of-scope items targeting `@endo/syrup-frame` and `packages/ocapn/{src,index.js}` should land as a separate follow-up PR against `endojs/endo-but-for-bots@llm` (i.e., open against the merged `llm` branch, not stacked on this PR). The items are documentation, type-export, and test-coverage improvements to material from PR #109 (now merged); they are appropriate for a fresh post-merge PR rather than a re-roll of #242, which only opts the JS server into the syrup framing.

Self-improvement: when the barrister's "diff scope" line implies a scope larger than `gh pr view`'s `changedFiles`, the fixer should re-verify the PR's actual lane before fanning out fixes; otherwise the fixer either touches files outside the PR (creating cross-PR coupling) or wastes a dispatch on items that need a different PR.
