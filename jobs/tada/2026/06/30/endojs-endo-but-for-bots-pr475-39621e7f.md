All work complete and verified. Here is my completion report.

---

## Completion report — attention directive on endojs/endo-but-for-bots PR #475

**Directive (from erights, [r3496732452](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3496732452)):** "please write a test for this," replying to his init-order question on [r3496724676](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3496724676): if `genuine-uint8-array.js` initializes *after* the `@endo/immutable-arraybuffer` shim, won't it capture a `Symbol.toStringTag` getter the shim installed that also admits emulated `Uint8Array`s?

**Investigation result:** The hazard does not materialize. The shim installs `freezableTypedArrayLibProperties` onto `%TypedArrayPrototype%`, but that record has **no `Symbol.toStringTag`** entry, so the genuine getter is never shadowed. Whatever the load order, the brand check captures the genuine getter, which returns `undefined` (not `'Uint8Array'`) for an emulated wrapper, so `assertGenuineUint8Array` rejects it.

**What I did:**
- Added `packages/bytes/test/genuine-uint8-array-shim.test.js` — a dedicated test that reproduces erights' exact ordering (`import` of the real shim written above the import of the module under test; under the lockdown/unsafe configs `ses/lockdown.js` also installs the shim before any test module loads). It builds a **real** shim-emulated frozen `Uint8Array` via `sliceToImmutable`, confirms it is a faithful counterfeit (`instanceof Uint8Array` true, `.buffer.immutable` true, yet `wrapper[0] === undefined`), asserts the captured getter returns `undefined` for it, and asserts the brand check throws on it while still accepting a genuine array. This is stronger than the existing hand-rolled `makeCounterfeitUint8Array` stand-in and stands as the regression guard if a future shim change ever shadows that getter.
- Added `@endo/immutable-arraybuffer` as a `devDependency` of `@endo/bytes` (one-line `yarn.lock` update committed separately per the yarn-lock norm).

**Verification:** 25 tests pass under all three SES configs (`lockdown`, `unsafe`, `endo`); `tsc` (`lint:types`) and `eslint` clean.

**Commits pushed to `feat/narrow-bytearray-to-uint8`** (head `1dbb32ebc`): `1b6df4a9b` (test + devDep), `1dbb32ebc` (`chore: Update yarn.lock`).

**Comments posted** (endo-but-for-bots standing authorization): inline thread reply [r3496787128](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3496787128) with the full reasoning, and top-level summary [issuecomment-4840751414](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4840751414).

**Follow-ups:** None required. The PR is still DRAFT (its overall state, unrelated to this directive). Project worktree cleaned up; inbox drained empty throughout.

**Self-improvement:** Extended the existing `env-sandbox-blocks-bin-shims-use-node-directly` memory with the ses-ava multi-config recipe (ses-ava spawns `ava` from PATH which is also sandbox-blocked; bypass it by running `node node_modules/ava/entrypoints/cli.js --config <each sesAvaConfig>` directly, plus the node-direct paths for `eslint`/`tsc`).
