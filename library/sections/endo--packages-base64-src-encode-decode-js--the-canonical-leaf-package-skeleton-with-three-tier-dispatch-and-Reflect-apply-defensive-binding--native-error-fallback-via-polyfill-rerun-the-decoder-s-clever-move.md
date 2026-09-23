---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §Native-error-fallback-via-polyfill-rerun (the decoder's clever move)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
const nativeDecodeBase64 = (string, name) => {
  try {
    return apply(
      /** @type {typeof Uint8Array.fromBase64} */ (nativeFromBase64),
      Uint8Array,
      [string, nativeFromBase64Options],
    );
  } catch (err) {
    // Prefer the polyfill's precise diagnostic on any native throw:
    // native error messages are implementation-defined and do not
    // embed `name` or report the failing offset.
    // jsDecodeBase64 is expected to reject anything native rejected;
    // if it does not, fall back to propagating the caught native error.
    jsDecodeBase64(string, name);
    throw err;
  }
};
```

§This-is-different-from-cycle-180-hex-package's-§error-
rewrapping. §Hex-rewraps-the-native-error-message:

```js
// (hex)
} catch (e) {
  throw Error(`Invalid hex in string ${name}: ${e.message}`);
}
```

§Base64-instead-re-runs-the-polyfill-to-get-a-better-diagnostic:

1. §Native-throws — caught.
2. §Run-jsDecodeBase64(string, name) — expected to also throw,
   with a §precise-diagnostic embedding `name` and the failing
   offset.
3. §If-polyfill-throws — that exception propagates (the polyfill's
   error, not the native's).
4. §If-polyfill-doesn't-throw (the safety net) — propagate the
   caught native error so we don't silently succeed.

§The-design-is §use-polyfill-as-error-oracle: the JS path knows
how to produce a useful error message; the native path is faster
but its error messages are implementation-defined. §So-call-
both-on-the-error-path.

§Why-doesn't-hex-do-this? §The-native-Uint8Array.fromHex throws
`SyntaxError` consistently across engines and the polyfill's
extra diagnostic value is smaller (hex has no padding semantics
to disagree on). §Cycle-180-hex-package's Design Decision 6
named the §error-rewrapping cost (try/catch + allocation) vs
benefit (stable contract); base64 makes a different cost/benefit
trade — it pays §two-decode-runs-on-the-error-path for the
§best-possible-diagnostic.

§Both-are-valid §native-vs-polyfill-error-shape-discipline; the
choice depends on what the polyfill knows that the native
doesn't.
