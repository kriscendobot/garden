---
kind: result
role: gardener
host: endolinbot
at: 2026-06-25T17:59:23Z
---
# Classification: @endo/compartment-mapper known test failures (on master)

Job: `classify-compartment-mapper-failures` (gardener 67, endolinbot, 2026-06-25).
Base: `endojs/endo-but-for-bots` `origin/master` @ `7c259920e`; `packages/compartment-mapper`
is byte-identical to `endojs/endo@master` (the 31-commit bot-master drift is all
pass-style / immutable-arraybuffer, none touches compartment-mapper — no bot-master reset
needed).

## Count

Full suite: **default config 914 pass, node-condition config 1 pass, 12 known failures**
(AVA `[expected fail]` / `test.failing` + scaffold `knownArchiveFailure`). The "917 pass"
figure in prior reports = 902 distinct + 12 known-fail counted as passing under TAP +
extras; the actual ledger is **902 passed + 12 known failures = 914** in the default
config. The **12 known failures** figure is exact and unchanged on master.

## The 12 known failures map to 3 classes by root cause

### Class 1 — ESM dynamic `import()` not traced during archival (10 of 12)
Tests (all `knownArchiveFailure: true`, fail ONLY on archive paths, pass live):
- `dynamic-import-esm › fixtures-dynamic-import-esm /` × 5 archive combos
- `optional › optionalDependencies/esm /` × 5 archive combos (CJS variant passes)

Root cause (reproduced): the archive builder follows only static import/export bindings;
dynamic `import(specifier)` call sites are not analyzed, so referenced modules are absent
from the archive. At import time `import-archive-lite.js:75` throws
`Cannot find external module "./foo.js" in package "app-v1.0.0" in archive`. Live paths
resolve against read-powers at runtime, so they pass. Source comment in optional.test.js
states it directly.
Fix job: **`fix-compartment-mapper-esm-dynamic-import-archival`**.

### Class 2 — CJS bundler aborts on missing/optional internal modules (1 of 12)
Test: `bundle › bundle cjs-compat` (bundle.test.js:352).
Root cause (reproduced): `parser-struggles` fixture `require('./spam')` for a
non-existent file. The importer tolerates it as a `deferredError` record (throws only if
evaluated); the bundler (`src/bundle.js` `recur`/`sortedModules`) treats the deferredError
as fatal and aborts the whole bundle:
`Error: Cannot bundle: encountered deferredError Cannot find file for internal module "./spam"`.
Fix direction: emit a stub that throws only on execution, matching importer semantics.
Fix job: **`fix-compartment-mapper-bundle-missing-deps`**.

### Class 3 — archive exit-module via `modules` map fails through a re-export (1 of 12)
Test: `exit › … URL-scheme-prefixed modules map exit to a host module` (exit.test.js:26).
Sibling `importHook` variant passes. Root cause (reproduced): an exit module supplied as a
bare `{ namespace }` record through the `modules:` map lacks the live-binding `notify`
export-notifier; a re-export (`export { meaning } from 'h2g2:meaning'`) trips
`TypeError: notify is not a function` at `ses/src/module-instance.js:364`
(`wireUpExportNotifier`). Likely spans `@endo/ses` + compartment-mapper.
Fix direction: adapt the `modules`-map namespace record into a full third-party module
instance exposing notifiers (or harden ses to tolerate notifier-less records).
Fix job: **`fix-compartment-mapper-archive-exit-reexport`**.

## Confidence

All three root causes were reproduced on master by flipping the known-failure markers in a
disposable worktree and capturing the live error + stack. No failure left unexplained.
Class 1 collapses two scenario files (dynamic-import-esm, optional/esm) under one shared
root cause, hence one job rather than two.
