---
title: New module layout
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping
---

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
