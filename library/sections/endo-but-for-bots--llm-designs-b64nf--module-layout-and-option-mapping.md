---
title: Module layout (split `src/native.js`) and option-bag mapping
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
---

## New module layout

The dispatch logic is split out of the polyfill source files so that
each module has a single concern. `src/native.js` is new; the top-
level `encode.js` and `decode.js` become two-line dispatchers.

```
packages/base64/
  index.js              # Re-exports from ./encode.js, ./decode.js, ./atob.js, ./btoa.js
  encode.js             # Dispatch: native vs polyfill
  decode.js             # Dispatch: native vs polyfill
  atob.js               # Unchanged (uses encodeBase64 indirectly)
  btoa.js               # Unchanged (uses decodeBase64 indirectly)
  shim.js               # Unchanged (installs atob/btoa globals)
  src/
    common.js           # Unchanged — alphabet64, monodu64, padding
    encode.js           # Exports jsEncodeBase64 (pure JS), no globalThis check
    decode.js           # Exports jsDecodeBase64 (pure JS), no globalThis check
    native.js           # NEW: encodeBase64Native, decodeBase64Native
    select.js           # NEW: ENDO_BASE64_FORCE test hook
```

Three things move around:

1. `src/encode.js` and `src/decode.js` lose the `globalThis.Base64`
   inline dispatch; they become pure JS polyfills only. `jsEncodeBase64`
   and `jsDecodeBase64` remain *named exports* of those files for
   forced-polyfill testing and downstream-pinned-to-polyfill use.
2. `src/native.js` captures the intrinsic references and exposes
   adapter functions that thread `@endo/base64`'s semantic defaults
   into the native option bag. If the intrinsics are absent, its
   exports are `undefined` and the dispatcher picks the polyfill.
3. Top-level `encode.js` and `decode.js` become two-line dispatchers
   that pick between native and JS.

The split is the same shape `@endo/hex` will adopt — the two
packages end up structurally isomorphic: `src/native.js`, polyfill
sources in `src/`, top-level dispatcher. The structural isomorphism
is a deliberate output of this design; a shared `select.js` between
the two packages is an open question (~10 lines of duplication vs.
a cross-package dependency).

## Option-bag mapping

The native intrinsics accept a three-field option bag. The mapping
between `@endo/base64`'s longstanding defaults and the native bag is
deterministic — *the captured native call sites encode each option
explicitly so the dispatched function is observationally equivalent
to the polyfill for all well-formed inputs*.

| Option | Native values | `@endo/base64` default | Why |
|---|---|---|---|
| `alphabet` | `'base64'` (RFC 4648 §4: `A–Z a–z 0–9 + /`) or `'base64url'` (`A–Z a–z 0–9 - _`) | `'base64'` | The package has only ever supported RFC 4648 §4; `base64url` is a separate API decision. |
| `lastChunkHandling` | `'loose'` / `'strict'` / `'stop-before-partial'` | `'strict'` | Polyfill rejects trailing garbage, non-alphabet characters, and short strings. Native `'strict'` matches. |
| `omitPadding` | `true` / `false` | `false` | Polyfill always emits `=` padding. |

The three defaults make `encodeBase64Native` and `decodeBase64Native`
observably equivalent to the JS polyfill for all well-formed inputs.
For malformed inputs see
[[endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy]] —
the error *type* widens from `Error` to `Error | SyntaxError` and the
message text changes.

## What callers see

All existing import and call sites stay unchanged:

```js
// @endo/platform/fs/reader-ref.js, @endo/daemon/src/reader-ref.js
import { encodeBase64 } from '@endo/base64';

// @endo/import-bundle/src/index.js, @endo/check-bundle/lite.js
import { decodeBase64 } from '@endo/base64';

// @endo/bundle-source/src/zip-base64.js
const endoZipBase64 = encodeBase64(bytes);
```

`btoa` and `atob` continue to be thin wrappers over the dispatched
`encodeBase64` / `decodeBase64`, so they inherit native-path
performance automatically. No consumer passes a second argument to
`encodeBase64`; `decodeBase64` is occasionally called with a `name`
for error-context purposes — that argument is silently ignored on
the native path (see the next section).

## Heavy consumers

| Consumer | Use site | Benefit |
|---|---|---|
| `@endo/exo-stream` | `iterate-bytes-reader.js` | Every base64-encoded stream chunk on the native path. |
| `@endo/daemon` | `streamBase64`, `reader-ref.js` | Every byte across CapTP that flows through base64 framing. |
| `@endo/bundle-source` + `@endo/import-bundle` + `@endo/check-bundle` | `endoZipBase64` envelopes | Bundle-scale (megabyte) base64 round-trips; biggest absolute speed-up. |
| `@endo/platform/fs/reader-ref.js` | `mapReader` wrapping `encodeBase64` | Transparent native-path adoption. |

The `bundle-source` → `import-bundle` round trip is the dominant
megabyte-scale workload and the one the benchmark is set up to
demonstrate.
