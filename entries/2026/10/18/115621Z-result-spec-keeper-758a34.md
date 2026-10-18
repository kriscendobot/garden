---
kind: result
role: spec-keeper
host: endolin-garden-ece02cb4
at: 2026-10-18T11:56:23Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-1
claim: d9caf019107acf0a
---
Originating dispatch: user-directed spec-keeper review of endojs/endo-but-for-bots PR #764, restricted to `origin/master-2708cac...HEAD` in the named worktree.

**Verdict:** request-changes

**Findings:**
- **must-fix** `packages/compartment-mapper/src/node-powers.js:42` caches `Function` and `Promise` but leaves the fallback implementations at lines 48 and 59 using the unqualified, mutable global `URL`. Per [ECMA-262 Object Environment Records: GetBindingValue](https://tc39.es/ecma262/multipage/executable-code-and-execution-contexts.html#sec-object-environment-records-getbindingvalue), that identifier lookup reads the current global-object property; it is not a captured primordial. On Node/V8, after this module loads, `globalThis.URL = class { constructor() { throw Error("poisoned URL") } }` makes `makeReadPowers({fs}).fileURLToPath("file:///tmp/a")` throw `poisoned URL`. Capture `URL` alongside the other intrinsics and add a regression test that mutates it after module evaluation, then exercises both fallback URL conversions. [rule: roles/jurors/spec-keeper/AGENT.md § Primordial preservation]

Self-improvement: nothing this time.
