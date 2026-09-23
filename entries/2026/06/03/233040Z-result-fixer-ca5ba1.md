---
ts: 2026-06-03T23:30:40Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/fixer--ca5ba1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - entries/2026/06/03/232114Z-dispatch-liaison-ca5ba1.md
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4423421007
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617555317
---

# result: fixer ca5ba1 — #417 README reiteration per @endo/bytes spackle-front elaboration

Addressed kriskowal's CHANGES_REQUESTED review `4423421007` on PR endojs/endo-but-for-bots#417. One README-only commit + top-level summary comment + per-inline replies on five of the six review threads (the sixth was "Great." with no action needed).

## Head SHA

- Before: `2071b71e3`
- After: `4f28fc697` (regular append; no force)

Pushed to `endojs/endo-but-for-bots:mirror/3164-freezable-typedarrays`.

## Per-inline-comment status

| Line | Comment ID | Subject | Status | Reply ID |
|------|------------|---------|--------|----------|
| 63 | 3352429174 | eslint rule for spackle import pattern | Addressed in README (new "Forbidding direct use via eslint-plugin" section) + flagged as `@endo/eslint-plugin` follow-up dispatch | 3352510406 |
| 91 | 3352443757 | one TypedArray constructor per realm; portable patterns; idiomatic imports; eslint discouragement; `makePseudoTypedArrayConstructor` internal | Addressed in README (reshaped "Freezable TypedArray Ponyfill" section; documented symbol-on-`Uint8Array` rendezvous; `makePseudoTypedArrayConstructor` flagged as scheduled-to-be-internal) | 3352510794 |
| 110 | 3352454441 | encourage spackle without forcing shim; test all variations; use @endo/bytes as uniform pattern | Addressed in README ("Using the Ponyfills Across Native and Shim" reshaped to lead with `@endo/bytes`; shim made opt-in; parity tests obligated to exercise all four lockdown-vs-shim combinations on Node and XS) | 3352511146 |
| 111 | 3352455376 | "Great." (positive acknowledgment) | No action needed; no reply | — |
| 220 | 3352461879 | code suggestion: install at `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]` | Applied verbatim (suggestion accepted) + generalized in new "Symbol rendezvous shape" section | 3352511478 |
| 234 | 3352467194 | SES permits must list symbol; lockdown requires shim; without lockdown shim not required | Addressed in README (new "Required changes to `@endo/ses` permits" section + four-combination lockdown-vs-shim matrix) | 3352511911 |

Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4617555317

## @endo/bytes spackle-front shape in README

The README's "Ramifications for `@endo/bytes` as a Spackle" section reframes `@endo/bytes` from "near-fit for the spackle pattern" to "the spackle front" for three families of behavior:

1. **Immutable `ArrayBuffer` operations**: `bytesToImmutable`, `bytesFromImmutable`, `concatImmutables`. Spackle install at `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]` and companion symbols.
2. **Frozen `TypedArray`s backed by immutable buffers**: spackle install of `makePseudoTypedArrayConstructor(C)` for each `C` in the `TypedArray` family at a `Uint8Array[Symbol.for('freezableConstructor')]`-shaped symbol per constructor. `makePseudoTypedArrayConstructor` becomes module-private once the spackle is the public path.
3. **Text-codec workarounds**: spackle install of capture-on-intrinsic `TextEncoder` and `TextDecoder` at `Uint8Array[Symbol.for('toUtf8String')]` and `Uint8Array[Symbol.for('fromUtf8String')]`. The capture-on-intrinsic at module load is the load-bearing guarantee against compartment-global endowment override.

The symbol-on-intrinsic discipline (not on `Object`) is the load-bearing decision; specific symbol names are subject to future TC39 coordination but the placement-by-prototype-of-operand is the rule.

## ESLint rule sketch

The README's "Forbidding direct use via eslint-plugin" section documents the rule shape for `@endo/eslint-plugin`:

- **Forbidden identifiers**: `TextEncoder`, `TextDecoder`, `Uint8Array`, `Uint16Array`, `Uint32Array`, `Uint8ClampedArray`, `Int8Array`, `Int16Array`, `Int32Array`, `Float32Array`, `Float64Array`, `BigInt64Array`, `BigUint64Array`, `ArrayBuffer` (as `NewExpression` callee).
- **Whitelist exception**: capture-at-module-load pattern (`const C = globalThis.C;`) at the spackle's install site; module-path or per-rule-allowlist option whitelists `@endo/bytes` and the freezable-typedarray-pony module.
- **Fix-it hints**: each forbidden identifier maps to its `@endo/bytes` equivalent (`new TextEncoder()` → `bytesFromText(...)`; `new TextDecoder()` → `bytesToText(...)`; etc.).
- **Severity**: default `warn`, opt-in `error` for end-to-end spackle consumers.
- **Rationale string**: cites the spackle pattern and the lockdown-time guarantee (compartment-global endowment of `TextDecoder` does not redirect the spackle's `Uint8Array[Symbol.for('toUtf8String')]` install because the spackle captures the primordial at module load).

Rule code, test fixtures, and `recommended` config entry are scope for the follow-up dispatch against `@endo/eslint-plugin`.

## Follow-up dispatches flagged for steward

The README's new "Follow-up dispatches" subsection enumerates four:

1. `@endo/bytes`: spackle install for six operations (slice + transfer + encode + decode + freezable-constructor-family + idempotency), migrate `makePseudoTypedArrayConstructor` to module-private.
2. `@endo/eslint-plugin`: the forbid-direct-use rule + tests + recommended config entry.
3. `@endo/ses`: permits update admitting the registered `Symbol.for(...)` keys on `ArrayBuffer.prototype` and on `Uint8Array` (and other `TypedArray` constructors).
4. XS-side parity runner: `_xs.js` + `generate-test-xs.js` + `test:xs` script wiring, exercising all four lockdown-vs-shim combinations. Requires Moddable SDK toolchain.

Each follow-up is a separate PR with a separate review cycle. The split keeps per-package changes small and lets the XS-side wiring wait for toolchain availability without blocking the rest.

## CI state

CI is in-progress on the new head; many checks running normally (test matrix across Node 22/24 on ubuntu/macos, browser-tests, lint, cover, viable-release, test-hermes). Already-completed:

- `build`, `test262`, `check-action-pins`, `test-xs`, `test-ocapn-python`: SUCCESS.
- `zizmor` (Workflow security audit): FAILURE. Confirmed pre-existing: the same `zizmor` check was FAILURE on the prior commit `2071b71e3` and is not caused by this README-only push. Workflow YAML scanner; orthogonal to README content.

The fixer norm to "drive CI to green BEFORE re-requesting maintainer review" applies; for a README-only push the test matrix should remain green and any blue (the in-progress checks) should converge without additional work. The top-level summary comment includes an `@kriskowal` mention in lieu of the `requested_reviewers` API call (per the fixer norm: "Do not fall back to requesting the bot's own identity if the reviewer is the PR author").

## Per-action authorizations used

- Read all relevant files in `immutable-arraybuffer`, `bytes`, `eslint-plugin`: authorized; used to ground the rule sketch and the spackle-install sketch.
- Edit `packages/immutable-arraybuffer/README.md`: authorized; one regular-append commit.
- Push to `mirror/3164-freezable-typedarrays`: authorized; regular append; no force.
- Top-level PR comment + per-inline review-thread replies: authorized; posted on PR #417.

## Not done (out of scope per dispatch)

- Source-code edits to `packages/bytes/`, `packages/eslint-plugin/`, `packages/ses/`: explicitly out of scope; flagged as follow-up dispatches.
- Modifying upstream endo#3164: not authorized.
- Force-pushing: not authorized.
- Un-drafting / re-drafting: not authorized (PR already un-drafted by judge per kriskowal earlier).

Self-improvement: nothing this time.
