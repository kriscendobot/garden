---
title: Build, Test, and Development Commands
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, tooling, testing]
status: current
---

> Abstract: The canonical command inventory for agoric-sdk work: `corepack enable && yarn install` to bootstrap, `yarn build` for kernel bundles, `yarn test` for AVA across all packages, `yarn lint` / `yarn lint-fix`, `yarn run -T tsc --noEmit --incremental` for fast per-package typecheck (plus a `--watch --preserveWatchOutput` mode the agent can monitor), `yarn typecheck-quick` for whole-repo (4-7s), `yarn format` (dprint), `yarn hooks:install` for git hooks, `./scripts/env-doctor.sh` to verify the toolchain. Also documents the prepack/postpack workflow: `yarn lerna run --reject-cycles --concurrency 1 prepack` for full sequential, `--since <pkg> --include-dependencies` to resume from a failure, and a mandatory `postpack` to clean generated artifacts.

## Build, Test, and Development Commands
- `corepack enable && yarn install`: Set up the repo with the pinned Yarn version and install dependencies.
- `yarn build`: Build all workspaces (generates kernel bundles where needed).
- `yarn test`: Run unit tests across all packages (AVA).
- `yarn lint` | `yarn lint-fix`: Check or auto-fix lint issues across packages.
- `yarn run -T tsc --noEmit --incremental`: Fast typecheck within a package; do this after changes.
    - Watch mode for type errors in active workspaces: run `yarn run -T tsc --noEmit --incremental --watch --preserveWatchOutput` in the workspace(s) being edited, and keep the terminal output visible so Codex can monitor errors.
- `yarn typecheck-quick` to do a fast typecheck over the whole repo (4-7 seconds)
- `yarn format`: Format code via dprint; `yarn lint:format` to check only.
- Git hooks: installed by `scripts/install-git-hooks.sh`.
  - Install or refresh hooks with `yarn hooks:install`.
  - Pre-commit runs `scripts/git-hooks/pre-commit-dprint.sh`, which formats staged JS/TS files with the pinned local binary `./node_modules/.bin/dprint`, auto-restages files that were fully staged already, and prints a custom message if formatting changes touched partially staged files.
- `./scripts/env-doctor.sh`: Verify toolchain (Node, Go, compiler) versions.
- Example, single package: `cd packages/eventual-send && yarn test`.
- Packing/debugging workflow:
  - Full sequential prepack pass across publishable packages: `yarn lerna run --reject-cycles --concurrency 1 prepack`
  - If a package fails, fix it and verify locally in that package with `yarn postpack && yarn prepack`
  - Resume from the failed package and include dependents needed for validation: `yarn lerna run prepack --since <failed-package-name> --include-dependencies --concurrency 1 --reject-cycles`
  - After any prepack run, clean generated artifacts and restore package trees with: `yarn lerna run --reject-cycles --concurrency 1 postpack`

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
