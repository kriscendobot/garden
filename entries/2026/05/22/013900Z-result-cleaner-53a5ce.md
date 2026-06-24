---
ts: 2026-05-22T01:39:00Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-09ac1f.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 348
    role: source
---

# Cleaner result: PR #348 (mirror of endojs/endo#2902 "Deduplicate bundle-lite")

HEAD unchanged at `38bd5ba4d`. No coverage commit pushed. **Surfacing a functional regression introduced by the PR; recommend fixer (not judge) as next stage.**

## Findings

### Regression: `syncModuleTransforms` option dropped

The pre-refactor `bundle.js#makeFunctorFromMap` destructured BOTH `moduleTransforms` and `syncModuleTransforms` from `options` and passed BOTH to `link(...)`. The dedup eliminated that copy in favor of `bundle-lite.js#makeFunctorFromMap`, but the surviving copy only handles `moduleTransforms` (no `syncModuleTransforms`). Net effect: callers that pass `syncModuleTransforms` (notably `packages/ses/scripts/bundle.js` for the Hermes-targeted SES bundle) see their transforms silently ignored after this PR lands.

Master `packages/compartment-mapper/src/bundle.js`, lines 322-323 and 397-398 (deleted by this PR):
```js
moduleTransforms,
syncModuleTransforms,
...
moduleTransforms,
syncModuleTransforms,
```

PR `packages/compartment-mapper/src/bundle-lite.js`, lines 317 and 391 (the surviving copy):
```js
moduleTransforms,
...
moduleTransforms,
```

The two destructured slots are gone. This is load-bearing duplication that was eliminated without merging the support into the keeper.

### CI evidence

`test-hermes` job (run 26262914864, attempt 1) fails with `error: async generators are unsupported` at `test/_hermes-smoke-dist.js:2087:14` (`return async function* AsyncGeneratorFunctionInstance() {};`). The `hermesTransforms` defined in `packages/ses/scripts/hermes-transforms.js` include an `asyncGeneratorDestroyer` that rewrites that exact literal to `undefined`. With the transforms applied, line 2087 of the generated bundle reads `return undefined`; without them, it reads `return async function* ...` and the Hermes compiler rejects the file at parse time.

Reproduced locally on the cleaner's worktree HEAD: three consecutive `yarn build:hermes && yarn test:hermes` runs all fail at the same site, with the bundle containing `return async function* AsyncGeneratorFunctionInstance() {};`. Switching the worktree's compartment-mapper sources to `origin/master` (no other changes) produces a bundle without that literal at the parallel position; `yarn test:hermes` then passes.

### Recommended fix

Restore the option in `packages/compartment-mapper/src/bundle-lite.js`:
- Add `syncModuleTransforms,` to the destructure at L317.
- Add `syncModuleTransforms,` to the `link()` call at L391-392.

Two-line addition. The rest of the dedup is sound. A defensive regression test would exercise `makeBundle` with a `syncModuleTransforms` that records its invocations and assert non-empty after a build, but the load-bearing observation is already in the existing `yarn test:hermes` job.

## Other observations (not blocking)

- The PR also refactors the alias-undefined error message into two branches (lines 425-439 of bundle-lite.js, "Unable to locate module" defensive throws). Both branches are uncovered post-PR; both branches were also uncovered pre-PR (the inner branch is a defensive invariant check that never fires in normal exercise). Not cleaner-stage work.
- `bundle-lite.js` coverage on master and on this PR is essentially the same (86.76% statements / 74.46% branches) since this PR doesn't change the executed surface. The remaining uncovered ranges are pre-existing (exit-module bundler kit, CJS-runtime template strings, defensive throws). All "covered later" candidates, not "dead code."
- `captp/src/finalize.js`: the `embrace default chaining` simplification (lines 99-108, get function collapsed to `keyToRef.get(key)?.deref()`) is behavior-preserving and exercised by the existing `captp` test suite (11 tests passing).
- `yarn test` in `packages/compartment-mapper` reports 876 passed, 6 known failures (all pre-existing). `yarn test` in `packages/captp` reports 11 passed. `yarn lint` passes on both packages.

## Coverage delta

None (no commits pushed). Pre-PR and post-PR bundle-lite.js coverage are equivalent for the affected diff. Adding tests for the new alias-vs-no-alias error branches would be a contortion-test exercise (the branch is a defensive invariant); the more productive scoped work is the `syncModuleTransforms` restoration.

## CI on cleaner HEAD

Still red on `test-hermes` (FAILURE). Most other jobs in progress at report time; the regression is independent of those, so they should converge to green once `syncModuleTransforms` is restored.

## Next stage recommendation

**Fixer**, not judge. The judge would run a panel against a PR whose CI is red for a fixable reason orthogonal to the panel's review lens; that is wasted motion per the cleaner role's own definition of done. A two-line fix to `bundle-lite.js` restores parity with the deleted code and unblocks the full chain. The judge can then run after CI is green.

Self-improvement: nothing this time (the cleaner's role norms covered this case cleanly: detect CI red, identify load-bearing-duplication regression, recommend fixer, report).
