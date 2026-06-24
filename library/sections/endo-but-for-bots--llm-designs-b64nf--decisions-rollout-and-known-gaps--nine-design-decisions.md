---
title: Nine design decisions
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

| # | Decision | Why |
|---|---|---|
| 1 | **Detect once, close over references.** | Intrinsic lookup happens at module load and is captured in a local binding before any caller can reach `encodeBase64`. Post-lockdown mutation cannot redirect. Same pattern as `Object.freeze` / `Array.prototype.push` captures elsewhere in Endo. |
| 2 | **Feature-test `toBase64` and `fromBase64` independently.** | A realm that ships only one — unlikely but cheap to guard — still works correctly. Neither direction falsely claims the other. |
| 3 | **Preserve `jsEncodeBase64` / `jsDecodeBase64` as named exports.** | For benchmark use, for forced-polyfill testing, and so any downstream pinned to the polyfill's exact error messages can continue to import directly during migration. |
| 4 | **Loosen the error-message contract.** | The polyfill-internal regexes have no consumer. Re-throwing every native `SyntaxError` is either free (happy path) or pure cost (error path) with no benefit. CHANGELOG documents the loosening. |
| 5 | **Ignore the `name` parameter on the native path.** | Native error messages don't include it. Silently accepting and ignoring preserves the function signature; no caller becomes a type error. |
| 6 | **`ENDO_BASE64_FORCE` is test-only, env-driven.** | A `globalThis` switch would be a capability leak. An import-time flag would force every consumer to decide the path. An env variable keeps the affordance out of production code. |
| 7 | **No `base64url` alphabet in this change.** | `@endo/base64` has only ever supported RFC 4648 §4. Adding `base64url` would widen the API surface and is out of scope here. |
| 8 | **No `omitPadding` option exposed.** | The package has always emitted padding. Changing that is a separate API decision. |
| 9 | **Do not remove the `globalThis.Base64` XS path entirely.** | Earlier XSnap builds still ship `globalThis.Base64` and no native `Uint8Array.fromBase64`. The dispatch in `src/native.js` may fall through a *second* time to `globalThis.Base64.encode` / `globalThis.Base64.decode` before selecting the pure-JS polyfill. The `adaptDecoder` for the `ArrayBuffer`-returning case is preserved. |

Decisions 7, 8, and 9 are the *scope rejections* — explicitly deferred
work that this design records for downstream readers.
