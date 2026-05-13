---
title: Repository structure
source: AGENTS.md
source_repo: endojs/endo
source_commit: 6ea51ece638e2c842a12ec23164c21cbc24f3cbe
source_date: 2026-03-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-13
ingested_by: liaison
topics: [agent-conventions, repository-governance]
status: current
---

> Abstract: The endo repository is a Yarn-workspace monorepo with packages under `packages/`. Tests use ava (runtime) and tsd (types). Linting is eslint with project rules, run per-package via `yarn lint`.

## Repository structure

- Monorepo managed with Yarn workspaces
- Packages live in `packages/`
- Tests use `ava` (runtime) and `tsd` (types)
- Linting: `eslint` with project-specific rules; run `yarn lint` per-package

Source: [AGENTS.md](https://github.com/endojs/endo/blob/6ea51ece638e2c842a12ec23164c21cbc24f3cbe/AGENTS.md) at commit `6ea51ece`.
