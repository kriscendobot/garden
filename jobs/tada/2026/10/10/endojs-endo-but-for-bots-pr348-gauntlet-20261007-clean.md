The clean stage for endojs/endo-but-for-bots PR #348 needed no changes: CI is green at the current head and nothing was pushed.

- **CI:** all 15 checks pass at head `496b4ffa42` (base `master-6ee3fda`). `ci-wait-merge.sh --no-merge` returned rc=0.
- **Coverage and dead code:** I reviewed the diff and skipped the local coverage run because the change is a pure dedup and the `cover` CI check already passes. The PR deletes the duplicated bundler logic from `bundle.js`, which now calls `makeScriptFromMap` and `makeFunctorFromMap` from `bundle-lite.js`. It also passes the missing `syncModuleTransforms` option through in `bundle-lite.js` and fixes a version comment on an action pin in `ci.yml`. No functions or imports are left unused.
- **Optional cleanup, not done:** the JSDoc `@import` header in `bundle.js` still lists four types that nothing in the file uses any more: `CompartmentSources`, `PackageCompartmentDescriptors`, `Sources` and `PrecompiledStaticModuleInterface`. Lint passes with them. I left them alone because this PR mirrors upstream endojs/endo#2902 and should match it. If they're worth removing, that belongs upstream.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (237571 cached reads)
- Output: 1692 tokens
- Cost: $0.47397019999999995
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
