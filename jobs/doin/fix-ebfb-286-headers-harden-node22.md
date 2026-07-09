---
role: fixer
---

# Fix: PR #286 http-client fails on Node 22 — hardened undici Headers breaks CapTP error-decode

**Repo:** endojs/endo-but-for-bots
**PR:** #286 (`feat: endo http mk` Phase 1) — https://github.com/endojs/endo-but-for-bots/pull/286
**Base:** the PR's base (`llm`); work on the PR's head branch.

## The failure (deterministic, not flaky/infra)

Full-daemon e2e test **`@endo/daemon › http-client › client request to allowed
origin succeeds`**:
- **FAILS** on Node 22.x (ubuntu-latest AND macos-15) — deterministic, both OSes.
- **PASSES** on Node 24.x.
All other checks green (lint, build, browser-tests, coverage, test262, xs, hermes,
sandbox-drivers, ws-relay).

## Root cause (from the CI log)

```
TypeError: Cannot assign to read only property 'Symbol(headers map sorted)'
  of object '[object Object]'
    at decodeErrorCommon (packages/marshal/src/marshal.js:316:24)
    at decodeErrorFromCapData ... fromCapData ... CTP_RETURN (captp)
    ... packages/daemon/src/connection.js:192
```

The daemon-side http request returns an **error that carries a whatwg `Headers`
object**. undici's `Headers` on Node 22 caches a lazy internal
`Symbol(headers map sorted)` slot; SES `harden()` freezes the object, so when the
client decodes the error across CapTP it cannot reconstruct/rewrite that internal
slot and throws. Node 24's undici changed the internal so it no longer trips —
which is why 24 is green and 22 is red. The defect is inside the new http-client
feature introduced by #286.

## Direction for the fix

Do **not** marshal/harden a live `Headers` object across the CapTP boundary.
Normalize headers to plain data before they cross — e.g. `Object.fromEntries(headers)`
or an array of `[name, value]` entries — so the error (and any response) carries
inert header data, not a live undici object with lazy frozen internals. Apply at
the point the daemon-side http error/response is constructed before it is returned
over CapTP (trace from `packages/daemon/src/connection.js:192` /
`decodeErrorFromCapData`). Confirm no other live web-platform objects (Response,
Request) are being marshalled the same way.

## Definition of done

- The Node-22 e2e test `client request to allowed origin succeeds` passes on both
  ubuntu and macos.
- No regression on Node 24.
- local-verify + CI green; changeset added if the fix touches a published package.
- Reply on the PR review thread that surfaced this (or a completion comment)
  summarizing the fix, per review-feedback-followup norms.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 14
  claimed_at: 2026-07-09T22:52:15Z
