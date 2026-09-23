---
ts: 2026-05-18T20:08:00Z
kind: dispatch
role: steward
project: agoric-sdk
to: "*"
prs:
  - repo: Agoric/agoric-sdk
    pr: 12198
    role: source
refs:
  - entries/2026/05/18/195800Z-message-liaison-12198.md
---

# Dispatch B: fixer drafts `node:sqlite` migration PR on `kriscendobot/agoric-sdk` (turadg's Step 2 directly)

Dispatch root: `dispatches/fixer--61b0de/`. Project worktree on `Agoric/agoric-sdk@master`.

Full directive at `entries/2026/05/18/195800Z-message-liaison-12198.md`. This is the parallel sibling to Dispatch A (`977cf0`).

## Per-action authorization

- Add remote `kriscendobot` pointing at `git@github.com:kriscendobot/agoric-sdk.git`.
- Push to feature branch `fix/node-sqlite-builtin` on the fork.
- Open DRAFT PR on `kriscendobot/agoric-sdk` base `master`.
- READ-ONLY on upstream `Agoric/agoric-sdk`.

## Task (Dispatch B)

Migrate `packages/swing-store` from `better-sqlite3` to **`node:sqlite`** (the built-in module), skipping the `@photostructure/sqlite` compatibility shim entirely.

**Node.js version question — you discover and implement**:

- `node:sqlite` was added in **Node 22.5.0** behind `--experimental-sqlite`.
- It stabilized in **Node 22.16.0** (no flag).
- Node 24 ships it stable.
- Read the repo's current `engines.node` floor.
- If raising the floor to `^22.16.0 || ^24.0.0` is acceptable, bump `engines.node` + CI matrix; no flag needed.
- If the floor stays lower, add `--experimental-sqlite` to `node` invocations across scripts, ava configs, swingset workers, and CI workflow steps.
- Surface the choice in the PR body with rationale.

**Native API directly** — no adapter layer beyond convenience helpers:

- `import { DatabaseSync } from 'node:sqlite'`
- `StatementSync.iterate()` for lazy iteration
- `database.isTransaction` for transaction state
- `sqlite.backup()` (or `database.backup()` per API) for serialization-shaped tests
- Local helpers for `pluck`, `raw`, `pragma` if convenience matters; else call SQL directly

**Backend-entrypoint surface as similar as possible** to Dispatch A so the maintainer's side-by-side review focuses on the implementation difference, not the API shape. If Dispatch A's PR lands first, adopt its entrypoint shape; if you go first, design it compatibly.

## Commits

- Per `skills/yarn-lock-separate-commit/SKILL.md`: lockfile churn in its own commit.
- Conventional-commit messages.
- Push to `kriscendobot/agoric-sdk`.
- Open draft PR with title: `chore(swing-store): migrate from better-sqlite3 to node:sqlite (built-in)`.
- Body cites #12194 + #12198 + the Node-22.16-floor decision (or experimental-flag rationale if floor stays lower).

## Gamut continuation

Stage 1 of the gamut. Subsequent stages (cleaner, judge, fixer-loop, un-draft) run via the autonomous-steward's standing scan.

## Report

≤ 500 words. PR number + URL, final head SHA, Node.js version decision (flag-required or floor-raised) with rationale, test status, build/lint/type-check status, one-line `Self-improvement: ...`.
