---
title: API compatibility summary
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript, bundles]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--decisions-rollout-and-known-gaps
---

```ts
// Public signatures — unchanged
export const encodeBase64: (data: Uint8Array) => string;
export const decodeBase64: (string: string, name?: string) => Uint8Array;
export const atob: (encodedData: string) => string;
export const btoa: (stringToEncode: string) => string;
```

Conditional subpath exports at `./encode.js`, `./decode.js`,
`./atob.js`, `./btoa.js`, and `./shim.js` are preserved exactly as
declared in `package.json`. The native decoder returns a fresh
`Uint8Array` whose `.buffer` is a fresh `ArrayBuffer`; the polyfill
returns a `subarray` of an oversized buffer whose `.buffer` is the
oversized one — a subtle difference already tolerated by all
consumers, called out in the design as worth knowing about.
