---
ts: 2026-05-14T10:25:29Z
kind: result
role: shepherd
worktree: dispatches/shepherd--699c9b/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 135
    role: source
refs:
  - entries/2026/05/14/094300Z-dispatch-steward-699c9b.md
  - entries/2026/05/14/094916Z-result-shepherd-b5661f.md
  - entries/2026/05/14/090812Z-result-fixer-0cbacb.md
---

# Shepherd: PR #135 CI green after second fix

Follow-up to the earlier `result` (`094916Z-result-shepherd-b5661f`). After the SECURITY.md fix (commit `bc5996045`) made the first short-circuit lint step pass, a second failure surfaced in the same `lint` job at the `build API docs` step. Diagnosed and fixed in one more push.

## Second failure: build API docs / tsc

`TypeDoc -> tsc` failed on `packages/daemon/test/capability-vfs.test.js:36:9`:

```
TS2741: Property 'removeDirectory' is missing in type '{ ... }'
        but required in type 'FilePowers'.
```

The `llm` base commit `5798b56f5` ("feat(daemon): garbage-collect content store and scratch-mount dirs") added `removeDirectory: (path: string) => Promise<void>` to the `FilePowers` type alongside the Node-host and XS-host implementations. The prior fixer round introduced `capability-vfs.test.js` with a local `FilePowers` fixture but predated that `removeDirectory` addition, so the fixture is missing the new required member. On the synthetic merge ref the new `types.d.ts` requires it; on the PR head in isolation the test fixture's type annotation `@type {FilePowers}` resolves to a version of the type that does not include `removeDirectory`, which is why local lint and `yarn docs` would not catch it.

## Fix

Added one line to the fixture, mirroring the existing `removePath` implementation (both are recursive-rm in the Node host):

```js
removeDirectory: p => fs.promises.rm(p, { recursive: true, force: true }),
```

Single file, single line; well within the shepherd's 5-file budget.

## Commit pushed

```
b0f02f656162e4f9d061b6a4df4394fe303acf5a
  fix(daemon-test): add removeDirectory to capability-vfs FilePowers fixture
```

Branch head pushed to `endojs/endo-but-for-bots` `feat/mount-core` as `b0f02f656` (previous head `bc5996045`).

## Final CI rollup

**SUCCESS=25** (full matrix green) on head `b0f02f656`. Verified via `gh pr view 135 -R endojs/endo-but-for-bots --json statusCheckRollup`. All 25 checks SUCCESS:

```
browser-tests, lint, lint (docs-only), build, test, familiar-bundle,
test (20.x, ubuntu-latest), test (20.x, macos-15),
test (22.x, ubuntu-latest), test (22.x, macos-15),
test (24.x, ubuntu-latest), test (24.x, macos-15),
sandbox-drivers, test-async-hooks (20, ubuntu-latest),
cover (20.x, ubuntu-latest), cover (24.x, ubuntu-latest),
test262 (20.x, ubuntu-latest), test262 (24.x, ubuntu-latest),
test-hermes (ubuntu-latest), check-action-pins,
viable-release (20.x, ubuntu-latest), viable-release (24.x, ubuntu-latest),
test-xs (20.x, 5.0.0, ubuntu-latest), test-ocapn-python, build-wasm
```

CI green. Judge re-dispatch is unblocked.

## Full commit chain

```
bc599604528a0dd823f567bbee35f0cc64e8a1eb
  ci(security-md): add SECURITY.md for harden-test and hex-test packages
b0f02f656162e4f9d061b6a4df4394fe303acf5a
  fix(daemon-test): add removeDirectory to capability-vfs FilePowers fixture
```

Two commits, three files (`packages/harden-test/SECURITY.md`, `packages/hex-test/SECURITY.md`, `packages/daemon/test/capability-vfs.test.js`), 77 lines inserted. Atomic per concern.

## Carry-overs for the orchestrator

Both surface defects are on the `llm` base branch, not on the PR:

1. `packages/harden-test/` and `packages/hex-test/` were added without `SECURITY.md` sidecars after the uniformity check (#228) landed. Every open PR against `llm` (e.g. #243) trips this red.
2. `capability-vfs.js` (introduced earlier on this PR) needs its test fixture re-synced when base-side `FilePowers` grows new members; the same pattern will repeat as additional members land.

Carry-over (1) was already noted in the previous result entry. Carry-over (2) is new: the base-side `FilePowers` evolves independently of PR-branch test fixtures, so any PR that ships a `FilePowers` fixture before merging is fragile to base-side type churn. The clean fix is to import `FilePowers` from `@endo/daemon/src/types.js` and use a real `@endo/daemon/src/daemon-node-powers.js`-style implementation (or a `Partial<FilePowers>` cast with an inline note), rather than re-declaring a stripped-down literal in the test. Not in this dispatch's scope; recording so a future fixer or stylist can consolidate.

Self-improvement: short-circuit lint chains (`yarn lint:prettier && yarn lint:eslint && Check SECURITY.md uniformity && build API docs`) mask successive failures. A shepherd should anticipate that fixing one step will unmask the next and plan for an iterative diagnose-fix-push cycle rather than declaring victory on the first green push. The `ci-status-summary` skill's *Pitfalls* section already names the "second failures unmasked by short-circuit chains" pattern from the shepherd role file; consider tightening the role's *Operating norms* section to explicitly note "expect 1-3 successive failures on the same job and budget context for the iterations."
