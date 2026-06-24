---
ts: 2026-05-18T20:22:39Z
kind: result
role: fixer
project: agoric
repo: kriscendobot/agoric-sdk
worktree: dispatches/fixer--61b0de/project
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: opened
  - repo: Agoric/agoric-sdk
    pr: 12198
    role: source
  - repo: Agoric/agoric-sdk
    issue: 12194
    role: source
refs:
  - entries/2026/05/18/195800Z-message-liaison-12198.md
---

# Stage 1 of the agoric-sdk node:sqlite gamut: fixer dispatch B

## Deliverable

- **PR**: [kriscendobot/agoric-sdk#3](https://github.com/kriscendobot/agoric-sdk/pull/3), DRAFT.
- **Title**: `chore(swing-store): migrate from better-sqlite3 to node:sqlite (built-in)`.
- **Head**: `025859930cc40b525fed2cd438186c728e8f4441` on branch `fix/node-sqlite-builtin`.
- **Two commits**: implementation (`40445d90c9`) + `chore: Update yarn.lock` (`025859930c`), per `skills/yarn-lock-separate-commit/SKILL.md`.

## Node.js version decision

Raised `packages/swing-store/package.json` engines floor from `^20.9 || ^22.11` to `^22.16 || ^24.0` (swing-store only; the wider monorepo's floor is unchanged). `node:sqlite` was added in Node 22.5 behind `--experimental-sqlite`, stabilized for no-flag use in 22.16 (the runtime still emits an `ExperimentalWarning` on 22.x but the module loads), and is fully stable in Node 24. The maintainer's directive ("Node.js 22 and 24 going forward") authorized the floor bump; preferring it over threading `--experimental-sqlite` through scripts / ava configs / swingset workers / CI workflow steps because the flag-thread surface is wider and the directive named the floor as the cleaner choice.

CI-matrix consequence: the existing `test-all-packages.yml` matrix runs swing-store tests against both `node-old` (Node 20) and `node-new` (Node 22); under this PR the `node-old` row is expected to fail for swing-store because the engines floor excludes Node 20. The PR body surfaces three options for the maintainer (drop Node 20 monorepo-wide; gate the swing-store test step on `node-new`; accept the red `node-old` entry as the floor-bump signal).

## Implementation

- **New backend-entrypoint module** `packages/swing-store/src/sqliteBackend.js`. Centralizes SQLite construction so the rest of the package is driver-agnostic and the future driver swap (or the sibling `@photostructure/sqlite` dispatch) is a one-file change. The module's `makeDatabase` wraps `node:sqlite`'s `DatabaseSync` with the `better-sqlite3`-shaped API the package historically used: `statement.pluck/raw/bind`, `database.pragma`, `inTransaction` alias for `isTransaction`, automatic `undefined → null` parameter coercion (`node:sqlite` rejects `undefined`), automatic `Uint8Array → Buffer` BLOB coercion (`node:sqlite` returns `Uint8Array` but the wider monorepo expects Buffer for `Readable.from` etc.). A `vacuumIntoSync` helper exposes SQLite's synchronous `VACUUM INTO` for callers that need the legacy synchronous serialize shape; a `backupDatabase` helper exposes the asynchronous `sqlite.backup()` for the new test path.
- **`swingStore.js`**: replaced `import sqlite3 from 'better-sqlite3'` with `import { makeDatabase } from './sqliteBackend.js'`; replaced the broken `serialize` Buffer-returning function with a VACUUM-INTO-based implementation (preserves the synchronous Buffer-returning shape the wider monorepo's callers across SwingSet / cosmic-swingset / boot rely on); added a new async `backupTo(destPath)` debug helper that uses `sqlite.backup()` directly per mhofman's preferred direction; preserved `options.serialized` Buffer-load via a temp-file write (`node:sqlite` has no Buffer-load constructor); switched `db.inTransaction` to `db.isTransaction` per mhofman's review.
- **`exporter.js`** and **`internal.js`**: same import swap, no behavioral change.
- **Tests**: replaced direct `import sqlite3 from 'better-sqlite3'` with `import { makeDatabase as sqlite3 } from '../src/sqliteBackend.js'` in 5 test files (`deletion.test.js`, `import.test.js`, `repair-metadata.test.js`, `snapstore.test.js`, `transcriptStore.test.js`); rewrote `state.test.js`'s in-memory kvStore round-trip and `bundles.test.js`'s b0-import round-trip to use the new `debug.backupTo()` plus `openSwingStore(dir)` path, demonstrating the backup-API direction mhofman's review preferred.
- **`package.json`**: dropped `better-sqlite3` dependency and `@types/better-sqlite3` devDependency; bumped `engines.node`.

## Test / build / lint status

- `yarn test` from `packages/swing-store`: **85 tests pass**.
- `yarn lint:types` from `packages/swing-store`: clean.
- `yarn lint` from `packages/swing-store`: no errors, only pre-existing warnings (and two new JSDoc-any warnings in `sqliteBackend.js` for the `@types/node@22.9` typing-gap casts; `@types/node` < 22.16 lacks `DatabaseSync.isTransaction`, `StatementSync.iterate`, the `backup` module export, and the `readOnly` constructor option).
- `yarn build` from `packages/swing-store`: passes (the package's build is `exit 0`).
- Spot-check downstream consumers: `packages/SwingSet/test/state.test.js` (24 tests) and `packages/SwingSet/test/transcript-light.test.js` (1 test) both pass; both exercise the legacy `debug.serialize()` / `{ serialized }` round-trip via the compatibility shim, validating that the wider monorepo's caller surface is preserved.

## Key files touched

- `packages/swing-store/src/sqliteBackend.js` (new, 332 lines).
- `packages/swing-store/src/swingStore.js` (113 +, 32 −).
- `packages/swing-store/src/exporter.js` (3 +, 2 −).
- `packages/swing-store/src/internal.js` (frontmatter-style import swap).
- `packages/swing-store/package.json` (deps & engines).
- 7 test files updated (driver import swap; 2 also migrated to the new `backupTo` API).

## Gamut state

This dispatch closed the **fixer** stage of the gamut for the `fix/node-sqlite-builtin` branch (Stage 1 of the maintainer's two-dispatch directive). Per `skills/pr-creation-flow/SKILL.md` the orchestrator's next stage is the cleaner (coverage pass) → judge (code panel) → fixer-loop until net-approve → judge un-drafts. The PR is in draft state; the orchestrator should pick up the cleaner stage next.

Sibling dispatch A (the `@photostructure/sqlite` adapter approach, branch `fix/photostructure-sqlite-backend`) is the maintainer's parallel deliverable; if it lands its backend-entrypoint surface first, this PR's `sqliteBackend.js` surface should converge with it so the side-by-side review focuses on driver choice rather than API shape.

## Out of scope (deferred to maintainer)

- Migration of the other `better-sqlite3` consumers in the monorepo (`packages/SwingSet`, `packages/telemetry`, `packages/cosmic-swingset`, `services/ymax-planner`).
- Monorepo-wide `engines.node` floor bump.
- Migrating each existing `debug.serialize()` caller in SwingSet / cosmic-swingset / boot to `debug.backupTo()`. The compatibility shim keeps them working unchanged.
- Ferry to upstream `Agoric/agoric-sdk`; this PR lives in `kriscendobot/agoric-sdk` only for the maintainer's side-by-side comparison with the sibling Dispatch A PR.

Self-improvement: the `node:sqlite` migration's two biggest surprises were the `undefined → null` parameter rejection (better-sqlite3 silently coerces; node:sqlite throws `ERR_INVALID_ARG_TYPE`) and the `Uint8Array` BLOB return type (better-sqlite3 returns Buffer; node:sqlite returns Uint8Array, breaking `Readable.from` downstream). Both warrant a one-line note in a future `node-sqlite-migration-gotchas` skill or in a `library/concepts/` page so the next dispatch hitting the same migration does not rediscover them; routing as a `message` to `liaison` rather than a direct skill landing because the dispatch worktree's `garden/` is detached.
