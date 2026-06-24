---
ts: 2026-05-14T20:58:26Z
kind: result
role: builder
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo
    pr: 1256
    role: source
  - repo: endojs/endo
    issue: 1206
    role: source
refs:
  - entries/2026/05/14/205440Z-dispatch-liaison-dd4563.md
---

# Result: bundle-source missing-entrypoint bug is fixed at master (Phase 2b)

## Finding

The bug described in endojs/endo#1206 (and proposed-fixed in endojs/endo#1256) **no longer reproduces** at `endojs/endo-but-for-bots@master` (`c2fc02eb8`). All four module formats throw a clear, descriptive error when `bundleSource` is invoked on a non-existent entrypoint.

## Probe

A throwaway AVA test (`packages/bundle-source/test/missing-entrypoint.test.js`, not committed) invoked `bundleSource('./does-not-exist.js', <format>)` for each of `endoZipBase64`, `endoScript`, `nestedEvaluate`, and `getExport`. All four rejected with:

```
Failed to load module "./does-not-exist.js" in package
"file:///.../packages/bundle-source/" (1 underlying failures:
Cannot find file for internal module "./does-not-exist.js"
(with candidates "./does-not-exist.js", "./does-not-exist.js.js",
"./does-not-exist.js.json", "./does-not-exist.js.node",
"./does-not-exist.js/index.js", "./does-not-exist.js/index.json",
"./does-not-exist.js/index.node") in package
file:///.../packages/bundle-source/
```

## Where the modern fix lives

The error originates from `@endo/compartment-mapper/src/import-hook.js` at lines 727-732:

```js
throw Error(
  `Cannot find file for internal module ${q(moduleSpecifier)} (with candidates ${candidates.map(x => q(x)).join(', ')}) in package ${packageLocation}`,
);
```

Mechanism: `bundleSource` no longer reads the entrypoint directly. The 2023 refactor `11940d916` (`refactor(bundle-source): Divide implementations for formats`) split the dispatcher into format-specific delegates that hand the entrypoint URL to `@endo/compartment-mapper`. Today's `src/zip-base64.js` calls `mapNodeModules(powers, entry.href, ...)`, and `src/script.js` calls `makeFunctor(powers, entry.href, ...)`. Both pass the entry into compartment-mapper's import-hook, which exhausts its candidate list and throws the message above when the file cannot be found. The 3-year-old proposed `assert(fs.existsSync(startFilename))` in #1256 is now redundant: the candidate-exhaustion check is strictly more thorough (it tries `.js`, `.json`, `.node`, and `index.*` resolutions before giving up) and is enforced at the architectural layer where it belongs.

## Recommendation

- **Close endojs/endo#1256** with a note: the missing-entrypoint case is handled at `packages/compartment-mapper/src/import-hook.js` (the "Cannot find file for internal module" branch). Since the 2023 `11940d916` refactor, `bundle-source` delegates entrypoint loading to `compartment-mapper`, and the candidate-resolution exhaustion fails closed. The bundle no longer silently succeeds on a missing file; the `assert(fs.existsSync(...))` check the PR proposed is unnecessary at the bundle-source layer.
- **Leave endojs/endo#1206 closed** (it is already closed). The probe confirms the closure is correct.
- **No fork-side PR opened.** Per dispatch Phase 2b.

## Bulletin

Add a row under *Awaits maintainer decision* in `journal/README.md` recommending closure of endojs/endo#1256 with a one-line cite of the modern fix location. The liaison lands the row from this result.

## Out of scope (preserved for the record)

- The original `endojs/endo#1256` head (`2b92db74`) still shows the placeholder test (`packages/bundle-source/test/test-missing-entrypoint.js` with the `'xxx'` regex). If a maintainer wants a permanent regression test alongside the closure note, that would be a separate small dispatch (a "lock in the fix" test under `packages/bundle-source/test/`). The expected error-message regex would be `/Cannot find file for internal module/`. Not opened here because the dispatch said Phase 2b is closure-recommendation only.
- No comment posted on `endojs/endo#1256` or `endojs/endo#1206` (READ-ONLY on `endojs/endo` per dispatch).

Self-improvement: nothing this time.
