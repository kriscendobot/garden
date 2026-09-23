PR #592 opened as DRAFT. The extraction is complete and verified. Let me write the completion report.

Completed the extraction. Here is the report:

## Job complete: factor `watchDirectory` into `@endo/platform`

**PR:** [endojs/endo-but-for-bots#592](https://github.com/endojs/endo-but-for-bots/pull/592) (DRAFT, base `llm`, bot identity `endolinbot`) — follow-up to #277 as @kriskowal requested.

### What I did
Wore designer (extraction delta) then builder. The primitive that #277 landed inside `makeFilePowers` had node `fs` as its only ambient dependency and `@endo/platform` already carries the node-fs adapters, so it moved there.

**Changes (one commit, 70d4248f9):**
- **New adapter** `packages/platform/src/fs-node/watch-directory.js` — `makeWatchDirectory(fs)` returning the verbatim `(dirPath) => { events, cancel }` watcher: buffered push/pull async-iterable, 50 ms per-filename debounce/coalesce, `{ kind, name }` hint events, idempotent `cancel()`/`return()`, and the `fs.watch`-unavailable → terminated-stream fallback.
- **Exports** — `makeWatchDirectory` re-exported from `@endo/platform/fs/node` (`src/fs-node/index.js`) plus a dedicated subpath `@endo/platform/fs/node/watch-directory` added to the package's export map.
- **Daemon delegates** — `makeFilePowers` now does `const watchDirectory = makeWatchDirectory(fs);` (imported from the new subpath). The `FilePowers.watchDirectory` surface is byte-for-byte identical, so `mount.js` / `EndoMount.followNameChanges`, `types.d.ts`, and the XS-powers stub are all untouched. Removed the now-197-line inline body and the two now-unused `setTimeout`/`clearTimeout` globals.
- **Tests moved** — the 11 unit tests moved from `packages/daemon/test/watch-directory.test.js` to `packages/platform/test/watch-directory.test.js`, retargeted at `makeWatchDirectory` and adapted to the platform `@endo/init/debug.js` + `ava` harness. Daemon keeps the end-to-end `followNameChanges` integration coverage.
- **Changeset** — `@endo/platform: minor`, `@endo/daemon: patch`.

Daemon already depended on `@endo/platform` (workspace), so no new dependency wiring was needed.

### Verification (all run in my isolated worktree)
- `@endo/platform` unit tests: **11/11 pass** — `node ava test/watch-directory.test.js`.
- `@endo/daemon` `mount.test.js`: **73/73 pass**, including `followNameChanges yields existing entries as the initial snapshot` (exercises the delegated path end-to-end).
- `tsc` (lint:types): **exit 0** on both `@endo/platform` and `@endo/daemon`.
- `eslint`: **exit 0** on all changed files (daemon file shows only 3 pre-existing `safe-await-separator` warnings in unrelated functions at lines 308/393/447).
- Runtime resolution of `@endo/platform/fs/node/watch-directory` from the daemon package confirmed (`makeWatchDirectory` export present).

Behavior is invariant — this is a pure extraction/refactor.

### Follow-ups (explicitly out of scope, per #277 and the design)
- Per-path `pubsub` multiplexing to share one watcher across subscribers.
- `NameHubInterface` cross-interface unification.
- The DRAFT PR is ready to run the gamut (cleaner → judge → fixer-loop → un-draft); CI note: `ci.yml` does not run on `llm`-targeted PRs in this fork, which is why I ran the suites locally.
