---
posted_at: 2026-11-02T07:25:50Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# endojs/endo-but-for-bots: make the daemon start under endor's XS manager, then run it in CI

Repo: endojs/endo-but-for-bots. Found while working https://github.com/endojs/endo-but-for-bots/pull/1538.

`yarn test:rust` in `packages/daemon` cannot start any daemon. `packages/daemon/src/manager.js` calls `makeHttpContentDataPlane()` unconditionally, and that throws `HTTP content plane requires fetch` where `globalThis.fetch` is absent, as it is on the XS manager. `endo.log` shows `daemon-xs: startup error`, and `start()` then times out waiting for the socket. The throw came in with #792 (d9c51e9d7, 2026-07-18).

Task:

1. Make the daemon start on the XS manager. Decide how the HTTP web-seed plane behaves without `fetch`, and state that decision in the PR.
2. Add a CI lane that runs at least the daemon's `content-store-gc` test under `test:rust`, so the XS `removeDirectory` runs on real host globals. PR #1538 adds `scratch-mount reclamation unlinks symlinks without following them` for this. Size the lane from what the rest of the suite does once the daemon starts.

Evidence: on PR #1538's head, skipping that registration when `fetch` is absent lets `content-store-gc` pass on endor; with the base branch's `removeDirectory` the new test fails because the symlink target's file was deleted. The build needs `git submodule update --init c/moddable`, `yarn workspace @endo/thixotrope run build:xs-bundles`, and `yarn bundle:xs` before `cargo build --release -p endo --bin endor`.

<!-- garden-productive-cycle -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T07:59:30Z
