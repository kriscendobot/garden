Everything is complete and verified. Writing my completion report.

---

## Completion Report: `build-daemon-rename-to-manager`

**Delivered Phase 1 of the daemon→manager rename** (`designs/daemon-rename-to-manager.md`) as a DRAFT PR on `endojs/endo-but-for-bots` base `llm`, per the job's "land Phase 1 first" instruction.

### What I did
- **Renamed 13 files** under `packages/daemon/src/` via `git mv` (the design's *File renames* table): `daemon.js`→`manager.js`, `daemon-node*.js`, `daemon-go*.js`, `daemon-database*.js`, `daemon-persistence-powers.js`, `daemon-webextension.js`, and the four `bus-daemon-*`→`bus-manager-*` files. Left `bus-xs-daemon-polyfills.js` and `test/bench-daemon.js` unchanged (not in the design's table).
- **Updated only path specifiers, no identifiers** (Phase 1 contract). Beyond the design's inventory I found and fixed four build-critical reference sites the design didn't enumerate: the `package.json` `exports` map key, **two `@endo/daemon/src/manager-node-powers.js` deep imports** in `agent-tools`/`agentry` tests (they route through the exports map), the `familiar/src/resource-paths.js` runtime path, and the `bundle-bus-daemon-rust-xs.mjs` bundler source path.
- Diff: **32 files, 13 renames + 19 edits, 48/48 lines**. Confirmed no `Daemon*`→`Manager*` identifier change leaked in (e.g. `makeDaemonDatabase` correctly retained while its import path moved).

### Verification (real execution)
- **`tsc` (daemon `lint:types`): exit 0, clean** — validates every import path resolves and types are consistent.
- **`eslint` on changed daemon files: 0 errors** (95 pre-existing warnings in `manager.js`, none introduced).
- **35 runtime tests passing** across renamed modules: `watch-directory` (11), `mount-platform-fs-conformance` (19, imports `bus-manager-rust-xs-powers.js`), `mount-snapshot-and-entry` (5).
- **Not verified (environmental):** `invite-retention`/`endo` full-daemon-spawn tests fail with `Could not locate the bindings file` — `better-sqlite3`'s native `.node` addon is not compiled in this build sandbox (confirmed absent from all of `node_modules`; node-gyp not wired up). The failure stack shows my renamed modules loading correctly *before* the native-addon load, so it is upstream of and independent of the rename. CI (with the compiled binding) will exercise these; I flagged this on the PR.

### Result
- **DRAFT PR: https://github.com/endojs/endo-but-for-bots/pull/598** (base `llm`, kept DRAFT so review can sequence it against the ~40 in-flight `packages/daemon/*` PRs; PR body offers to park if the maintainer prefers to wait for those to quiesce).

### Follow-ups (parked so intent isn't lost)
- `build-daemon-rename-to-manager-phase2` — identifier renames (`Daemon`/`Daemonic`→`Manager`, `MignonicPowers`→`WorkerPowers`, exo tag) — parked in `plan/` **blocked on #598 merging**.
- `build-daemon-rename-to-manager-phase3` — consumer sweep + `@endo/daemon` CHANGELOG + daemon docs/diagnostic-string mentions — parked **blocked on phase2**.
- These are `plan/`-gated rather than orchestrated because each depends on the prior phase *merging upstream* (a project-repo event the board watchers can't observe); a maintainer/liaison promotes them when #598 lands.
