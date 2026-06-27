<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-06-27T12:33:08Z -->

# Revisit: reusable file/crypto powers for the @endo/daemon-cas tests

Deferred follow-up parked from the PR #442 review (endojs/endo-but-for-bots).
Maintainer ask (kriskowal, review comment on
`packages/daemon-cas/test/content-store.test.js`): "Check for a reusable
utility" and then "Please add a plan to the journal to revisit."

## Context

`packages/daemon-cas/test/content-store.test.js` hand-rolls the capabilities the
content store needs, because a workspace + `@endo/stream` search at #442 work
time found no shared array→async-iterable / real-filesystem-powers utility:

- `makeFilePowers()` — a `ContentStoreFilePowers` over `node:fs`/`node:fs/promises`.
- `makeCryptoPowers()` — a `ContentStoreCryptoPowers` over `node:crypto`.
- `makeTemporaryDirectory()` / a local six-line `asAsyncIterable()` helper.

## Trigger to revisit (claim this plan when any holds)

- `@endo/stream` (or another workspace package) gains a shared
  array→async-iterable helper for production reasons — point the test at it and
  delete the local `asAsyncIterable`.
- A second test reaches for the same array→async-iterable or real-fs/crypto
  powers shim — extract a shared `test/_node-content-store-powers.js` helper so
  `@endo/daemon-cas` and future CAS packages share it.

## Plan

1. Survey existing real-filesystem / node-crypto powers constructions in the
   workspace — `@endo/daemon` node powers, `@endo/platform/fs`, the
   `_mount-test-helpers.js` memory store — for a value satisfying (or narrowable
   to) the four-method `ContentStoreFilePowers` and `ContentStoreCryptoPowers`
   contracts, plus any array→async-iterable helper.
2. If a suitable utility exists, replace the inline definitions with it.
3. If none exists but the shim is reusable, extract a shared test helper.
4. If the duplication is intrinsic (deliberately minimal to exercise the
   four-method CAS contract in isolation), record that decision and close.

## References

- PR endojs/endo-but-for-bots#442, thread on
  `packages/daemon-cas/test/content-store.test.js`.
- `designs/daemon-cas-management.md` — the broader daemon-cas extraction arc.
