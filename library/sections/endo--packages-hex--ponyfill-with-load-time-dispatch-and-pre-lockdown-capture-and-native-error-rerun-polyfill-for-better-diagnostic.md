---
title: "@endo/hex — §Ponyfill-with-load-time-dispatch, §Pre-lockdown-capture, §Native-error-rerun-polyfill-for-better-diagnostic"
source-slug: endo--packages-hex
section-id: ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
url: https://github.com/endojs/endo/blob/master/packages/hex/src/
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex/src/
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
---

# @endo/hex — §Ponyfill-with-load-time-dispatch + §Pre-lockdown-capture + §Native-error-rerun-polyfill-for-better-diagnostic

`@endo/hex` exposes `encodeHex(bytes): string` and `decodeHex(string, name?): Uint8Array` as a §ponyfill for the TC39 `Uint8Array.prototype.toHex` / `Uint8Array.fromHex` intrinsics (proposal-arraybuffer-base64, Stage 4). Two source files, 172 total lines. The design choices below are the §SES-aware-and-benchmark-aware-and-diagnostic-aware reasons the package is larger than "just convert bytes."

## §Ponyfill-with-load-time-dispatch

The §dispatch-decision-is-made-once-at-module-load — both `encode.js` and `decode.js` read the native intrinsic at top level:

```js
const toHex = /** @type {any} */ (Uint8Array.prototype).toHex;
const nativeToHex =
  typeof toHex === 'function' ? /** @type {() => string} */ (toHex) : undefined;

export const encodeHex =
  nativeToHex !== undefined
    ? bytes => apply(nativeToHex, bytes, [])
    : jsEncodeHex;
```

The §exported-binding-is-set-once at module evaluation; no per-call branching, no post-load reconfiguration. §The-public-API-is-just-encodeHex / `decodeHex`; the pure-JS fallbacks `jsEncodeHex` / `jsDecodeHex` are §also-exported-for-benchmarking-and-for-environments-without-the-native-intrinsic (e.g. SES-locked-down compartments that have explicitly removed the intrinsic).

## §Pre-lockdown-capture defense (SES interaction)

The README and source comments explain why the load-time capture matters under SES:

> Capture the native TC39 `Uint8Array.prototype.toHex` intrinsic at module load, before any caller can reach `encodeHex` and before SES lockdown freezes the prototype. Post-lockdown mutation cannot redirect the dispatched binding.

§Capture-pre-lockdown-then-rely-on-immutability is the same shape `@endo/env-options` (cycle 207) uses for primordials capture, and the same shape the [SES error-handling cluster](endo--packages-ses-src-error-tame-v8-error-constructor-js) uses. The eleventh §SES-defense-family member in the library: §race-against-lockdown-to-snapshot-intrinsics + §post-lockdown-freezing-makes-the-snapshot-load-bearing.

## §Capture-Reflect.apply-once-at-module-load — the fourth canonical uncurry shape

```js
const { apply } = Reflect;
// ...
bytes => apply(nativeToHex, bytes, [])
```

This adds a fourth concrete instance to the §three-canonical-uncurry-shapes-in-endo lineage:

| Cycle | Source | Shape |
| --- | --- | --- |
| 199 | trampoline-memoize-nat trio | `bind.bind(bind.call)` |
| 207 | env-options | `Reflect.apply` |
| 211 | @endo/common | `Function.prototype.call.bind` |
| 215 | @endo/hex | `Reflect.apply` (revisit) |

The comment is explicit about why `Reflect.apply` is preferred to `Function.prototype.call` here, even where `.call` is "assumed to be primordial":

> a tampered `Function.prototype.call` cannot redirect the dispatched native intrinsic invocation.

§Reflect.apply-as-the-defensive-uncurry-against-Function.prototype.call-tampering.

## §Pure-JS-fallback design choices

`jsEncodeHex` (60 lines): §pre-allocate-the-output-array (`new Array(bytes.length * 2)`) §to-avoid-quadratic-time-string-concatenation; §index-into-a-16-character-alphabet-string for nibble→char mapping; final `chars.join('')` keeps a single string allocation. §Lowercase-only with §caller-uppercases-if-needed as the explicit API contract.

`jsDecodeHex` (112 lines): §direct-nibble-computation-from-charcodes (no lookup table) per the source comment:

> Computes nibble values directly from character codes rather than indexing a lookup table. On V8 (Node 22), this is roughly 2.5 to 3 times faster than the table-based decoder for ~1 MiB inputs and avoids any module-scope mutable data.

§Benchmark-result-noted-in-comment with §benchmark-file-named (`test/decode.bench.js` for the variants). §XS-different-tradeoff-noted:

> On XS the polyfill is unavoidably slow regardless of approach; see `test/decode.bench.js` for variants and the relative trade-offs. XS consumers should always reach the native `Uint8Array.fromHex` intrinsic dispatched below as soon as Moddable ships it.

§Document-where-the-polyfill-is-known-to-be-slow + §point-at-the-native-intrinsic-as-the-eventual-answer.

### §`c | 0x20`-fold-uppercase-onto-lowercase trick

```js
// For ASCII codes:
//   '0' to '9' (48 to 57)              -> c - 48
//   'a' to 'f' / 'A' to 'F' (97/65 ..) -> (c | 0x20) - 87
// `c | 0x20` folds upper- onto lowercase; non-letters with that
// bit set still fail the (97..102) range check below.
```

§Range-check-still-rejects-bit-folded-non-letters — the bitwise OR doesn't open the door to false positives because §the-range-check-after-the-fold-is-restrictive.

## §Native-error-rerun-polyfill-for-better-diagnostic — the most novel pattern

The §double-decode-on-error shape is unusual enough to warrant a borrowable name:

```js
export const decodeHex =
  nativeFromHex !== undefined
    ? (string, name = '<unknown>') => {
        try {
          return apply(nativeFromHex, Uint8Array, [string]);
        } catch (err) {
          // Prefer the polyfill's precise offset diagnostic on any
          // native throw; jsDecodeHex is expected to reject anything
          // native rejected.  If it does not, fall back to propagating
          // the caught native error.
          jsDecodeHex(string, name);
          throw err;
        }
      }
    : jsDecodeHex;
```

§On-native-throw-rerun-the-polyfill-to-produce-better-diagnostic. The fast-path-success-path stays cheap (one native call). The error path pays the §quadratic-overhead-but-only-on-failure to get the precise offset and the user-provided `name` in the error message. §The-polyfill-is-the-error-formatter-not-just-the-fallback.

§Three-named-properties-of-this-pattern:
1. §Native-fast-path-stays-fast (no instrumentation overhead).
2. §Error-path-gets-precise-offset-diagnostic from the polyfill that knows ASCII offsets.
3. §If-polyfill-disagrees-with-native (the polyfill would accept what native rejected), §fall-back-to-the-native-error (`throw err`).

§Implementation-defined-native-error-messages-do-not-report-the-failing-offset, so this is not a redundant courtesy — it's the only way to give the user "invalid hex character at offset N of string `<name>`" diagnostics under a native-dispatched binding.

§Two-different-shapes-for-dispatching-to-native:
- `encode.js`: §unconditional-dispatch (no error path branching — native success/failure passes through).
- `decode.js`: §dispatch-with-on-failure-polyfill-rerun (the §error-path-is-where-the-polyfill-earns-its-keep).

The asymmetry is meaningful: §encode-cannot-fail-on-valid-input but §decode-can-fail-on-invalid-input. The §polyfill-only-runs-on-failure-when-the-extra-information-is-actually-needed.

## §Name-for-error-diagnostics parameter

```js
export const jsDecodeHex = (string, name = '<unknown>') => {
```

§Optional-name-defaults-to-'<unknown>'. The name appears in error messages:
- `Hex string must have an even length, got ${string.length} in string ${name}`
- `Invalid hex character at offset ${i * 2} of string ${name}`

§Caller-supplied-context-string for §debugging-which-file-or-stream-the-bad-hex-came-from. §Diagnostic-feedback-pattern that complements the cycle 198 §patterns-diagnostic-feedback work — both designs say §the-data-is-already-there-just-locked-include-it-in-the-error.

## §Harden-every-export

```js
harden(jsEncodeHex);
harden(jsDecodeHex);
harden(encodeHex);
harden(decodeHex);
```

§Every-exported-function-is-hardened — the polyfills, the dispatched defaults, all four. §Belt-and-braces-against-tampering even for the polyfills (which §don't-need-to-be-hard-for-security but §are-hard-for-consistency-with-the-public-API).

## §Compared to @endo/base64 (already ingested)

| Aspect | @endo/base64 (cycle 7) | @endo/hex (cycle 215) |
| --- | --- | --- |
| Status | Pre-TC39-proposal native intrinsics | §ponyfill-for-Stage-4-proposal |
| Dispatch | Pure JS only (no native fallback) | §load-time-dispatch-to-native-when-present |
| Diagnostic | Throws on invalid chars (no offset) | §precise-offset-diagnostic + §name-parameter |
| Errors path | Single implementation | §double-decode-on-native-error |

§Two-different-binary-encoding-utility-shapes-in-the-same-library-family. The §evolution-from-base64-to-hex tracks the §TC39-proposal-arraybuffer-base64-Stage-4 stabilization.

## §Compared to other ponyfills in the library

| Cycle | Package | Native intrinsic | Shape |
| --- | --- | --- | --- |
| 197 | @endo/panic | `Error.prototype.stack` | §three-layer-dispatch-chain-as-imperfect-ponyfill |
| 201 | @endo/immutable-arraybuffer | `ArrayBuffer.prototype.transferToImmutable` | §ponyfill+shim + §race-to-install-detect-only |
| 215 | @endo/hex | `Uint8Array.{toHex,fromHex}` | §ponyfill-with-load-time-dispatch + §native-error-rerun-polyfill |

§Three-different-ponyfill-shapes-in-the-library family — a new sibling to the existing §three-canonical-uncurry-shapes, §three-utility-cluster-shapes, and §three-runtime-version-compat-hacks meta-clusters.

## Related material in the library

- **cycle 7 @endo/base64**: §sibling-binary-encoding-utility; @endo/hex extends the pattern with native dispatch and precise offset diagnostics.
- **cycle 197 @endo/panic**: §three-layer-dispatch-chain-as-imperfect-ponyfill — both packages reach for native first, fall through to polyfill.
- **cycle 198 patterns-diagnostic-feedback**: §the-data-is-already-there-just-locked sibling — both designs include §extra-context-in-the-error-message-when-it-costs-nothing.
- **cycle 199 trampoline/memoize/nat trio**: §three-canonical-uncurry-shapes — `bind.bind(bind.call)` shape; @endo/hex uses `Reflect.apply` (the cycle 207 shape).
- **cycle 201 @endo/immutable-arraybuffer**: §ponyfill+shim sibling — both packages are §pre-Stage-4-TC39-fillers.
- **cycle 205 @endo/evasive-transform**: §SES-censorship-evasion sibling — both packages have §SES-aware-load-time-decisions.
- **cycle 207 @endo/env-options**: §pre-SES-prelude sibling — both packages capture intrinsics §before-lockdown.
- **cycle 211 @endo/common**: §ten-utility-files sibling — `@endo/hex` is a different shape (§two-files-tight-utility) but §similar-conscious-attention-to-tree-shakeability (only two files imported).
- **cycle 213 @endo/stream-node**: §Buffer-to-Uint8Array sibling — both packages live near §the-Uint8Array-byte-handling-layer.

## §Three-different-ponyfill-shapes summary table

| Property | @endo/panic | @endo/immutable-arraybuffer | @endo/hex |
| --- | --- | --- | --- |
| Public API | `panic(error)` | `transferToImmutable`, `sliceToImmutable` | `encodeHex`, `decodeHex` |
| Dispatch | three-layer chain | race-to-install-detect-only | load-time intrinsic capture |
| Error path | log + exit | throw new TypeError | §native-rerun-polyfill |
| Why ponyfill | host engine variance | proposal not yet Stage 4 | §Stage-4-but-not-yet-everywhere |

## §Library-reaches-721-sections at cycle 215 (chat-lane @endo/hex).
