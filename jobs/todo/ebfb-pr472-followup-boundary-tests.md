# build: exhaustive deterministic byteOffset+length constructor boundary tests for @endo/immutable-arraybuffer (follow-up to PR #472)

Repo: **endojs/endo-but-for-bots** (bot direct push; bot identity). This is a
**build** job: author a new test file and open a **follow-up PR**. Run the full
builder gamut (build → cleaner → judge panel → fixer-loop → un-draft) per the
PR-creation flow. The deliverable is a mergeable, test-only follow-up PR.

## Provenance / authorization

This lands the one item parked in **PR #472** (*chore: document bytesToImmutable
freezable-TypedArray usage*, https://github.com/endojs/endo-but-for-bots/pull/472),
whose body deferred: *"fast-check-style boundary tests for `byteOffset`+`length`
constructor arguments across all eleven flavors ... deferred pending confirmation
that fast-check is available as a dev dependency."*

**Maintainer directive (erights, full maintainer authority, 2026-07-01T16:51Z,
comment 4857935559 on #472):**
> No need to wait. Please proceed with the deterministic testing. If we get advice
> to the contrary from @gibson042, we'll deal with it then.

erights's rationale (comment 4835... / 02:35Z on #472), agreed by the bot: for a
space this small, **exhaustive deterministic enumeration** gives complete coverage
that probabilistic fast-check only approximates — so land the tests as exhaustive
cases and **do NOT add fast-check** (no new dev dependency; devDeps stay ava/c8/
eslint/tsd/typescript). Treat "deterministic testing" as the explicit go-ahead.

## Base branch

Target **current `origin/master`** (the shim TypedArray feature and its existing
tests — `test/shim-typedarray.test.js`, `test/shim-typedarray-per-flavor.test.js`
— are already on master). This is an independent test-only follow-up, NOT part of
the frozen-base `master-80e9b3e` #468/#472 chain, so it needs no frozen base.
Confirm the feature is present on your chosen base before writing (it is on master).

## Scope — what to build

Add a new deterministic test file (suggested:
`packages/immutable-arraybuffer/test/shim-typedarray-ctor-bounds.test.js`,
`// @ts-nocheck`, `import '../src/shim.js'` + `import test from 'ava'`) that
**exhaustively** enumerates the `byteOffset` and `length` constructor arguments
of `new Ctor(iab, byteOffset, length)` — where `iab` is an emulated immutable
ArrayBuffer from `new ArrayBuffer(N).sliceToImmutable()` (or `ab.sliceToImmutable()`)
— across **all eleven** concrete TypedArray flavors (Int8/16/32, Uint8,
Uint8Clamped, Uint16/32, Float32/64, BigInt64, BigUint64). Reuse the existing
eleven-flavor `flavors` table shape from `shim-typedarray-per-flavor.test.js`
(each flavor carries its `BYTES_PER_ELEMENT`).

The constructor forwards `[genuineAB, ...restArgs]` to the genuine constructor
via `Reflect.construct` (`src/lib.js` `makePseudoTypedArrayConstructor`), so the
emulated wrapper inherits the native constructor's boundary/error semantics.
Enumerate, per flavor, at least these boundary classes over a buffer whose
byteLength is a small common multiple of all element sizes (e.g. 16 or 24):

Valid constructions (assert byteOffset/byteLength/length read back correctly,
prototype is `Ctor.prototype`, `view.buffer === iab`, `.buffer.immutable`):
- `byteOffset` omitted and `length` omitted (full view over the buffer);
- `byteOffset = 0`, explicit `length = 0` (empty view at the start);
- `byteOffset = 0`, explicit `length =` the max that fits;
- an aligned mid-buffer `byteOffset` (a nonzero multiple of BYTES_PER_ELEMENT)
  with `length` omitted (infers to end) and with an explicit fitting `length`;
- `byteOffset = byteLength` with `length = 0` (empty view exactly at the end).

Error constructions (assert `t.throws(..., { instanceOf: RangeError })`, and
for misalignment only on flavors with BYTES_PER_ELEMENT > 1):
- `byteOffset` not a multiple of BYTES_PER_ELEMENT (misaligned);
- `byteOffset` past the end (`byteLength + BYTES_PER_ELEMENT`);
- `byteOffset` valid but `byteOffset + length*BYTES_PER_ELEMENT > byteLength`
  (length one element past the max that fits).

Match the house style of the existing per-flavor file (parameterized `for`
loop over the flavors table, `tName` labels, `Ctor.prototype.*.call` where a
method must bypass the plain-wrapper). Keep every case a concrete, named
deterministic assertion — no random/property-based sampling, no fast-check.

## Verify before opening the PR

- `yarn --cwd packages/immutable-arraybuffer test` (ava) is green, including the
  new file. Run the package's lint/type checks too (eslint, tsc/tsd) as CI does.
- Regression evidence: confirm the new error cases actually exercise the forwarded
  args (e.g. a deliberately-wrong expected offset/length fails), so the matrix is
  load-bearing rather than vacuous.

## PR + communication

- Open the follow-up PR against master with `Refs: #472` and `Refs: #468`, a body
  that states it lands the parked exhaustive boundary tests per erights's go-ahead,
  and notes NO new dev dependency was added (exhaustive, not fast-check). Follow the
  standard PR-body sections (Security/Scaling/Docs/Testing/Compatibility/Upgrade).
- After opening, post a top-level comment **on #472** linking the new follow-up PR
  and stating the parked item is now addressed. (The acknowledgment that work is
  underway has already been posted to #472 by the routing gardener.)
- Bot fork; no upstream endojs/endo contact. All artifacts base+head on
  endojs/endo-but-for-bots.
