---
title: Problem and detection strategy — ponyfill-shim pattern for TC39 native base64 intrinsics
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
notes: **Status: Not Started** upstream. Third member of the *vetted-shim-or-ponyfill* design family alongside `hardened-url-shim` and `hardened-text-codecs-shim`. The detection-and-capture-before-lockdown pattern shared with the two prior shims gets its first full treatment here as a deliberate API discipline. Sibling design `@endo/hex` applies the identical structure to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`.
---

`@endo/base64` is on the hot path of the Endo stack: every byte that
crosses a CapTP boundary, every `endoZipBase64` bundle envelope, every
`streamBase64` daemon call, every `@endo/exo-stream` reader/writer
flows through `encodeBase64` / `decodeBase64`. The package today
implements both in pure JavaScript — correct on every engine, including
XS, but measurably slower and larger than the engine-native
implementations now shipping under the TC39 *"Uint8Array to/from
base64"* proposal (stage 3, in V8, SpiderMonkey, JavaScriptCore, and
Node.js 22+).

The native intrinsics:

- `Uint8Array.fromBase64(string, options?) → Uint8Array` — static method.
- `Uint8Array.prototype.toBase64(options?) → string` — instance method.
- `Uint8Array.prototype.setFromBase64(string, options?) → { read, written }` — write-into-existing-buffer variant; not used here.

The native implementations run an order of magnitude faster on short
strings and several orders of magnitude faster on the megabyte-scale
inputs common for bundle transfer, and shipping them as the default
would also remove a few kilobytes of polyfill code from every bundle
that includes `@endo/base64`.

## Why a new pattern is needed

The package already contains the seed of a fallthrough pattern. The
existing dispatch reads a possibly-mutable `globalThis`:

```js
export const encodeBase64 =
  globalThis.Base64 !== undefined ? globalThis.Base64.encode : jsEncodeBase64;
```

Two problems:

1. **XS-specific**: predates the TC39 proposal; only fires on XSnap.
2. **Reads mutable `globalThis` at module load**: which on some
   embeddings happens *before* SES lockdown, exposing the dispatch to
   tampering.

The new design replaces this with the TC39-intrinsic detection.

## The ponyfill-shim pattern (detection + capture-before-lockdown)

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

## Why this is a family, not a one-off

The pattern is named explicitly: `@endo/hex` is a sibling parallel
proposal that applies *the identical detection-and-capture pattern*
to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`. The two
packages will share a module structure (see
[[endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping]])
and a common test strategy.

This is the third member of the vetted-shim family alongside
[[endo-but-for-bots--llm-designs-hardened-url-shim]] and
[[endo-but-for-bots--llm-designs-hardened-text-codecs-shim]]; together
they constitute the *"tame and dispatch to native intrinsics inside
SES"* convention. The distinction here is that `base64` and `hex`
are **ponyfills** — they fall back to a JS polyfill when the native
is absent — whereas the URL and TextEncoder shims are **vetted shims**
that simply expose the host-provided intrinsic and degrade silently
on hosts that lack it (no polyfill is provided). The choice is
driven by whether a JS-only fallback is practical: URL is too large
to polyfill; base64 already has one.
