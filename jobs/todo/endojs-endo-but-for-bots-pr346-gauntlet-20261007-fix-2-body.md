---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
pr: https://github.com/endojs/endo-but-for-bots/pull/346
dispatch: automatic
---

# Restore PR template headings on endojs/endo-but-for-bots#346 (gauntlet fix-2 handoff)

The panel round-2 must-fix on https://github.com/endojs/endo-but-for-bots/pull/346 is to restore the six PR-template headings in the PR body. Host oros-studio-garden-ce242c49 cannot edit endojs PRs (403), so this job is pinned to an endolin host.

Task: replace the PR body with EXACTLY the text between the BODY markers below, using `jq -n --rawfile b FILE '{body:$b}' | gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/346 --input -` (or `gh pr edit 346 --repo endojs/endo-but-for-bots --body-file FILE`). Then verify with `gh pr view` that the body contains the headings Description, Security Considerations, Scaling Considerations, Documentation Considerations, Testing Considerations, Compatibility Considerations, Upgrade Considerations. Touch nothing else (no pushes, no reviews). Done when the body is updated.

----- BODY -----
Refs: endojs/endo#2981
Refs: endojs/endo#2980

## Description

`bundleSource` in the `nestedEvaluate` (and `getExport`) format generates a calling-convention object whose properties wire each module's local bindings to the bundle's per-export cell. When a single local binding is exported under multiple names (`export { details, details as X, details as redacted }`), the previous generator emitted one property per export name, all keyed by the same local binding. JavaScript object-literal semantics silently keep only the last duplicate-keyed property, so only one of the cells ever received its setter and the rest stayed `undefined`. Consumers that imported the aliased name (`import { X } from '@endo/errors'`) then resolved to `undefined`, producing the `TypeError: X is not a function` reported on the issue.

The generator (`importsCellSetter` in `packages/compartment-mapper/src/bundle-mjs.js`, the file most critical to review) now collects every export name per local binding and emits a single fan-out setter per binding that publishes the value into every corresponding cell. The compiled module program's calling convention is unchanged: it still calls `onceVar[localName](value)` once per binding initialization.

### Security Considerations

The change adds no new authority, dependency, or trust boundary; it only corrects which cells the generated bundle code writes, so every exported name now receives the value its source module actually exported instead of `undefined`.

### Scaling Considerations

Bundle size and run time change negligibly: a binding exported under N names gets one setter that performs N cell writes, replacing N duplicate-keyed properties of which only one survived.

### Documentation Considerations

No user-facing documentation changes are needed; the `@endo/compartment-mapper` changeset records the fix for release notes, since aliased exports simply work as the ECMAScript module semantics already promise.

### Testing Considerations

The companion `export-alias` regression test in `packages/bundle-source/test/export-alias.test.js` (added as `test.failing` in endojs/endo#2980) is un-`.failing`'d: with the fix removed it fails (`actual: undefined, expected: 42`), and with the fix applied it passes. The existing `marshal-failure` test and the full `bundle-source` and `compartment-mapper` test suites pass; a direct `compartment-mapper` unit test pinning the generated fan-out setter (live-binding alias, triple alias, `default` alias) would be a reasonable follow-up.

### Compatibility Considerations

The generated `nestedEvaluate`/`getExport` bundle text changes for any module that exports one local binding under more than one name: aliases that previously evaluated to `undefined` (a bug masked by the `test.failing` marker) now carry the real value, and modules without aliased exports produce output with the same behavior as before.

### Upgrade Considerations

Bundles already built and stored (for example, installed on chain) keep the old behavior until they are rebuilt with the fixed `@endo/compartment-mapper`; code that worked around the `undefined` alias by importing the unaliased name continues to work unchanged after a rebuild.
----- END BODY -----
