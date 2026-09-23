Everything is complete. Inbox empty, PR #749 is open in draft against the frozen base.

## Completion report

**Job:** Build Phase 1 (Grammar and duality) of `endo-content-locators-magnet-urn` in `endojs/endo-but-for-bots`.

**What I did**
- Implemented the content-locator grammar and parse/format duality in `packages/daemon/src/locator.js`, mirroring the transport-side `externalizeId` / `internalizeLocator` that already live there:
  - **`parseContentLocator`** — strict `magnet:` URN validator returning `{ hash, kind, displayName, byteLength, sources }`. `xt` accepts `urn:endo-blob:{sha256hex}` / `urn:endo-tree:{sha256hex}` (reusing the existing 64-hex content-address shape via `isValidNumber`); `dn`/`xl` are descriptive; registered source parameters are `ws`/`xs`/`as`/`tr`. Rejects unknown params, duplicate scalars, malformed `xt`, non-integer `xl`, and non-URN magnets — matching `parseLocator`'s strictness.
  - **`formatContentLocator` / `externalizeContent(hash, kind, sources?, details?)`** — mint a magnet URN; `xt` keeps literal colons, `dn` and source payloads are URL-encoded so reserved characters (`&`, `=`) round-trip. No sources ⇒ `xt`-only URN (the empty-`@planes` analogue).
  - **`internalizeContentLocator`** — returns `{ hash, kind, sources }` for the fetch layer; plus `assertValidContentLocator` and `sourcesFromContentLocator`.
  - Local module `@typedef`s only (no inline `import()` JSDoc, no exported inline typedefs — house-style clean).
- Added round-trip and rejection tests to `packages/daemon/test/locator.test.js` (17 new cases; **40 total pass**).

**Verification (all run, observed)**
- `yarn ava test/locator.test.js` → 40 passed.
- `tsc` (daemon `lint:types`) → 0 errors. `eslint` → 0 errors (5 pre-existing style warnings matching the file's existing `any`-cast pattern). `prettier --check` → clean.
- **Regression evidence:** disabling source collection in `parseContentLocator` failed exactly the 3 source-dependent tests (source-order, round-trip-with-sources, reserved-char round-trip); reverted → 40 pass again.
- Gate compliance: removed `// ----` comment banners, no PR-number citations in code, full-word identifiers throughout.

**Scope discipline:** grammar + duality only — no network, no `@planes`/registry, no interface methods (Phases 2–4 deliberately not built).

**What changed / handoff**
- Draft **PR #749** (`endojs/endo-but-for-bots`), head `build/endo-content-locators-grammar-duality`, base frozen `llm-cce5f61` (snapshot of `origin/llm`), committed under the bot identity. Base is `llm` (not `master`) because the transport duality this mirrors, and the design itself, exist only on `llm`; the patch is built against it.
- The auto-gauntlet (clean → panel → fix-loop → un-draft) follows on the open draft PR under fleet supervision.

**Follow-ups:** Phases 2–5 remain (interface methods, `@planes` + `getAllContentSources`, the HTTP web-seed plane, the verification gate/fallback), each its own build.
