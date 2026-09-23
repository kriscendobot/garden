---
title: Error semantics — the one observable difference
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, testing]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy
---

`jsDecodeBase64` throws `Error` with specific messages. The native
`Uint8Array.fromBase64` throws `SyntaxError` with implementation-
defined messages.

| Malformed input | JS path | Native path |
|---|---|---|
| `'%'` | `Error: Invalid base64 character % ...` | `SyntaxError: ...` |
| `'Z'` (missing padding) | `Error: Missing padding at offset 1 ...` | `SyntaxError: ...` |
| `'Zg==%'` (trailing garbage) | `Error: ... trailing garbage % ...` | `SyntaxError: ...` |

The error *type* widens from `Error` to `Error | SyntaxError`, and
the message text changes. Consumers who `try { decodeBase64(x) }
catch (_) { ... }` continue to work; consumers who regex-match error
messages would need to loosen — but the design's monorepo audit
finds **no consumer that branches on the error message**, so the
loosening is safe.

### Two bridging options

1. **Accept the native error text (recommended).** Tests are
   split between a polyfill-specific file (regex-matched messages)
   and a native-path file (error-type assertions only). The
   loosening is documented in `CHANGELOG.md`.
2. **Re-throw with the polyfill's message.** Wrap
   `decodeBase64Native` in a `try`/`catch` that catches the native
   error and re-throws via `makeError` from `@endo/errors` with a
   message shaped like the polyfill's. Cost: a catch on every decode
   *failure* (rare) and loss of fidelity in what the native decoder
   complained about. Not recommended unless a consumer surfaces who
   relies on the polyfill message text.

The design recommends option 1.
