---
title: Nine design decisions, three-phase rollout, and the open known-gaps list
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript, bundles]
status: current
---

## Nine design decisions

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

## Three-phase rollout (all S-sized)

| Phase | Scope |
|---|---|
| **Phase 1 — Module restructuring** | Split dispatch out of `src/encode.js` and `src/decode.js`. Drop the `globalThis.Base64` inline check. Move dispatch to top-level `encode.js`/`decode.js`. Add `src/native.js` and `src/select.js`. `harden` every named export. Full test suite continues to pass on both paths. **No public API change**; no version bump beyond patch. |
| **Phase 2 — Test split and CI matrix** | Rename `test/main.test.js`'s "invalid encodings" into `test/invalid-polyfill.test.js`. Add `test/invalid-native.test.js`. Add `package.json` scripts `test:native` / `test:polyfill`; default `test` runs both. Add `_runtime-gate.js` with the minimum Node version constant. CI runs both paths on all supported Node versions that ship the intrinsic. |
| **Phase 3 — NEWS and documentation** | `CHANGELOG.md` minor-version entry with the native fallthrough, the unchanged API, and the loosened error-message contract. `README.md` short section noting ponyfill status and the runtime floor for the native path. Benchmark numbers on one representative Node version go into the NEWS entry. |

## Known gaps (open at time of writing)

The design lists five open knowns for follow-up:

- **Minimum Node version**: confirm the floor that ships
  `Uint8Array.fromBase64` and record it in `_runtime-gate.js`. As
  of writing, Node 22 ships it; verify against the current
  `engines.node` floor in the monorepo root.
- **SES interaction**: confirm `ses` under `lockdown` does not
  attenuate or remove `Uint8Array.fromBase64`. If it does, the
  module can still capture the reference pre-lockdown, but the test
  suite needs a `lockdown`-on path to verify.
- **Benchmark numbers**: publish throughput for at least one short-
  string workload and one megabyte-scale workload, native and
  polyfill, on one representative Node version.
- **Shared `select.js`**: decide whether `@endo/hex` and
  `@endo/base64` share a single `select.js` or each carry their own
  (~10 lines duplicated vs. a cross-package dependency).
- **Drop `globalThis.Base64` XS path**: requires confirming no
  supported Endo runtime lacks `Uint8Array.fromBase64` while
  providing `globalThis.Base64`.
- **`name` parameter deprecation**: lift to a formal deprecation in
  a future major version? Continues to be accepted-and-ignored on
  the native path today.

The known-gaps list is exhaustive — the design's "what we still need
to confirm before merging" surface. Future readers picking up the
design should treat the bullets as gating items, not optional polish.

## API compatibility summary

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
