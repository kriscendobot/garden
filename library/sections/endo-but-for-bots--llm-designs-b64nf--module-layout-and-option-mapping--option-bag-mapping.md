---
title: Option-bag mapping
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
