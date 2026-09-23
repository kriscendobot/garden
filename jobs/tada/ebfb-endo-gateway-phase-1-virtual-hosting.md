Inbox empty. The build is complete and all gates pass.

## Completion report

**Job:** `ebfb-endo-gateway-phase-1-virtual-hosting` — @endo/gateway Feature 2 (virtual hosting), Phase 1.

**Opened:** DRAFT PR **[endojs/endo-but-for-bots#578](https://github.com/endojs/endo-but-for-bots/pull/578)**, base `llm`, head branch `gateway-vhost-phase1`, head SHA **`93c7e68e261a7ffc4ce43bae88f658daa68957af`**. Bot identity (endolinbot), direct push to the bot fork. No upstream-of-endo contact.

**What landed** (the design § Feature 2, steps 1–5, on top of the #343 `AppsNameHub` skeleton):
- **`types.d.ts`** — new `WebletFormula` (`type`/`contentRoot`/`mimeTypes?`/`ssrHandler?`/`virtualHosts?`), `FormulaIdentifier`, `WebletReadable`, `WebletContentTree`, `GatewayContentResolver`, `ServeResult`, `WebletResolver`; `GatewayPowers` extended with an injected `content` capability; `Gateway` gains `getWebletResolver()`.
- **`src/serve.js`** — `makeWebletResolver({ apps, content })` hardened exo: routes `Host` through `@apps` → resolves the weblet formula → normalizes/bounds the request path (default `index.html`, traversal-safe) → resolves the content tree against the content-addressed `contentRoot` through a **CAS read-through cache** that fetches each root at most once (in-flight-promise dedupe, evict-on-reject) → serves bytes with MIME overrides applied/inferred.
- **`src/mime.js`** — per-extension inference with override support and octet-stream fallback.
- **`index.js`** — wires the resolver into `makeGateway` when `powers.content` is supplied; re-exports the surface.
- **Tests** (`test/serve.test.js`, `test/mime.test.js`) — hit, cache populate (single + concurrent), MIME override vs inference, unknown-Host 404, missing-file/directory 404, traversal 404, the SSR seam, and the `makeGateway` powers-injection path. Plus a changeset (`@endo/gateway` minor).

**Quality gates** (run directly via `node`, per the sandbox bin-shim constraint): `tsc` clean; type-coverage 98.79% (≥95%); `eslint .` clean (0 errors, 0 warnings, including the Jessie `safe-await-separator`); **73 ava tests pass**; prettier `--check` clean.

**Left as named follow-on seams** (out of scope, not pulled in): the **SSR dynamic-fallback** handler (`ssrHandler` → `UserDaemon.handleHttp`, Feature 4 / Phase 2) returns a visible `501 ssr-not-wired` rather than forwarding CapTP; **Feature 8** (`/ocapn-cbor-np` WebSocket subprotocol); and **daemon `@apps`-formula wiring** to import `@endo/gateway` (the Phase-1 integration step) — this PR stays package-local.

**Follow-ups:** the DRAFT runs the normal gamut (cleaner → judge → fixer-loop → un-draft) as a separate concern. The temporary project worktree was removed.

Self-improvement: nothing this time.
