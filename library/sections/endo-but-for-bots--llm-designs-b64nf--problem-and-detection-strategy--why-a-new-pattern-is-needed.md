---
title: Why a new pattern is needed
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
