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
title: §Reflect.apply-captured-at-module-load (the defensive binding)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
// Capture `Reflect.apply` once at module load; we prefer it to
// `Function.prototype.call` even where `.call` is assumed to be
// primordial, so a tampered `Function.prototype.call` cannot redirect
// the dispatched native intrinsic invocation.
const { apply } = Reflect;
```

§The-comment-justifies-the-discipline-explicitly. §Even-though-
`.call`-is-assumed-primordial (SES will freeze it), the captured
`Reflect.apply` survives any pre-lockdown tampering of
`Function.prototype.call`.

§Compare-to-cycle-180-hex-package's `nativeToHex.call(bytes)`
which uses `.call` directly. §This-is-a-deliberate-simplification
in the hex clone — §the-three-files-omitted (atob.js / btoa.js /
shim.js) were §deliberate-omission-not-oversight, but the
§use-of-`.call`-vs-`Reflect.apply` is §a-different-defensive-
stance that the hex design did not call out as a deviation.

§Native-dispatch-via-Reflect.apply:

```js
const nativeEncodeBase64 = data =>
  apply(
    /** @type {typeof Uint8Array.prototype.toBase64} */ (nativeToBase64),
    data,
    [],
  );
```

§Three-argument-apply: function reference + thisArg + args
array. §The-`data`-is-the-thisArg because `toBase64` is a
prototype method invoked on the Uint8Array; the args array is
empty.

§Compare-to-the-xs-tier:

```js
const xsEncodeBase64 = data => apply(encode, undefined, [data]);
```

§Different-thisArg-and-args-shape because legacy XS
`globalThis.Base64.encode` is a static function (no `this`),
taking the bytes as an argument.

§Same-Reflect.apply-discipline-across-both-tiers. §The-discipline-
is §all-native-paths-go-through-captured-Reflect.apply.
