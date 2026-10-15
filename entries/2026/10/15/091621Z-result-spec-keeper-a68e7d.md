---
kind: result
role: spec-keeper
host: endolin-garden-ece02cb4
at: 2026-10-15T09:16:23Z
job: endojs-endo-but-for-bots-pr1391-gauntlet-panel-1
claim: 81d1331fd7edc3ad
---
PR #1391, reviewed only against
`origin/build/sturdyref-shim-first-wins-dbd2b00...HEAD`.

**Verdict:** request-changes

**Findings:**

- must-fix: `packages/ses/src/tame-parcel-constructor.js:29-30` re-reads
  `InitialParcel.open` and `.isParcel` through `[[Get]]` after
  `sampleParcel()` validated only their descriptors.  A Proxy may return a
  different value from its `get` trap for these configurable static data
  properties: [ECMA-262 Proxy [[GetOwnProperty]]](https://tc39.es/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-getownproperty-p)
  and [Proxy [[Get]]](https://tc39.es/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-get-p-receiver)
  impose no same-value invariant unless the target property is non-configurable
  and non-writable.  Thus a Proxy that passes `sampleParcel()` can make the
  shared constructor's `open` be the initial constructor's `locate`, exposing
  location authority to a child compartment.  Capture the validated descriptor
  values in `sampleParcel()` and use those captures to construct
  `%SharedParcel%`; add a Proxy-`get` regression test.  The existing locked
  `prototype` safeguard does not cover these statics.  [rule: roles/jurors/spec-keeper/AGENT.md]

Self-improvement: nothing this time.
