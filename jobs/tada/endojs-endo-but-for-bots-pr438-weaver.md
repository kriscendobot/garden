The committed tree is clean and typechecks with 0 errors. The weaver rebase is complete.

---

## Completion report: weaver on endojs/endo-but-for-bots PR #438 (tsgo migration)

**Core deliverable done: the head branch is rebased onto current master and both frozen-base refs moved together.**

### Rebase mechanics (frozen-base discipline)
- New frozen base `master-eecc683` created at live master tip (`eecc68394`, was 115 commits ahead of the stale `master-4a04d07` snapshot).
- Replayed only the 25 tsgo commits with `git rebase --onto origin/master origin/master-4a04d07` (the old frozen base carried 4 immutable-arraybuffer commits already squash-merged into master under different SHAs; a plain `git rebase origin/master` re-introduced them as add/add conflicts, so `--onto` skips them).
- Head force-pushed with `--force-with-lease` (lease honored: `f75240084 → 3e6610037`).
- PR base updated to `master-eecc683`. Old `master-4a04d07` left for the conductor to sweep on close. PR stays DRAFT.

### Conflicts resolved (both sides honored, no `--ours`/`--theirs`)
- **pass-style `passStyle-helpers.js` `isPrimitive`** (runtime): kept master's `document.all`-aware body (#69) inside the PR's function-declaration form (type-predicate attachment).
- **compartment-mapper `compartment-map.js`**: kept master's `@returns {asserts ...}` annotation on the PR's function-declaration form.
- **module-source `package.json`**: took master's exports map (`src/shim.types.d.ts` + the new `./analyzer.js` export) and dropped the PR's superseded top-level `shim.d.ts` (master relocated shim typing; keeping both would duplicate the ambient `var ModuleSource`).
- **evasive-transform `index.js`**: kept only the used `GenerateAstOptionsWithSourceMap` import (master had removed `SourceMapOption`).
- **Two `_xorshift.js` modify/deletes** (ocapn, hex): honored master's deletion (relocated to the new `random` package, unreferenced).
- Small additive `package.json`/root-script/yarn.lock conflicts unioned; **yarn.lock regenerated** with `yarn install` (the tsgo commits add `@typescript/native-preview` to more workspaces than the pre-rebase lock recorded).

### Extra work beyond a mechanical rebase — post-frozen-base tsgo debt (2 new commits)
Flipping `lint:types` to tsgo surfaced errors in code master merged *after* the frozen base while `lint:types` was still `tsc` (immutable-arraybuffer #468 freezable-TypedArray, module-source analyzer refactor, pass-style). I applied the same tsgo-annotation fixes the PR already uses: `@typedef {any} TypedArray` (faithful to master's effective `any`), dropped `@this` from 4 accessors (TS2784), cast `createSourceOptions`'s literal (TS2741 from tsgo not honoring `@overload`), cast the synthetic `NodePath.get` call (TS2769/TS2322), and replaced a pass-style `@ts-expect-error` with a cast (TS2578). This is what completes the rebase to green rather than leaving CI red on master's drift.

### Verification (ran, observed)
- Whole-repo `typecheck-all` (tsgo 7.0.0-dev.20260612.1): **0 errors** on the committed tree.
- eslint: clean on immutable-arraybuffer, module-source, pass-style, compartment-mapper, evasive-transform (one pre-existing JSDoc-tag *warning* in an untouched file).
- prettier `--check`: clean on all edited files.
- `yarn install --immutable`: passes (lock CI-consistent).
- **Not run locally:** the ava/ses-ava test suites — the sandbox blocks those bin shims. All my changes are type-annotation/JSDoc-only except the `isPrimitive` merge, which is master's runtime body verbatim; CI will exercise the suite.

### Surfaced for the panel / erights (weaver→design note)
There is a genuine stylistic tension: master's #474 ("retire function-keyword in favor of arrow/method syntax per erights review") converted these predicate/assert helpers to **arrows**, while this PR converts them back to **function declarations** so `val is X` / `asserts x is Y` predicates attach under tsgo. I kept the function declarations (no eslint rule enforces arrows, and tsgo requires them for predicate attachment). The panel/erights may prefer the arrow+double-cast approach (as the E.js fixer used) to honor #474 — a design call, not a mechanical one.

### Next step
CI is now running on the rebased head. The base-drift red (`test-hermes`, `test-xs` runtime failures) should clear since the head now sits on current green master. If CI goes red the leader's `garden-ci-watcher` auto-posts a shepherd; if green, the PR is ready to un-draft (the DRAFT existed only to surface the now-resolved tsc/tsgo directive divergence). No PR comment posted (no comment authorization carried).

Self-improvement: nothing this time.
