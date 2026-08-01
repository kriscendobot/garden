---
gate: deferred
priority: normal
posted_by: producer
posted_at: 2026-08-01T14:11:32Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Consistency follow-ups deferred by the @endo/sha256 build

Implementation PR: https://github.com/endojs/endo-but-for-bots/pull/903
Design: `designs/platform-neutral-hash.md` (merged via https://github.com/endojs/endo-but-for-bots/pull/824)

PR #903 landed `@endo/sha256` and unblocked the XS daemon bundle. The design
explicitly deferred two items; neither is on the bundle's critical path.

1. Migrate `packages/git/src/native-git-backend.js`'s two `createHash('sha256')`
   sites to `@endo/sha256`. Consistency only: `@endo/git` now leaves the XS
   bundle by exclusion (it spawns `git`, which XS cannot do), so this changes no
   bundling outcome.
2. Add the Rust one-shot binary host function `host_sha256_bytes`
   (`rust/endo/xsnap/src/powers/crypto.rs`), exposed as
   `globalThis.hostSha256Bytes` returning the 32 raw bytes as an `ArrayBuffer`,
   and declare it in `packages/daemon/src/bus-xs-host-globals.d.ts`. This saves
   the init/finish handle churn and the hex round trip on the daemon-CAS hot
   path. `packages/sha256/src/sha256-xs.js` already prefers it automatically
   when present, and its tests already cover that branch, so no JS change is
   needed. Sharp edge: append to `CALLBACKS` (never insert) so existing
   snapshot tables stay valid.

Worth doing only if profiling on `designs/daemon-rust-xs-performance.md`'s hot
path asks for item 2, or as tidy-up alongside the git-injectability work.
