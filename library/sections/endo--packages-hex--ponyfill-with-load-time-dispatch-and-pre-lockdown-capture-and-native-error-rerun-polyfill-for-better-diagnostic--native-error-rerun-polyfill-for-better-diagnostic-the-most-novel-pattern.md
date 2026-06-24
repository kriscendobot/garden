---
title: §Native-error-rerun-polyfill-for-better-diagnostic — the most novel pattern
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
parent: endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
---

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
