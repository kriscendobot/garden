---
ts: 2026-06-03T22:38:24Z
kind: result
role: builder
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--a5da82/project
---

Phase 11b of the Endo Gateway stack (#343) lands: CAS-fetch for
Host-header weblets. DRAFT PR [#420](https://github.com/endojs/endo-but-for-bots/pull/420)
opens against phase-11 head (`design/gateway-package-phase-11`).
Branch: `design/gateway-package-phase-12`.

## What ships

- `packages/gateway/src/weblet-fetch.js` (new): pure
  `fetchWebletResponse` module + `normalizeWebletPath` helper.
  Takes a `ServeWeblet` adapter and a request descriptor; maps
  the adapter's disjoint-union result (`200` / `304` / `404`) onto
  a response shape with status, headers, and an optional body
  reader. Normalizes the bare-root case to `/index.html`. Threads
  `If-None-Match` through. Fails-closed on every malformed
  adapter return (missing contentType, missing etag, missing
  body reader, non-object result, unsupported status, broken
  size); a `ServeWeblet` throw maps to 500 with a fixed body and
  a logged warning.
- `packages/gateway/src/http-listener.js`: the Host-header branch
  now dispatches into `weblet-fetch.js` when a `serveWeblet`
  power is wired. When absent, it preserves the Phase-11a 501 +
  `X-Endo-Weblet-Formula` placeholder for back-compat. The 200
  path streams the adapter's body reader chunk-by-chunk to the
  response; an in-flight body throw triggers `res.destroy(err)`.
  `ForwardedRequest` is threaded into the adapter's args.
- `packages/gateway/src/types.d.ts`: new typedefs
  `ServeWebletArgs`, `ServeWebletOk`, `ServeWebletNotModified`,
  `ServeWebletNotFound`, `ServeWebletResult`, `ServeWeblet`.
  `GatewayPowers` gains an optional `serveWeblet` field.
- `packages/gateway/index.js`: threads `powers.serveWeblet` to
  `makeHttpListener` at start. Re-exports the new module's
  helpers (`fetchWebletResponse`, `normalizeWebletPath`,
  `CONTENT_ADDRESSED_CACHE_CONTROL`, `INTERNAL_SERVER_ERROR_BODY`).
- `packages/gateway/package.json`: new `./src/weblet-fetch.js`
  export entry. No new dependencies; no yarn.lock churn.

## Tests

- `packages/gateway/test/weblet-fetch.test.js` (new): 22 unit
  tests on the pure module. Coverage: status/header/body mapping
  for 200/304/404, bare-root normalization (`/` and `''` both map
  to `/index.html`), double-slash collapse, trailing-slash
  preservation, ETag handling, `If-None-Match` threading,
  fail-closed on every malformed result shape, forwarded
  threading, seam guards (empty formulaId, missing power).
- `packages/gateway/test/http-listener.test.js`: 10 new tests
  layered on the existing 16. Integration through a live
  `node:http` server: streaming body with Cache-Control + ETag,
  bare-root path normalization end-to-end, 404 path,
  `If-None-Match` -> 304 round-trip, `serveWeblet` throw -> 500
  with logged warning, MIME-type echo, missing-power fallback to
  501, missing-size Content-Length omission, broken-contentType
  -> 500 (fail-closed), `makeGateway(powers.serveWeblet=...)`
  smoke test.

Full gateway suite: **503 tests pass** (471 pre-existing + 22 new
weblet-fetch + 10 new in http-listener).

Regression evidence: mutating the `serveWeblet` branch in the
listener to skip the new path fails 9 of the new integration
tests (manually verified before commit).

## Notable design choices

- **`serveWeblet` is a composite power.** Rather than expose
  three separate daemon-side adapters (resolve-formula,
  fetch-content-tree, cas-fetch-stream), the gateway-side power
  encapsulates the whole resolution chain behind a single
  `{webletFormulaId, pathSuffix}` -> result call. Daemon
  embedders that want the primitives separately wrap them at
  the gateway-power seam. This matches the dispatch's "scope
  Phase 11b to the gateway-side serveWeblet shape with the
  daemon side as a separate stacked PR" resolution of
  researcher's Open Question 3.
- **Cache-Control: public, max-age=31536000, immutable on every
  200.** The content-addressed semantics make every successful
  response effectively immutable: a different content under the
  same ETag is impossible by construction. RFC-8246 clients
  that honor `immutable` skip even the conditional revalidation
  round-trip. The directive is exported as the
  `CONTENT_ADDRESSED_CACHE_CONTROL` constant so tests assert on
  the exact string.
- **mimeTypes mapping is daemon-side.** The adapter resolves the
  contentType (applying the `WebletFormula.mimeTypes` mapping)
  and the gateway echoes it verbatim. Splitting the
  responsibility would force the gateway to dereference the
  formula independently of the body fetch, doubling the
  daemon-side round-trips.
- **501 fallback preserved when serveWeblet is absent.** The
  Phase-11a placeholder posture (501 +
  `X-Endo-Weblet-Formula`) stays the default until a daemon-side
  adapter lands. Embedders that have not wired a `serveWeblet`
  power observe the same routing behavior as Phase 11a.
- **In-flight body throw -> res.destroy(err).** Headers are
  already sent by the time the body reader yields; a thrown
  read leaves the response unrecoverable. The cleanest client-
  observable signal is a connection drop; the alternative
  (writing a partial body and pretending it is the whole) is
  worse.

## Researcher's Open Question 3 resolution

`UserDaemon.fetchContentTree` does **not** exist on the daemon
today. Per the dispatch's pre-stated scoping decision, the
gateway-side `serveWeblet` power abstracts the daemon-side
decomposition into a single composite adapter; the
daemon-side adapter implementation (formula-graph resolver,
readable-tree walker, CAS-blob streamer) is a separate stacked PR.

## What's next

- Phase 11c (daemon-side adapter): wire a `serveWeblet` power
  implementation in the daemon. The daemon needs:
  1. A way to dereference a `weblet` formula identifier through
     the formula graph and recover the `WebletFormula` shape.
  2. A way to walk the `contentRoot` `readable-tree` by a
     path-suffix and return a `readable-blob` (or 404).
  3. A way to stream the blob bytes from CAS as a
     `Reader<Uint8Array>`.
  4. The mimeTypes application: read the formula's `mimeTypes`
     mapping and resolve the content-type by file extension,
     falling back to `application/octet-stream`.
  Compose those into a `ServeWeblet` adapter and wire it
  through the daemon's gateway-powers seam.
- Phase 11d (flip the toggle on): once Phase 11c lands and the
  daemon's `web-server-node.js` callers migrate, flip
  `enableFeatures.httpListener` default to true and retire the
  override.
- SSR-handler invocation on 404 (design § Feature 2's "dynamic
  fallback path"): the current 404 from the adapter is final;
  the adapter could chain into the formula's `ssrHandler`
  internally but the gateway-side wiring for the SSR exo on
  miss is a separate consideration.

Self-improvement: nothing this time.
