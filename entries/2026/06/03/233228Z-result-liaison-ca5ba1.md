---
ts: 2026-06-03T23:32:28Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/232114Z-dispatch-liaison-ca5ba1.md
  - entries/2026/06/03/233040Z-result-fixer-ca5ba1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
---

# result: #417 README reiteration applied; 4 follow-up dispatches flagged

Fixer `ca5ba1` closed cleanly. README rewritten to reflect the
elaborated @endo/bytes-spackle proposal.

## Outcome

- **New head**: `4f28fc697` on `mirror/3164-freezable-typedarrays`
  (regular append on `2071b71e3`).
- **Top-level comment**: `4617555317`.
- **Per-inline replies**:
  - 63 → `3352510406`
  - 91 → `3352510794`
  - 110 → `3352511146`
  - 111 → no reply (positive ack only)
  - 220 → `3352511478` (code suggestion applied verbatim)
  - 234 → `3352511911`

## README shape changes

- @endo/bytes framed as spackle front for three families
  (immutable-ArrayBuffer ops, frozen TypedArrays, text-codec
  workarounds).
- Symbol-on-intrinsic pattern documented:
  `ArrayBuffer.prototype[Symbol.for('sliceBufferToImmutable')]`,
  `Uint8Array[Symbol.for('toUtf8String')]`,
  `Uint8Array[Symbol.for('fromUtf8String')]`,
  + `freezableConstructor` symbol per TypedArray family.
- TextEncoder/TextDecoder capture-on-intrinsic at module load
  is the load-bearing guarantee against compartment-global
  endowment override.
- "Using the Ponyfills" reshaped to lead with `@endo/bytes`;
  shim is opt-in.
- Four-variation parity matrix (with/without lockdown ×
  with/without shim) obligated.
- ESLint rule sketch: forbid identifiers (TextEncoder,
  TextDecoder, TypedArray ctors, ArrayBuffer as
  NewExpression), whitelist at spackle's capture site,
  fix-it hints map to @endo/bytes equivalents, default warn /
  opt-in error.
- SES permits update: admit registered `Symbol.for(...)` keys.

## Follow-up dispatches flagged (for steward to queue)

1. **`@endo/bytes`** source dispatch: six-operation spackle
   install + `makePseudoTypedArrayConstructor` internalization.
2. **`@endo/eslint-plugin`** dispatch: forbid-direct-use rule
   + test fixtures + recommended-config entry.
3. **`@endo/ses`** dispatch: permits update admitting the
   registered `Symbol.for(...)` keys.
4. **XS-side parity runner wiring**: requires Moddable SDK
   toolchain; exercises all four lockdown-vs-shim
   combinations.

## CI on `4f28fc697` (per fixer's check)

- SUCCESS: build, test262, check-action-pins, test-xs,
  test-ocapn-python.
- FAILURE: zizmor (pre-existing per shepherd's earlier
  diagnosis on the changesets/action tag drift; will clear
  once #421 merges).
- Other matrix jobs still running.

## Teardown

`dispatches/fixer--ca5ba1` torn down.

## Steward queue post-engagement

- **#417** README reiteration at `4f28fc697`; awaits
  maintainer reassessment + 4 follow-up dispatches once
  proposal is approved.
- **#421** zizmor pin fix DRAFT; awaits gauntlet (or
  maintainer fast-path merge).
- **#411** ready for boatman re-ferry post-#421 merge.
- All other queue items unchanged.
