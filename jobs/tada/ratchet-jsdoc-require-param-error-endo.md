Completion report follows.

---

## Completion report: `ratchet-jsdoc-require-param-error-endo`

**Done.** Ratcheted `jsdoc/require-param` from warn to error on `endojs/endo-but-for-bots` master and fixed the four `.js` defects it surfaced. Opened as fixer PR **[#555](https://github.com/endojs/endo-but-for-bots/pull/555)** (base `master`), non-draft, mergeable, 16 CI checks running.

**What changed**
- `packages/eslint-plugin/lib/configs/style.js`: added `'jsdoc/require-param': 'error'` to the main `rules:` block. The `.ts` override stays `'off'` as specified.
- `packages/daemon` — four async generators that carried only `@returns` now declare the missing `@param` with a type **and** a one-line description (no bare stubs):
  - `src/directory.js:129` — `@param {string} locator` on `followLocatorNameChanges`
  - `src/directory.js:174` — `@param {...string} petNamePath` on `followNameChanges`
  - `src/pet-sitter.js:71` — `@param {string} id` on `currentAndSubsequentIds`
  - `src/pet-store.js:159` — `@param {string} id` on `currentAndSubsequentIds`

Types were taken from the real signatures in `packages/daemon/src/types.d.ts` (`followLocatorNameChanges(locator: string)`, `followNameChanges(...petNamePath: string[])`, `followIdNameChanges(id: string)`).

**Verification** (in an isolated worktree off `origin/master` @ `364d69ba1`, with `yarn install`)
- Pre-change `eslint .` reported exactly the 4 `require-param` errors named in the job and no others — classification confirmed, not assumed.
- Post-change `eslint .` at repo root exits **0**: 0 `require-param` warnings/errors. The daemon package's `lint:eslint` (`eslint .`) is clean.
- The one remaining `eslint .` warning (`jsdoc/check-tag-names` "remarks" in `compartment-mapper/src/types/policy-schema.ts`) is **pre-existing and unrelated** (present before any edit; different rule, different package).

Commits are split cleanly: `chore(eslint-plugin): ratchet…` and `fix(daemon): document missing @param…`. Worktree torn down; inbox was empty at the checkpoint.

**Follow-ups / notes for the sibling ratchet jobs**
- `eslint --fix` autofix on `.js` files inserts a bare `@param name` stub, which then trips `jsdoc/require-param-type` (a *new* warning) for scalar params. The fix is to fill each stub with both a type and a description, as done here — worth carrying into the other `lint-ratchet-endo-master` roadmap jobs so they don't land bare stubs that introduce a fresh warning class.
- CI gauntlet for #555 is in flight (lint-only change, low risk). If a CI check fails, it routes to the normal shepherd/fixer flow on the open PR.

Self-improvement: nothing this time (the autofix→require-param-type note above is a job-class tip already captured in this report for the remaining ratchet jobs, below the threshold for a skill edit).
