---
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: **Status: Not Started** upstream. Third member of the vetted-shim-or-ponyfill family alongside `hardened-url-shim` (`hurl`) and `hardened-text-codecs-shim` (`htcs`); distinguished from those two by providing a *ponyfill* (JS fallback) when the native intrinsic is absent rather than degrading silently. Sibling design `@endo/hex` applies the identical detection-and-capture pattern to the hex intrinsics, so the two packages end up structurally isomorphic. Heavy consumer: every CapTP byte that flows through `endoZipBase64` or `@endo/exo-stream` framing.
---

> Abstract: Make `@endo/base64` dispatch to native `Uint8Array.fromBase64` / `Uint8Array.prototype.toBase64` (TC39 stage 3) when present, fall through to the existing JS polyfill when absent, without changing the package's public API or observable behavior for any well-formed input. Detection happens at module load via `typeof` feature tests for each direction independently; captured references at module top-level survive `lockdown()`, so post-lockdown mutation cannot redirect the dispatch. Native option bag is configured to match the polyfill's longstanding defaults: `alphabet: 'base64'`, `omitPadding: false`, `lastChunkHandling: 'strict'`. Module layout splits the dispatch (`encode.js`, `decode.js` at the package root) from the polyfill (`src/encode.js`, `src/decode.js`) and adds `src/native.js` for the intrinsic adapters. Error semantics widen from `Error` only to `Error | SyntaxError` for malformed inputs; no monorepo consumer regex-matches the polyfill's messages, so this is observed but tolerated; tests are split into polyfill-message-specific and native-error-type-only files, gated by `ENDO_BASE64_FORCE` env-var. Nine design decisions, three S-sized phases, six known gaps to close before merging. The `name` parameter of `decodeBase64` is silently ignored on the native path. The `globalThis.Base64` XS-specific fallback is *kept* as a second fallthrough before the pure-JS polyfill.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-detection-strategy](../sections/endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy.md) | tooling, hardened-javascript | current |
| [module-layout-and-option-mapping](../sections/endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping.md) | tooling, hardened-javascript | current |
| [error-semantics-and-test-strategy](../sections/endo-but-for-bots--llm-designs-b64nf--error-semantics-and-test-strategy.md) | tooling, testing | current |
| [decisions-rollout-and-known-gaps](../sections/endo-but-for-bots--llm-designs-b64nf--decisions-rollout-and-known-gaps.md) | tooling, hardened-javascript, bundles | current |

## See also

- `hardened-url-shim.md` (`hurl`) and `hardened-text-codecs-shim.md` (`htcs`) — siblings in the vetted-shim family; both lack a JS-polyfill fallback (degrade silently on absence) where this design provides one
- `@endo/hex` (sibling parallel proposal, not yet ingested) — same ponyfill-shim pattern applied to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`
- `daemon-message-streaming` and `platform-fs` (not yet ingested) — heavy consumers of `encodeBase64` / `decodeBase64`
