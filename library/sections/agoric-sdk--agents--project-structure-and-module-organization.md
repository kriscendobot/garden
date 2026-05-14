---
title: Project Structure & Module Organization
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, repository-governance]
status: current
---

> Abstract: agoric-sdk is a Yarn-workspaces + Lerna-Lite monorepo. Primary code lives under `packages/*` (SwingSet, zoe, ERTP, smart-wallet are named exemplars). Go components live under `golang/` (e.g., `golang/cosmos`). Per-package tests at `packages/<name>/test/`. Tooling lives in `scripts/`. Two integration directories: `a3p-integration/` and `multichain-testing/`.

## Project Structure & Module Organization
- Monorepo managed by Yarn workspaces and Lerna Lite. Primary code lives under `packages/*` (e.g., `SwingSet`, `zoe`, `ERTP`, `smart-wallet`).
- Go components are under `golang/` (e.g., `golang/cosmos`).
- Tests reside per package in `packages/<name>/test/`.
- Utilities, CI and developer tooling scripts are in `scripts/`. Integration assets live in `a3p-integration/` and `multichain-testing/`.

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
