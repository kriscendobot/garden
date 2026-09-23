Job complete. Draft PR #602 is open against `master-80e9b3e`, everything committed/pushed, tree clean.

---

## Completion report

**Task:** Implement a Proxy-based alternative emulation of the freezable TypedArray for `@endo/immutable-arraybuffer`, empirically address the design's three objections, and add property-assignment parity tests running on both Node and XS.

**Result:** DRAFT PR **[#602](https://github.com/endojs/endo-but-for-bots/pull/602)** (base `master-80e9b3e`), plus the one authorized link-back reply on PR #472 comment r3517387215.

### What I built
- **`@endo/immutable-arraybuffer/proxy-lib.js`** (new library entry; installs nothing on the primordials, presented as an *alternative for comparison* — the shipped plain-object wrapper is untouched):
  - `makeIndexRejectingProxy` — natural proxy (target = the genuine TypedArray); `set` trap rejects integer-indexed keys, forwards everything else.
  - `makeFreezableIndexRejectingProxy` — repaired proxy (target = a freeze-able plain object; genuine TA in a closure).
  - `makeProxyPseudoTypedArrayConstructor` — drop-in constructor analog.

### The three objections, empirically (all tests load-bearing — verified failing when the target path is broken)
1. **Freezability:** the natural proxy is **not freezable** — `Object.freeze`/`harden` throw `TypeError: Cannot redefine property: 0` (an integer-indexed exotic won't make index `"0"` non-configurable). Recoverable by targeting a plain object, but reflection (`ownKeys`/`getOwnPropertyDescriptor`) then diverges. Evidence: `test/proxy-freezability.test.js` + two `ses (proxy variant)` cases in `packages/ses/test/immutable-arraybuffer.test.js`.
2. **Hot-path overhead:** `test/proxy-benchmark.test.js` — indexed reads ~10–60× a genuine TypedArray, indexed writes ~200×.
3. **The gain:** `test/proxy-gain.test.js` — throwing write vs wrapper-local own property; buffer immutability already holds either way.

### Parity tests (Node **and** XS), via `@endo/test262-runner`
- 5 test262-format files under `test262/test/staging/immutable-arraybuffer/` pinning down the integer-indexed / property-assignment surface (throw / silent-swallow / own-property / write-through, frozen and non-frozen) for genuine vs plain-object-emulated vs Proxy-emulated views, plus a shim-installing prelude.
- **Both platforms green, 8/8, verified in this environment:** Node via `test262-harness`; XS via a small direct-`xst` runner (`scripts/run-iab-xs.js`), because eshost's XS agent doesn't compose with a shim-installing prelude (the existing `ses-xs-parity` suite only ever used an empty one) — the direct-`xst` approach is the same idiom `@endo/ses`'s own `test:xs` uses.

### Incidental correction
Surfaced (and fixed in the design + README) that a fresh plain-object emulated `view[0]` returns **`undefined`**, not the buffer byte — a plain object has no integer-indexed slot; only `view.at(0)` reads through. The Proxy variant closes this read gap; the docs' worked example previously claimed otherwise.

### Follow-ups / notes
- A peer gardener (`ebfb-…-builder`) had claimed a duplicate of this job, stood down, and pointed me to `xst` at `/home/kris/bin/xst`; my acknowledgment dead-lettered (they'd already completed).
- Whether to wire `test262:iab` into the repo's CI matrix is a maintainer call; the scripts are in place and green locally.
- The single `src/lib.js` hunk is a base-hygiene tsc-annotation fix already present on the PR branch (the frozen `master-80e9b3e` base had a pre-existing type error).

Verification: `@endo/immutable-arraybuffer` full suite (230 ava tests), `tsc`, and `eslint` all clean; `packages/ses/test/immutable-arraybuffer.test.js` 6/6; parity suite 8/8 on both Node and XS.
