---
ts: 2026-06-18T08:05:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/080500Z-result-fixer-c349b9.md
---

Addressed kriskowal inline comment 3433946262 on PR #442
`packages/daemon-cas/src/content-store.js`.

## Summary

The reviewer noted that `makeDaemonContentStore` encodes daemon configuration
opinions (the `<statePath>/store-sha256/` path derivation and the
`makeSnapshotStore` wrap) that do not belong in the CAS package.

Moved those opinions to `daemon-persistence-powers.js`, which already owns the
daemon's `Config.statePath`.  The CAS package now exports only the generic
`makeContentStore` factory; `DaemonContentStoreOptions` type and the
daemon-shaped test case were removed from `@endo/daemon-cas`.

## Commits

- pre-head SHA: `3b427cf2c`
- `f4bcaf70c` refactor(daemon,daemon-cas): move daemon-specific content-store
  config from daemon-cas to daemon
- `952f7cb0f` chore: Update yarn.lock
- post-head SHA: `952f7cb0f`

## Files modified

- `packages/daemon-cas/src/content-store.js`: removed `makeDaemonContentStore`
  and its `makeSnapshotStore` import; removed `DaemonContentStoreOptions`
  @import
- `packages/daemon-cas/index.js`: removed `makeDaemonContentStore` export
- `packages/daemon-cas/types.d.ts`: removed `DaemonContentStoreOptions`
  interface and `makeDaemonContentStore` function declaration
- `packages/daemon-cas/test/content-store.test.js`: removed the
  `makeDaemonContentStore` test case (daemon-specific path opinion belongs with
  daemon tests)
- `packages/daemon/src/daemon-persistence-powers.js`: inlined path derivation
  (`joinPath(config.statePath, 'store-sha256')`) and `makeSnapshotStore` wrap;
  now imports `makeContentStore` from `@endo/daemon-cas` and `makeSnapshotStore`
  from `@endo/platform/fs/lite`

## Test results

- `corepack yarn workspace @endo/daemon-cas test`: 8 tests passed
- `corepack yarn workspace @endo/daemon test`: all tests passed (exit 0)

## Pre-push-gates result

`yarn format` auto-fixed 6 paths and re-staged them.  `yarn lint` and probe
failures (`filename-no-stutter`, `no-ascii-banners`, `no-inline-import-jsdoc`,
`sentence-per-line-md`, `security-md-hash-uniform`, `test-package-no-main`)
are all pre-existing at HEAD before this change; confirmed by running the gate
on a stash of the working tree.  No new findings introduced by this refactor.

## Inline reply

Reply posted on comment 3433946262:
https://github.com/endojs/endo-but-for-bots/pull/442#discussion_r3434159891

Citing commit `f4bcaf70c` and the location of the moved logic.

Self-improvement: when a refactor removes an item from a CAS-style package's
public API, the test file for that package needs to remove the corresponding
import and test case; the pattern "remove export -> remove type -> remove test
import" is a three-step that is easy to miss one step of.

next: liaison
