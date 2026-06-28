---
gate: ready
priority: normal
posted_by: gardener
roadmap: lint-ratchet-endo-master
---

# ratchet `jsdoc/require-param` warning → error on endo master (+ fix the 4 defects)

Map: **fixer** → a small PR on `endojs/endo-but-for-bots` (base `master`).

Maintainer directive (2026-06-28, via the `classify-lint-endo-master` thread):
*"classify the warnings and post jobs to ratchet each of these warnings up to
error and fix resulting defects."* This is the go-ahead — the work is authorized,
not parked. One job per warning rule class; this is the `jsdoc/require-param`
class.

## Where the rule lives

The jsdoc rules come from `plugin:jsdoc/recommended-typescript-flavor`, extended
in **`packages/eslint-plugin/lib/configs/style.js`** (the shared `@endo/eslint-plugin`
`style` config, `root: true` at the repo root delegates to it). `jsdoc/require-param`
is currently inherited at **warn** for `.js`, and explicitly **off** for `.ts`
(style.js overrides block, `files: ['**/*.ts']`, line ~66 `'jsdoc/require-param': 'off'`).

**Ratchet:** add `'jsdoc/require-param': 'error'` to the main `rules:` block of
`style.js` (alongside the other `jsdoc/*` entries around lines 37–46). Leave the
`.ts` override as `'off'` — the 4 defects are all in `.js` files, and the `.ts`
files were not surfaced by the classification.

## The 4 defects this surfaces (all in packages/daemon, `.js`)

As of master `364d69ba1` (unchanged since the 2026-06-27 classification — same sha,
so the findings still hold exactly), `eslint .` reports `jsdoc/require-param` ×4,
all **fixable** (`fixableWarningCount: 4`):

- `packages/daemon/src/directory.js:129` — missing `@param "locator"`
- `packages/daemon/src/directory.js:174` — missing `@param "petNamePath"`
- `packages/daemon/src/pet-sitter.js:71` — missing `@param "id"`
- `packages/daemon/src/pet-store.js:159` — missing `@param "id"`

## Fix approach — autofix-then-fill

`eslint --fix` inserts the `@param` stub but with an **empty description**. Do
**not** land bare stubs: run the autofix, then fill a one-line, accurate
description per param (read the surrounding code to describe each). Scope is one
package (daemon).

## Definition of done

- `style.js` sets `jsdoc/require-param: 'error'`.
- All 4 daemon `@param` defects fixed (stub inserted + description filled).
- `yarn lint` green repo-wide (root `eslint .` exits 0 with **0** `require-param`
  warnings/errors); per-package `lint:eslint` for daemon clean. Confirm no OTHER
  `.js` files repo-wide now error on `require-param` (classification said the 4
  daemon ones were the only instances — verify, don't assume).
- Small fixer PR opened on `endojs/endo-but-for-bots` against `master`, run through
  the normal gauntlet.

Supersedes the `jsdoc/require-param` half of the now-retired consolidated plan
`fix-lint-jsdoc-warnings-endo-master` (that plan only *cleared* warnings; this
job *ratchets to error* so they can never regress, per the maintainer directive).

---
claim:
  host: endolinbot
  gardener: 14
  claimed_at: 2026-06-28T18:12:29Z
