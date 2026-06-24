---
kind: result
role: liaison
dispatch-root: dispatches/liaison--6de70c
cycle: 318
lane: chat
host: endolin
date: 2026-06-12
---

# Result — liaison cycle 318: @endo/hex src/decode.js (chat-lane; ninth consecutive @endo/* source; first three-file pivot cluster established)

Cycle 318 ingest: **@endo/hex src/decode.js** (112 lines) — the decode-side companion to cycle 314's encode.js and cycle 317's README. Chat-lane after cycle 317's designs-lane. **Ninth consecutive non-garden source after the pivot** (cycles 310-318). **§the-named-first-three-file-cluster-of-the-pivot** established: hex encode source (314) + hex README (317) + hex decode source (318).

## Single most structurally interesting move

**§the-named-native-fast-path-polyfill-diagnostic-path** — when native `Uint8Array.fromHex` is available, `decodeHex` tries it first; on any throw, re-runs `jsDecodeHex` against the same input to recover **precise offset information**:

```js
export const decodeHex =
  nativeFromHex !== undefined
    ? (string, name = '<unknown>') => {
        try {
          return apply(nativeFromHex, Uint8Array, [string]);
        } catch (err) {
          jsDecodeHex(string, name);
          throw err;
        }
      }
    : jsDecodeHex;
```

The rationale, named in the comment: **§the-named-native-throw-doesn't-name-the-offset** — *"native error messages are implementation-defined and do not report the failing offset"*. Native gets the fast path; polyfill gets the diagnostic path. The cost is a double-decode on failure (work wasted) but **§the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail** — failures are exceptional and diagnostic quality is paid only when it's needed. **§the-named-call-the-polyfill-expecting-it-to-throw** treats the polyfill as a *diagnostic oracle*, not as an authoritative validator: §the-named-fallback-to-original-error-if-polyfill-disagrees handles the case where native and polyfill disagree about validity.

## The encode/decode architectural asymmetry

Cycle 314's `encodeHex` dispatches statically (native-or-polyfill chosen at module load, no fallback). Cycle 318's `decodeHex` dispatches dynamically with a polyfill fallback for diagnostics. Why?

**§the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry**: `encodeHex` takes a Uint8Array (trusted-shape input from a JS caller; failures rare). `decodeHex` takes a user-provided string (could contain anything; diagnostic quality matters on failure). The README's symmetric API (`encodeHex` / `decodeHex`) hides this architectural asymmetry.

**§the-named-symmetric-API-asymmetric-implementations** as a transferable pattern: when two functions look symmetric at the API surface, check whether their *failure modes* are also symmetric; if not, the implementations will differ on exactly that axis.

## First three-file pivot cluster

Cycles 314 + 317 + 318 form the **first three-file cluster of the pivot**. Three reference axes (**§the-named-three-file-cluster-doc-impl-sibling-arc**):

1. **doc ↔ impl**: README cites both source files via API section H3 subheadings; each source implements promises the README names.
2. **impl ↔ sibling-impl**: encode.js and decode.js share file-level eslint-disable, harden import, Reflect.apply destructure, cast-to-any, typeof-function check, typeof type-inheritance, two-harden-calls discipline — **§the-named-sibling-file-shape-shared**. They differ on the one axis where their failure modes differ.
3. **impl → doc**: decode.js cites encode.js directly ("See `encodeHex` for the rationale" — **§the-named-cross-reference-rationale-to-sister-file**); §the-named-don't-repeat-rationale-cite-the-sibling.

## First-explicit-observations (twenty-plus)

- §the-named-native-fast-path-polyfill-diagnostic-path
- §the-named-call-the-polyfill-expecting-it-to-throw
- §the-named-fallback-to-original-error-if-polyfill-disagrees
- §the-named-native-throw-doesn't-name-the-offset
- §the-named-encode-decode-asymmetry-IS-named-input-trust-asymmetry
- §the-named-symmetric-API-asymmetric-implementations
- §the-named-cross-reference-rationale-to-sister-file
- §the-named-don't-repeat-rationale-cite-the-sibling
- §the-named-direct-charcode-arithmetic-not-lookup-table
- §the-named-two-justifications-one-decision
- §the-named-comment-cites-named-benchmark-result (V8 + Node 22 + ~1 MiB + 2.5-3x)
- §the-named-no-module-scope-mutable-data-discipline
- §the-named-bitwise-case-fold-trick
- §the-named-non-letters-still-fail-discipline
- §the-named-sentinel-value-minus-one-for-nibble
- §the-named-throw-includes-precise-failing-offset
- §the-named-odd-length-check-first
- §the-named-XS-engine-named (with §the-named-Moddable-IS-named-XS-vendor)
- §the-named-Reflect.apply-with-explicit-thisArg
- §the-named-js-prefix-discipline-for-polyfill-name
- §the-named-sibling-file-shape-shared
- §the-named-three-file-cluster-doc-impl-sibling-arc
- §the-named-first-three-file-cluster-of-the-pivot
- §the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail

## Multi-cycle patterns extended

- §nine-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318)
- §three-cycles-with-named-Stage-4-TC39-proposal-citation (314 + 317 + 318)
- §two-cycles-with-named-Reflect.apply-captured-at-module-load (314 + 318)
- §two-cycles-with-named-eslint-disable-no-bitwise (314 + 318)
- §two-cycles-with-named-cast-to-any-to-access-non-spec-prop (314 + 318)
- §two-cycles-with-named-feature-detection-via-typeof-function (314 + 318)
- §two-cycles-with-named-typeof-IS-named-type-inheritance-via-JSDoc (314 + 318)
- §two-cycles-with-named-two-harden-calls-on-exports (314 + 318)
- §two-cycles-with-named-js-prefix-discipline-for-polyfill-name (314 + 318)
- §seven-cycles-with-named-Hardened-JS-discipline (310 + 312 + 313 + 315 + 316 + 317 + 318)
- §nine-cycles-with-named-harden-call-on-exports

## Tier-3 meta-patterns

- **§the-named-symmetric-API-asymmetric-implementations** — symmetric APIs can have asymmetric implementations when failure modes differ
- **§the-named-pay-for-diagnostic-precision-in-the-time-it-takes-to-fail** — diagnostic quality cost paid only on failure paths
- **§the-named-call-the-polyfill-expecting-it-to-throw** — known-stricter implementation used as diagnostic oracle without ceding authority
- **§the-named-two-justifications-one-decision** — one technique satisfies two unrelated constraints (perf + Hardened-JS for no-lookup-table)
- **§the-named-cross-reference-rationale-to-sister-file** — don't repeat rationale across sibling files; cite the sibling
- **§the-named-three-file-cluster-doc-impl-sibling-arc** — three reference axes when a cluster contains README + sibling implementations

## Synthesis-target

Slot machine library **§`@game/encoding/src/decode.js`** — bet-ID decoder (mirror of cycle 314's synthesis-target `encode.js`):

1. Cite the sibling file for the rationale of any shared idiom ("See `encode-bet-id.js` for the rationale").
2. Direct character-code arithmetic instead of a lookup table; cite the engine + version + speedup + input size in a comment.
3. Bitwise case-fold trick (`c | 0x20`) with explicit defense narrated in the comment.
4. Sentinel value for "no valid value found", checked at end.
5. Throw includes precise failing offset.
6. Cheap-validation-first discipline.
7. Native fast path + polyfill diagnostic path: dispatch native for happy path; on any throw, re-run polyfill for diagnostics.
8. Call-the-polyfill-expecting-it-to-throw discipline; fall back to original native error if polyfill disagrees.
9. Two-justifications-one-decision: defend the no-lookup-table choice on perf AND Hardened-JS grounds.
10. Symmetric API + asymmetric implementations: if encode and decode have different input-trust postures, the implementations will differ even though the API surfaces look symmetric.

## Library state after cycle 318

- §library-reaches-830-sections from 368 source documents
- §one-hundred-and-fifty-first consecutive designs-chat alternation
- §nine-cycles-with-named-pivot-domain-stay (pivot productive at nine cycles)
- §the-named-first-three-file-cluster-of-the-pivot established
- §seven-cycles-with-named-Hardened-JS-discipline

## Next cycle pacing

Cycle 319 is designs-lane next. With the hex three-file cluster complete, candidate moves:

- **@endo/lp32 writer.js** is chat-lane; defer.
- **@endo/stream README.md** — designs-lane; cited from cycle 315's lp32 round-trip example as the cross-package composition partner; would introduce a **fifth package** in the pivot cluster. Productive choice.
- **@endo/nat docs/...** (if any docs/ subdir exists) — designs-lane; would deepen @endo/nat.
- **@endo/memoize docs/...** (if any docs/ subdir exists) — designs-lane; would deepen @endo/memoize.
- **@endo/hex SECURITY.md** — designs-lane; would deepen the hex cluster to four files and introduce a *different shape* (SECURITY.md is not README) within the cluster.

@endo/stream README is the productive choice (introduces a fifth package; tests whether §the-named-six-section-README-shape vs §the-named-four-section-README-shape continues to vary by package depth; closes a cross-package citation arc with cycle 315's lp32 README which cited `@endo/stream` as the composition partner). Picking freely but tracking for future work.
