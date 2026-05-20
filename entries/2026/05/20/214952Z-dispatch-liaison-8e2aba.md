---
ts: 2026-05-20T21:49:52Z
kind: dispatch
role: builder
project: endo
to: builder
---

# Dispatch: builder 8e2aba — verify endojs/endo#59 (star-export cycle defect), propose fix

Dispatch root: `dispatches/builder--8e2aba/`. Project worktree on `kriscendobot/endo` with local ref `refs/heads/upstream-master` set to `endojs/endo@master` head `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f`.

Maintainer directive (2026-05-20T21:48Z): *"Please dispatch a builder to verify this defect and if necessary propose a fix [https://github.com/endojs/endo/issues/59](https://github.com/endojs/endo/issues/59)"*.

## The defect (2019-11, jfparadis, still OPEN, kriskowal-reviewed-2024-01 + kriskowal-just-do-it-2024-01)

**Symptom**: Modules can be visited more than once when resolving bindings through `export *` star re-exports, when the requested export name differs between visits. The cycle isn't detected; the link surfaces a spurious "does not provide an export named X" `SyntaxError`.

**Original reproducer** (against the deprecated `make-importer`):
- `index.js` — `import { x } from './mod1.js'; console.log(x);`
- `mod1.js` — `export * from './mod2.js';`
- `mod2.js` — `export { y as x } from './mod1.js'; export var y = 45;`

Expected: `45`. Actual (in 2019): `SyntaxError: ... does not provide an export named 'y'`.

The chain: index wants `x` from mod1 → mod1 re-exports all from mod2 → mod2's `x` is the `y` re-imported from mod1 → mod1's `y` is mod2's `y` (via `export *`) → mod2's `var y = 45`. The link should resolve `x = 45` but the resolver re-visits mod1 looking for `y` and doesn't realize it was already on the visit stack with a different export name.

## Task

Your job is *verify first, propose-fix second* — do not start with a fix.

### Step 1: locate the modern equivalent

`make-importer` was the precursor to today's static-module-record / instance machinery. The modern packages most likely to host this code path are:

- `@endo/module-source` — parses ES modules into static module records.
- `@endo/import-bundle` — instantiates linked module graphs at runtime.
- `@endo/compartment-mapper` — orchestrates compartment-based linking.
- `ses` — `Compartment.prototype.import` and the module-link/instantiate routines live here.

The actual link/resolve-binding loop is in one of these; survey their `src/` and find the place where `*` (`STAR`) exports propagate import requests through a re-exported module. Grep for `STAR`, `export *`, `getExport`, `resolveExport`, etc., to orient.

### Step 2: write a failing reproducer

Pick the package where the link logic lives (most likely `@endo/import-bundle` or whatever package exercises the instance/link path in tests today). Add a test file under that package's `test/` that constructs the three-module scenario above and asserts the resolved value is `45`. The test fixture can be inlined (in-memory modules via the package's existing test helpers) rather than on-disk.

If the test passes, the defect has been fixed somewhere between 2019 and now. **Stop there, report which package's test you added, the commit SHA, and "no defect — issue can be closed."** Don't propose a fix.

If the test fails (or the link throws the same `does not provide an export named X` error), the defect reproduces. Continue to step 3.

### Step 3: propose a fix

Identify the resolver function that walks `*` exports and add the cycle-detection that prevents revisiting a module while it's already on the current binding-resolution stack (the standard "exports cycle" check from ECMA-262's ResolveExport algorithm — see §16.2.1.6 ResolveExport, the `resolveSet` parameter). The cycle check should compare both the *module* and the *export name being requested*; revisiting a module with the same exportName means a circular binding (which Node spec-correctly resolves to `undefined` in some cases or throws in others).

Land the fix as a second commit so reviewers can read the diff against the failing test.

### Step 4: open a draft PR (or surface the compare URL if cross-fork PR-create is blocked)

Branch: `fix/issue-59-star-export-cycle`. Base your branch on `refs/heads/upstream-master` (= `endojs/endo@master`, head `ec3dcbc0`), already materialized in the worktree.

Commit shape (in order):
1. `test(<package>): reproduce #59 — star-export cycle yields spurious binding error` — failing test on its own.
2. (If you propose a fix) `fix(<package>): detect star-export cycle by (module, exportName) pair` — fix + the now-passing test.

Add a changeset for the package(s) you touch (`@endo/<pkg>: patch`).

Push to `kriscendobot/endo:fix/issue-59-star-export-cycle`. Attempt `gh pr create --repo endojs/endo --base master --head kriscendobot:fix/issue-59-star-export-cycle --draft --title <subj> --body <see below>`. **If the PR-create fails with the permission error documented in `journal/entries/2026/05/20/051910Z-result-liaison-90f5ea.md`** (kriscendobot does not have correct permissions to execute CreatePullRequest on endojs/endo), don't retry — surface the compare URL `https://github.com/endojs/endo/compare/master...kriscendobot:endo:fix/issue-59-star-export-cycle?expand=1` in your report so the liaison can request a maintainer ferry.

PR body should cite issue #59 explicitly, name the failing test in step 1, summarize the fix in step 2 (if any), and ask the maintainer to confirm the ECMA-262 ResolveExport semantics interpretation.

## Out of scope

- Don't touch any non-related test or src file.
- Don't change behavior on non-cycle code paths.
- Don't backport to older release lines.
- Don't merge or un-draft.

## Per-action authorization

- Standing on `kriscendobot/endo`: push to `fix/issue-59-star-export-cycle`. PR-create attempt against `endojs/endo` is permitted (will likely fail; surface the failure).
- READ-ONLY everywhere else. No comments.

## Report

≤ 350 words, structured:

1. **Verification result**: REPRODUCES or NOT REPRODUCES (with the package + test path + the exact assertion).
2. **Where the link path lives**: the file:function you found.
3. **Branch + head SHA pushed** (and PR URL if create succeeded, otherwise the compare-URL fallback).
4. **Fix shape** (one paragraph): what changed, where, and why. If you didn't propose a fix because the test passed, write "no fix needed".
5. **Local verification**: which `yarn test` / `yarn lint` invocation you ran and the exit status.
6. One-line `Self-improvement: ...`.
