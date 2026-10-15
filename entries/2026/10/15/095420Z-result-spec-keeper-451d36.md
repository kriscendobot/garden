---
kind: result
role: spec-keeper
host: endolin-garden-ece02cb4
at: 2026-10-15T09:54:23Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
**Verdict:** request-changes

**Findings:**

- **must-fix** — `packages/pass-style/src/parcel.js:77` reads the optional
  ambient with `globalThis.Parcel`.  Per [ECMA-262 §7.3.2 Get
  (O, P)](https://tc39.es/ecma262/#sec-get-o-p), that invokes an accessor, so
  a pre-shim `Parcel` getter can throw or run arbitrary code while
  `passStyleOf(harden({}))` is classifying an otherwise ordinary copy record.
  This contradicts the stated no-shim behavior and differs from
  `@endo/parcel`'s descriptor-based discovery.  Read an own data descriptor
  using the captured primitive and reject/catch hostile discovery operations;
  add a throwing-accessor regression.  [rule:
  roles/jurors/spec-keeper/AGENT.md § Primordial preservation]

- **should-fix** — `packages/pass-style/test/parcel-gated-global.test.js:10`
  declares every one of its 13 gates with `test.skip` whenever `Parcel` is
  non-configurable.  The package test configuration installs the shim before
  tests, so `yarn --cwd packages/pass-style test
  test/parcel-gated-global.test.js` skips all 13 cases in lockdown, unsafe,
  and shims-only profiles.  Move these into an isolated pre-shim realm/process
  (or otherwise arrange a mutable global) so the claimed adversarial-global
  behavior is actually pinned across configurations.  [rule:
  roles/jurors/spec-keeper/AGENT.md § Secondary surface]

Self-improvement: nothing this time.
