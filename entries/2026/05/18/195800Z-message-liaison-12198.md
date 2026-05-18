---
ts: 2026-05-18T19:58:00Z
kind: message
role: liaison
project: agoric
to: steward
prs:
  - repo: Agoric/agoric-sdk
    pr: 12198
    role: source
  - repo: Agoric/agoric-sdk
    issue: 12194
    role: source
---

# Maintainer task: two parallel fixer dispatches against `kriscendobot/agoric-sdk`, both run the gamut

Maintainer directive (2026-05-18): *"Please dispatch two fixers to propose separate PRs in our fork of agoric-sdk, based on the issue underlying https://github.com/Agoric/agoric-sdk/pull/12198. With the first PR, please address the direct feedback and run the gamut until passing in CI with the new sqlite binding, as proposed. With the second PR, please reconstruct a similar change that uses node:sqlite the builtin instead of a third-party library. We can also assume that we will be using Node.js 22 and 24 going forward. This may or may not require an experimental flag to be added to node invocations, which you must discover and implement. Then run the gamut. Please kick these jobs off to run asynchronously, with the help of the steward."*

Routing to steward (you) because the maintainer asked for asynchronous orchestration; the contractor / slot system is the natural venue. The dispatches' deliverables run end-to-end per `skills/pr-creation-flow/SKILL.md` (the gamut): fixer → cleaner → judge → fixer-loop → un-draft.

## Upstream context (read before dispatching)

- **Upstream PR**: [Agoric/agoric-sdk#12198](https://github.com/Agoric/agoric-sdk/pull/12198) by `@app/copilot-swe-agent`, base `master`, branch `copilot/switch-to-node-sqlite`, DRAFT, OPEN, head `728b01765`.
- **Underlying issue**: [Agoric/agoric-sdk#12194](https://github.com/Agoric/agoric-sdk/issues/12194). The issue wants to drop `better-sqlite3` (native-toolchain dependency) and switch to `node:sqlite`. The original direction suggested `@photostructure/sqlite` as a compatibility shim to avoid the experimental flag.
- **mhofman's preliminary review** (2025-11-11, the load-bearing feedback):
  - Switch tests that use DB serialization to use the **backup API** instead of `serialize()` clones.
  - `iterate` must **not** load all results. The native `iterate` is supported by `node:sqlite`.
  - The custom `inTransaction` implementation isn't necessary — `isTransaction` is supported by `node:sqlite`.
- **turadg's plan** (issue [#12194 comment](https://github.com/Agoric/agoric-sdk/issues/12194#issuecomment-4033954884), 2026-03-10): "Migrate Off `better-sqlite3` With a Direct Path to `node:sqlite`". Two-step migration:
  - Step 1: introduce a backend-entrypoint in `packages/swing-store` that owns SQLite construction; back it with `@photostructure/sqlite` short-term.
  - Step 2: swap to built-in `node:sqlite` on Node 22.16+ with minimal repo-wide change.
  - Native-first surface from the start: `prepare`, `exec`, `iterate`, `isTransaction`. Convenience layers (`pluck`, `raw`, `pragma`) layered locally. Use `sqlite.backup()` for serialization-shaped tests.
- **PR #12198's existing state**: 76/85 tests pass; build + lint pass; 2 skipped (debug `serialize()`), 7 fail (repair-metadata concurrent-DB-access edge cases). Adapter file `packages/swing-store/src/sqliteAdapter.js` is 328 lines; many cross-package import updates.

## The two dispatches

Both target our fork: **`kriscendobot/agoric-sdk`**, base `master` (default branch). Both produce **fresh** PRs in our fork rather than pushing to copilot's branch (we don't ferry into Agoric's upstream PRs).

### Dispatch A: `@photostructure/sqlite` adapter approach (turadg's Step 1)

Reconstruct PR #12198's approach but apply mhofman's feedback. Branch: `fix/photostructure-sqlite-backend` on `kriscendobot/agoric-sdk`.

**Must-fix items the fixer addresses**:
1. **Use native `iterate`** through the adapter — do not load all results into memory. `@photostructure/sqlite` exposes the underlying SQLite cursor; the adapter wraps it but preserves laziness.
2. **Use native `isTransaction`** — drop the custom `inTransaction` property tracking; `@photostructure/sqlite` exposes the SQLite-native state.
3. **Switch DB-serialization tests to the backup API** — `sqlite.backup()` (or the library's equivalent) replaces `serialize()` clones. The 2 skipped tests + the 7 repair-metadata failures are the target surface; the goal is to bring them back to green.
4. **Continue turadg's prior asks** (already mostly applied in #12198): `yarn build` green, `yarn lint` green, no `any`, no `better-sqlite3` imports remaining.

**Backend-entrypoint design** per turadg's plan: introduce a single SQLite construction entrypoint in `packages/swing-store` that the rest of the codebase imports from. Shape the local surface to be native-first (`prepare`, `exec`, `iterate`, `isTransaction`) so Dispatch B's `node:sqlite` swap becomes a constructor change, not a repo-wide rewrite. This is load-bearing for Dispatch B's later landing.

**Build off the existing copilot work** if it speeds you up: cherry-pick from `Agoric/agoric-sdk@copilot/switch-to-node-sqlite` (head `728b01765`) into our fork's `fix/photostructure-sqlite-backend`, then layer the mhofman feedback on top. Or start fresh — fixer's call based on diff inspection.

**Title**: `chore(swing-store): migrate from better-sqlite3 to @photostructure/sqlite (backend entrypoint)`. **Body**: cite upstream #12198 + #12194 + mhofman's review; describe how mhofman's three asks are addressed.

### Dispatch B: `node:sqlite` builtin approach (turadg's Step 2 directly)

Skip the `@photostructure/sqlite` compatibility shim entirely. Use Node's built-in `node:sqlite` directly. Branch: `fix/node-sqlite-builtin` on `kriscendobot/agoric-sdk`.

**Node.js version question** — *the fixer discovers and implements*:
- `node:sqlite` was added in **Node 22.5.0** behind `--experimental-sqlite`.
- It **stabilized in Node 22.16.0** (no flag).
- **Node 24** ships it stable.
- The maintainer's assumption: "Node.js 22 and 24 going forward."
- The fixer reads the repo's current `engines.node` floor (likely `^20.0.0` or `^18.0.0` today) and decides:
  - If raising the floor to `^22.16.0` is acceptable, no flag is needed; just bump `engines.node` and CI matrix.
  - If the floor stays at `^22.5.0 || ^24.0.0` (or similar), `--experimental-sqlite` must be added to `node` invocations across scripts, ava configs, swingset workers, and CI workflow steps.
  - Fixer surfaces the choice in the PR body with the rationale.

**Native API directly** — no adapter layer needed beyond convenience helpers:
- `import { DatabaseSync } from 'node:sqlite'`
- `StatementSync.iterate()` for lazy iteration
- `database.isTransaction` for transaction state
- `sqlite.backup()` (or `database.backup()` per the API) for serialization-shaped tests
- Local helpers for `pluck`, `raw`, `pragma` if the convenience matters; otherwise call SQL directly.

**The backend-entrypoint pattern** from turadg's plan still applies: own SQLite construction in `packages/swing-store`, expose a narrow Agoric-local DB/statement surface, isolate any remaining compatibility helpers. Dispatch A's entrypoint design (if it lands first) is the model; if A hasn't landed yet, both fixers design the entrypoint compatibly so the two PRs are reviewable side-by-side.

**Title**: `chore(swing-store): migrate from better-sqlite3 to node:sqlite (built-in)`. **Body**: cite #12194 + #12198 + the Node-22.16-floor decision (or experimental-flag rationale if floor stays lower); describe the native-API mapping.

## Coordination between the two dispatches

The two fixers may produce divergent diffs on the same files (`packages/swing-store/src/`, `package.json` lockfiles, ~25 cross-package imports). That's expected — the PRs are deliberately alternatives, not parallel landings. The maintainer compares the two PRs at review time and picks (or merges complementary parts).

Backend-entrypoint surface should be **as similar as possible** between the two PRs so the maintainer's side-by-side review focuses on the implementation difference, not the API shape. If one fixer settles the entrypoint surface first, the second adopts it.

## Gamut per dispatch

Each follows `skills/pr-creation-flow/SKILL.md` end to end:

1. **Fixer**: implement the migration, commit per `skills/yarn-lock-separate-commit/SKILL.md` (yarn.lock churn is significant), push, open as DRAFT PR on `kriscendobot/agoric-sdk`. Per today's recurring self-improvement: commit + push BEFORE extended local validation.
2. **Cleaner**: coverage / pre-PR housekeeping check.
3. **Judge**: 12-seat code panel (no design-only files; both PRs touch source).
4. **Fixer-loop**: address any must-fix items.
5. **Judge final**: un-draft on net-approve.

## Per-action authorization

- Standing on `kriscendobot/agoric-sdk`: push to feat/fix branches, open draft PR, force-push with lease during fixer-loop.
- **READ-ONLY** on `Agoric/agoric-sdk` (the upstream). No commenting on upstream PR #12198 or issue #12194; the two PRs in our fork are the response surface. If the maintainer wants the work ferried upstream later, that's a separate boatman dispatch under kriskowal identity.

## Out of scope

- No ferry to `Agoric/agoric-sdk`. Both PRs land on our fork only.
- No comment on upstream #12198 or #12194.
- No un-draft outside the gamut's judge stage.
- No assumption about which approach wins — the maintainer compares at the end.

## Reporting

Each gamut produces:
- PR URL + final head SHA on our fork.
- Test outcomes (target: full green, including the 2 skipped and 7 failing tests from #12198).
- Build / lint / type-check status.
- Node.js version decision (Dispatch B): flag-required or floor-raised.
- One-line `Self-improvement: ...` per the canonical discipline.

Acknowledge receipt of this message in your next per-cycle tick; pick up the dispatches when your slot capacity allows. The two are independent; either can start first.
