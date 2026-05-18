---
ts: 2026-05-18T21:07:19Z
kind: result
role: fixer
project: agoric
repo: Agoric/agoric-sdk
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 4
    role: garden-fork
  - repo: Agoric/agoric-sdk
    pr: 12198
    role: source
  - repo: Agoric/agoric-sdk
    issue: 12194
    role: source
refs:
  - entries/2026/05/18/195800Z-message-liaison-12198.md
---

# Result: Stage-1 fixer for the photostructure/sqlite migration

Dispatch A of the maintainer's two-PR gamut. Migrated `packages/swing-store` from `better-sqlite3` to `@photostructure/sqlite` via a new backend-entrypoint module, applying mhofman's three review asks from upstream Agoric/agoric-sdk#12198.

## Deliverable

- PR: <https://github.com/kriscendobot/agoric-sdk/pull/4> (DRAFT)
- Branch: `fix/photostructure-sqlite-backend` on `kriscendobot/agoric-sdk`
- Final head SHA: `8270fb79b76c2ee897da8f18fb4daaed6f1d8637`
- Base: `master`

## Approach

Started fresh rather than cherry-picking from `copilot/switch-to-node-sqlite` (head `728b01765`). The upstream PR was based on a much older master, the adapter approach baked the three findings mhofman flagged into the data path, and the diff contained ~2600 unrelated files from the older base. A clean implementation hits a smaller surface and lets the new module own the binding-swap point Dispatch B needs.

## Files touched

New:
- `packages/swing-store/src/dbBackend.js` (118 LOC) -- backend entrypoint exporting `createDatabase`, `backupDatabase`, `blobToBuffer`.

Modified in `packages/swing-store`:
- `src/swingStore.js` -- `db.inTransaction` to `db.isTransaction`; `serialize()` async via backup; `serialized` Buffer staged to temp file; rollback on close; `enableDefensive(false)` only when entering unsafe-fast-mode; `noteExport` coerces `undefined` to `null`.
- `src/exporter.js`, `src/internal.js` -- swap `better-sqlite3` import for `dbBackend`.
- `src/snapStore.js` -- wrap BLOB reads as `Buffer` via `blobToBuffer` before `Readable.from` (Uint8Array iterates byte-by-byte).
- `package.json` -- drop `better-sqlite3`, add `@photostructure/sqlite ^1.2.1`.

Modified in tests (`packages/swing-store/test/*`):
- All six test files swap `import sqlite3 from 'better-sqlite3'` for `import { createDatabase } from '../src/dbBackend.js'` and use the entrypoint.
- `state.test.js`, `bundles.test.js` `await` the now-async `debug.serialize()`.

Cross-package `await` for the async `debug.serialize()`:
- `packages/SwingSet/test/{transcript,transcript-light,upgrade/upgrade-replay,vat-admin/{replay,terminate/{terminate,terminate-replay}}}.test.js`
- `packages/cosmic-swingset/test/inquisitor.test.ts`
- `packages/boot/tools/supports.ts` (made `makeSnapshot` async) and one caller in `packages/boot/test/bootstrapTests/boot-snapshot.test.ts`.

Root:
- `package.json` -- `dependenciesMeta` swap `better-sqlite3@10.1.0` for `@photostructure/sqlite@1.2.1` (the `built: true` allowlist).
- `yarn.lock` -- separate commit per `skills/yarn-lock-separate-commit/SKILL.md`.

## mhofman's three review asks: how each is addressed

1. **Native `iterate`.** `prepare(sql)` returns the binding's real `StatementSync`, so existing call sites (snapStore, transcriptStore, bundleStore, exporter, swingStore) keep their lazy cursor with no per-row allocation. PR-12198's adapter materialised full result sets up front; this PR does not.
2. **Native `isTransaction`.** Dropped the hand-rolled `inTransaction` counter entirely. The five sites that consulted it (`setUnsafeFastMode`, `ensureTxn`, `commit`, `close`, `internal`) now read `DatabaseSync.isTransaction` directly.
3. **Backup API for DB serialization.** `debug.serialize()` routes through `backupDatabase()` (the binding's `sqlite.backup()` wrapper) to a temp file, reads the bytes back, unlinks the temp file. The companion `{ serialized: Buffer }` option stages the bytes to a temp file before opening. Cross-package callers updated to `await`.

## Test, build, lint status

- `yarn workspace @agoric/swing-store test` (all 11 test files; ava): **85 passed, 0 failed, 0 skipped**. PR-12198's reported state was 76/85 with 2 skipped + 7 failing; this PR brings the 9 untested cases to green.
- `yarn workspace @agoric/swing-store lint:types`: clean.
- `yarn workspace @agoric/swing-store lint:eslint`: clean (10 jsdoc-style warnings, all pre-existing on existing types).
- `yarn constraints`: clean.
- Package `build` script is `exit 0` (no build step).
- Cross-package tests not run in this dispatch (gamut's cleaner / judge stages run the wider matrix).

## Compatibility shape for Dispatch B

The backend entrypoint exposes only what the SQLite contract guarantees on both bindings: `prepare/exec/iterate/isTransaction/close/enableDefensive` plus the `enhance()` overlays (`pragma`, `transaction`, `pluck`, `raw`, `expand`). Replacing the `@photostructure/sqlite` import inside `dbBackend.js` with `node:sqlite` should leave every consumer untouched, modulo whatever experimental-flag and version-floor work Dispatch B owns.

## Native-binding adjustments worth tracking

The binding is stricter than better-sqlite3 in five places that took diagnostic work:

1. `noteExport` binds `null` rather than `undefined` for SQLite NULL. The native bindings reject undefined as unbindable.
2. `setUnsafeFastMode(true)` calls `DatabaseSync.enableDefensive(false)` before `PRAGMA journal_mode=off`. The defensive flag (on by default in the native binding) silently blocks the off-journal-mode PRAGMA.
3. `close()` issues an explicit `ROLLBACK` when a transaction is open. better-sqlite3 rolled back implicitly; the native binding leaves a pending WAL frame that the next connection sees as SQLITE_BUSY.
4. `backupDatabase()` cannot run while the source connection holds a write transaction; `serialize()` commits, backs up, then re-opens the transaction. The IMMEDIATE-from-init pattern in swingStore.js requires this commit-and-restart dance.
5. BLOB reads return `Uint8Array`, not `Buffer`. `Readable.from(Uint8Array)` iterates byte-by-byte yielding unboxed numbers. `blobToBuffer` wraps as a zero-copy view before pipe-through-Readable contexts.

## Self-improvement

Self-improvement: when migrating a SQLite consumer to a node:sqlite-shaped binding, audit five known stricter-than-better-sqlite3 footguns (undefined-binding rejection, defensive-mode PRAGMA blocking, no implicit rollback on close, backup-vs-write-transaction conflict, Uint8Array vs Buffer for BLOBs) before assuming the migration is mechanical. This belongs in a project-context note for `agoric-sdk` (or a dedicated skill if other gardens hit it).
