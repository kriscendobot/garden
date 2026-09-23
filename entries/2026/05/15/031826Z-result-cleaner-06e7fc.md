---
ts: 2026-05-15T03:18:26Z
kind: result
role: cleaner
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/cleaner--06e7fc/project
refs:
  - entries/2026/05/15/025151Z-result-builder-03b9cc.md
---

# Result: coverage pass on `packages/ses` for PR #259

## Branch / head

`feat/hardened-text-codecs-shim`, head `6e5b50d98` (was `fc2aa8d3c` from the builder; cleaner advanced it by one commit).

PR `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (only because CI is mixed; not `CONFLICTING`). Still in draft.

## Coverage gap analysis

The production change in `packages/ses/src/permits.js` is purely declarative: two entries in `universalPropertyNames` and four permit subtrees (`TextEncoder`, `%TextEncoderPrototype%`, `TextDecoder`, `%TextDecoderPrototype%`). "Coverage" here means: which named permit entries are observable as functioning after `lockdown()` exercises the permits tables against the host's actual codecs.

The builder's 12 tests in `text-codecs.test.js` already exercise:

- `TextEncoder` / `TextDecoder` presence on the start compartment
- universal identity across compartments
- `Object.isFrozen` on both constructors and prototypes
- `encoding` getter on both prototypes (start compartment and inside a compartment)
- `encode` and `decode` round-trip (start compartment and inside a compartment)
- `fatal` getter via `new TextDecoder('utf-8', { fatal: true }).fatal`
- `encodeInto` fn

Plus 2 tests in `text-codecs-missing.test.js` for the XS-style degradation path.

Un-exercised permit entries before the cleaner pass:

- `ignoreBOM` getter on `%TextDecoderPrototype%` (named in permits, never read by any test)
- `@@toStringTag` string on both prototypes (named in permits, never read by any test)
- `constructor` reverse-link on both prototypes (named in permits, never asserted as `TextEncoder.prototype.constructor === TextEncoder`)
- `[[Proto]]: '%FunctionPrototype%'` on both constructors (named in permits, never asserted as `Object.getPrototypeOf(TextEncoder) === Function.prototype`)

## Cleaner commit

`6e5b50d98 test(ses): cover ignoreBOM, @@toStringTag, constructor reverse-link, [[Proto]]`

Adds 4 tests to `packages/ses/test/text-codecs.test.js`:

1. `TextDecoder.prototype.ignoreBOM getter reflects the constructor option`: asserts the getter returns the configured value (`true` vs default `false`) and exercises the observable BOM-handling behavior the getter selects (default strips U+FEFF, `ignoreBOM: true` preserves it). Two-purpose: covers the `ignoreBOM` permit entry **and** the `decode` fn permit with a byte-input that contains the BOM.
2. `@@toStringTag is preserved on TextEncoder and TextDecoder prototypes`: asserts `instance[Symbol.toStringTag]` returns the standard tag and `Object.prototype.toString.call(instance)` returns `'[object TextEncoder]'` / `'[object TextDecoder]'`.
3. `constructor reverse-link is preserved on both prototypes`: asserts `TextEncoder.prototype.constructor === TextEncoder` and the same for TextDecoder.
4. `TextEncoder and TextDecoder inherit from Function.prototype`: asserts `Object.getPrototypeOf(TextEncoder) === Function.prototype` and the same for TextDecoder.

## Regression evidence (per skills/regression-evidence)

Verified each new test fails when its target permit entry is removed:

| Test | Mutation applied to permits.js | Result with mutation |
| --- | --- | --- |
| ignoreBOM | remove `ignoreBOM: getter,` from `%TextDecoderPrototype%` | test fails: `Value is not true: false` |
| @@toStringTag | remove `'@@toStringTag': 'string',` from both prototypes | test fails: getter returns `undefined` |
| constructor reverse-link | remove `constructor: 'TextEncoder'` / `'TextDecoder'` entries | test fails: reverse-link falls through to `Object` |
| [[Proto]] inheritance | change `'[[Proto]]'` from `'%FunctionPrototype%'` to `'%ObjectPrototype%'` | lockdown fails entirely, test file cannot import |

Each mutation was applied, the suite re-run, and the permits.js restored, leaving a clean tree before commit.

## Test count

16 tests in `text-codecs.test.js` (12 from builder + 4 from cleaner) plus 2 in `text-codecs-missing.test.js`. Full ses suite: **519 tests passed**, 2 known failures (pre-existing, unrelated), 2 skipped.

## Pre-PR checklist

- `npx corepack yarn ava` in `packages/ses`: green (519 passed).
- `npx corepack yarn lint` in `packages/ses`: clean except the two pre-existing TS2300 errors in `types.d.ts` and `dist/types.d.cts` (`Duplicate identifier 'Compartment'`); confirmed pre-existing per builder's report.
- `npx corepack yarn format` at the monorepo root: no files modified.
- No `yarn.lock` change (no new deps).
- No dead-code deletion: the PR is purely additive (data entries in a declarative permits table); there is no production code that the cleaner could legitimately delete.

## CI status on cleaner's HEAD (`6e5b50d98`)

All CI jobs finished. **One real failure that the cleaner cannot resolve:**

- **`browser-tests` (Chromium): FAIL**, same as on the builder's head `fc2aa8d3c`. The Playwright canary fails with:

  > `TypeError: Cannot delete property 'arguments' of function TextEncoder() { [native code] }`
  >
  > at `bundled-ses lockdown runs to completion` (browser-test/tests/canary.spec.js)

  This is a real production bug in the PR's permits change, not a cleaner-side regression and not a pre-existing infra red. It reproduces on the prior builder commit `fc2aa8d3c` (confirmed via `gh run list --workflow "Browser Tests"`).

  Root cause sketch: `cauterizeProperty` in `packages/ses/src/cauterize-property.js` does `delete obj[prop]` for any own property of an intrinsic that lacks a permit entry. Chromium V8's native `TextEncoder` / `TextDecoder` constructors carry an `arguments` (and likely `caller`) own property on the function object that Chromium refuses to delete (strict-mode native function), so lockdown throws.

  The fix is **not coverage-shaped**; it belongs to a fixer. Options the fixer can consider:
  - Add `arguments: false` and `caller: false` (the "expected-absent" marker pattern already used elsewhere in `permits.js`) to the `TextEncoder` and `TextDecoder` permit subtrees so `cauterizeProperty` does not emit a warning and does the `delete` silently. (But this only suppresses the warn; the `delete` still throws.)
  - Extend `cauterizeProperty`'s tolerate-undeletable escape hatch to cover the `arguments` / `caller` case on native function objects, mirroring the existing `prototype` escape hatch.
  - Investigate why the test passes on Node (where `TextEncoder` is also a native function) but fails on Chromium: the difference is likely that Node's TextEncoder is implemented as a JS class (no own `arguments`), while Chromium's is a `function` style native that exposes `arguments`. The right fix is probably to detect "native function with un-deletable arguments" and skip it.

- All other CI jobs **pass** on the cleaner's HEAD: `lint`, `build`, all `test (*)` matrices (Node 18/20/22/24 on ubuntu and macos), `test-xs`, `test262 (18/20/24)`, `test-hermes`, `test-async-hooks (18/20)`, `cover (18.x/20.x/24.x)`, `check-action-pins`, `viable-release (*)`, `test-ocapn-python`, `browser-tests` is the only red.

## Pre-existing infra red

None. The browser-test failure is not infra; it is a real bug in the PR's production change.

## Out of scope

- The browser-tests failure: the cleaner does not fix production bugs. Surfacing for a fixer dispatch before the judge.
- The Phase 3 audit of downstream `Buffer.from` / `.toString('utf...')` callers in the design is informational and out of scope per the builder's prior report.

## Self-improvement

Nothing this time. The coverage-driven-testing skill's procedure handled the gap analysis cleanly (the four un-exercised permit entries fell out of a `grep` for each entry's name across the test file). The skill's existing guidance on the "permits-as-data is structurally a declarative table" idiom was sufficient; no new lesson worth indexing.
