Done. Here is my completion report.

## Completion report — `fix-ebfb-286-headers-harden-node22`

**Repo/PR:** endojs/endo-but-for-bots #286 (`feat: endo http mk` Phase 1), head branch `feat/cli-http-client-mk-phase-1`.

### Root cause (confirmed, not guessed)
I reproduced the deterministic Node-22 failure locally (Node 22.23.1) and instrumented the exact throw path. `@endo/http-confine`'s `makeHttpConfinement().request()` returned the **live** platform `fetch` `Response` — including its live undici `Headers` — inside the hardened `ConfinedResponse`. The confined result is `harden()`ed, which deep-freezes that live `Headers`. On Node 22, undici only materialises its lazy `Symbol(headers map sorted)` slot on first read; because the object was already frozen, `@endo/exo-http-client`'s `makeHttpResponse` → `headersToRecord` iteration threw `Cannot assign to read only property 'Symbol(headers map sorted)'`. That error rode back over CapTP and re-threw in `decodeErrorFromCapData` on the client — exactly the CI stack. Node 24's newer undici doesn't assign that slot on read, hence 24 was green.

The instrumentation pinpointed it precisely: `confined.response ... frozen=true` → `makeHttpResponse threw Cannot assign to read only property 'Symbol(headers map sorted)'`.

### Fix
`packages/http-confine/src/http-confine.js`: `request()` now snapshots the response into an inert plain `{ status, statusText, ok, url, headers }` record **before** hardening — no live web-platform object crosses the CapTP boundary. Added a `responseHeadersToRecord` helper that copies headers via `Object.defineProperty` (own data props), so prototype-adjacent names (`__proto__`, `constructor`) survive as data rather than mutating the prototype or throwing on frozen SES intrinsics. Verified the only consumer of `ConfinedResponse` reads just those fields plus the already-buffered bytes, so no other live `Response`/`Request` is marshalled.

### Verification (local, Node 22)
- `@endo/daemon` `test/http-client.test.js` — **9/9 pass** (incl. the previously-failing `client request to allowed origin succeeds`)
- `@endo/exo-http-client` — **32/32 pass** (caught + fixed a first-cut regression on prototype-adjacent header names)
- `@endo/http-confine` — **14/14 pass**
- `tsc` + `eslint` clean on the changed package

### Deliverables
- Changeset added: `@endo/http-confine` **patch** (the only published package touched; daemon/exo-http-client unchanged).
- Committed and pushed to the PR head branch (`d08834c37..908b8ac23`).
- Posted a completion comment on PR #286 (as kriscendobot) summarizing root cause, fix, and verification.

### Follow-ups / notes
- No review thread surfaced this (CI-only), so I used a PR completion comment per the norms.
- Env note for future daemon-e2e jobs: the full-daemon test needs a **short** checkout path (unix socket ≤108 chars) and a built `better-sqlite3` (`prebuild-install`); the default long scratch worktree path trips the socket-length guard.
