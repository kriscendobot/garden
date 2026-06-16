---
title: The ponyfill-shim pattern (detection + capture-before-lockdown)
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
notes: **Status: Not Started** upstream. Third member of the *vetted-shim-or-ponyfill* design family alongside `hardened-url-shim` and `hardened-text-codecs-shim`. The detection-and-capture-before-lockdown pattern shared with the two prior shims gets its first full treatment here as a deliberate API discipline. Sibling design `@endo/hex` applies the identical structure to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`.
parent: endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy
---

The pattern is **detect once at module init, close over direct
references to the intrinsics**:

```js
const nativeToBase64 = Uint8Array.prototype.toBase64;
const nativeFromBase64 = Uint8Array.fromBase64;

const encodeBase64Native = data =>
  nativeToBase64.call(data, { alphabet: 'base64', omitPadding: false });

const decodeBase64Native = (string, _name) =>
  nativeFromBase64.call(Uint8Array, string, {
    alphabet: 'base64',
    lastChunkHandling: 'strict',
  });

export const encodeBase64 =
  typeof nativeToBase64 === 'function' ? encodeBase64Native : jsEncodeBase64;
harden(encodeBase64);
```

Three structural properties:

1. **Captured references at module load**, *before* `lockdown()`
   freezes the intrinsics. `globalThis`, `Uint8Array`, and
   `Uint8Array.prototype` are still mutable when the file evaluates,
   but bindings closed over at the top level are preserved across
   lockdown.
2. **Once the module is evaluated and exports are hardened**, no
   later mutation to `Uint8Array` — by host, polyfill, or attacker —
   changes the behavior of the ponyfilled functions.
3. **Feature-tested independently**: `hasNativeToBase64` and
   `hasNativeFromBase64` are guarded separately because a partial /
   hand-patched environment must not silently fall back on both
   paths when only one is missing.
