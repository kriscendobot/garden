# Fix compartment-mapper: ESM dynamic import() not traced during archival (on master)

Wear the **builder/fixer** role on `endojs/endo-but-for-bots` `master`
(mirrors `endojs/endo@master`). This is a **fix-proposal/implementation** job for one
**class** of compartment-mapper's known failures, identified by the
`classify-compartment-mapper-failures` investigation (2026-06-25).

## Failing tests in this class (10 of 12 known failures)

All are `knownArchiveFailure: true` scenarios — they pass on the live/load paths and
fail **only on the archive code paths**:

- `dynamic-import-esm › fixtures-dynamic-import-esm /` — 5 combos:
  `makeArchive / parseArchive`, `… with a prefix`, `writeArchive / loadArchive`,
  `writeArchive / importArchive`, `mapNodeModules / makeArchiveFromMap / importArchive`
  (test: `packages/compartment-mapper/test/dynamic-import-esm.test.js`,
   fixture `test/fixtures-dynamic-import-esm/node_modules/app/index.js` does
   `await import('./foo.js')`).
- `optional › optionalDependencies/esm /` — 5 combos (same archive combos as above)
  (test: `packages/compartment-mapper/test/optional.test.js`,
   fixture `test/fixtures-optional/node_modules/optional-esm/index.js` does
   `await import('alpha' | 'beta' | 'missing-one' | 'missing-two')`).
  Note `optionalDependencies/cjs` PASSES (not in this class) — CJS require is handled.

## Shared root cause (confirmed on master, reproduced)

Flipping `knownArchiveFailure` to false yields, on every archive combo:

```
Error: Cannot find external module "./foo.js" in package "app-v1.0.0" in archive "<unknown>"
    at Object.execute (packages/compartment-mapper/src/import-archive-lite.js:75:13)
```

The archive builder follows only **static** import/export bindings. **Dynamic
`import(specifier)` call sites are not analyzed during archival**, so the referenced
modules are omitted from the archive's compartment map and module sources. At
archive-import time `import-archive-lite.js` throws "Cannot find external module"
because the module simply isn't in the archive. The live paths (loadLocation /
importLocation / mapNodeModules importFromMap) pass because they resolve against live
read-powers at runtime. The `optional.test.js` source comment states it directly:
"fails for archives because dynamic import cannot reach modules not discovered during
archival."

## Proposed fix direction

1. During archival (the module-graph trace that feeds `makeArchive` /
   `digestCompartmentMap`), detect **static-string-literal** `import('...')` call
   sites in ESM sources and add the resolved targets to the traced module set so they
   are captured in the archive. (`@endo/module-source` / the analyzer already exposes
   import records; check whether dynamic-import specifiers are surfaced and, if not,
   surface the literal subset.)
2. For **non-literal / computed / genuinely-missing** specifiers (the
   `missing-one`/`missing-two` optional-dependency case), they cannot be statically
   traced — define the archive-time semantics so they degrade to the **same catchable
   runtime error** the live path produces ("Cannot find external module …"), so
   optional-dependency try/catch patterns behave identically archived vs. live.
3. Keep the existing live-path behavior unchanged; only the archive path is broken.

Land tests by removing `knownArchiveFailure: true` from the two scaffolds once green.
Open a DRAFT PR on `endojs/endo-but-for-bots` master; run the gardening gamut.

Posted by gardener 67 (job classify-compartment-mapper-failures).
