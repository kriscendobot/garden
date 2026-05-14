---
title: Error semantics, `name` parameter handling, and the `ENDO_BASE64_FORCE` test gate
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, testing]
status: current
---

## Error semantics — the one observable difference

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

## The `name` parameter on the native path

`jsDecodeBase64(string, name?)` accepts an optional `name` argument
that appears in error messages. The native intrinsic does not accept
a name. Under option 1, **the argument is silently ignored on the
native path**, matching the current JS path's tolerance of extra
arguments. The function signature remains `(string, name?) →
Uint8Array` so no caller becomes a type error. The design notes
this could become a formal deprecation in a future major version.

## `ENDO_BASE64_FORCE` — test-only env-variable gate

```js
// src/select.js
const force = typeof process !== 'undefined' && process.env
  ? process.env.ENDO_BASE64_FORCE
  : undefined;

export const forcedPath =
  force === 'native' || force === 'polyfill' ? force : undefined;
```

- `ENDO_BASE64_FORCE=polyfill` — always use `jsEncodeBase64` /
  `jsDecodeBase64`, even when the native intrinsics are present.
- `ENDO_BASE64_FORCE=native` — always use the native path; throw at
  module load if the intrinsics are absent.
- Unset — use native if present, else polyfill.

**The gating is a test-only affordance.** In production the env var
is unset and detection is automatic.

The design rules out a `globalThis` flag explicitly: *"that would
create a footgun: any tenant in a multi-tenant realm could flip the
switch at module load."* An import-time flag would force every
consumer into deciding the path. An environment variable keeps the
affordance out of the code path that ships to production.

## Test file split

The existing `test/main.test.js` is split:

```
test/
  main.test.js              # Unchanged: round-trip tests (native or polyfill)
  invalid-polyfill.test.js  # Polyfill-specific error-message regexes
  invalid-native.test.js    # Native-path error-type assertions only
  _runtime-gate.js          # MIN_NODE_WITH_BASE64_INTRINSIC constant
```

```json
"test": "yarn test:native && yarn test:polyfill",
"test:native":   "ENDO_BASE64_FORCE=native   ava",
"test:polyfill": "ENDO_BASE64_FORCE=polyfill ava"
```

CI matrix runs *both* invocations on every supported Node version.
On Node versions that pre-date the native intrinsics, `test:native`
is skipped via a `process.version` guard. On XS-based runners, both
paths are exercised if XS ships the intrinsics; otherwise only the
polyfill path runs.

## Benchmark

`test/_bench-main.js` already compares `encodeBase64` (dispatched)
against `jsEncodeBase64` (direct). On a runtime with the native
intrinsic, the dispatched function exercises the native code path,
and the benchmark measures native-vs-JS throughput directly. The
NEWS entry uses those numbers to justify the change.
