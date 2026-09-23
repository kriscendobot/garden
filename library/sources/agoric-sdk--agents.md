---
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
section_count: 8
status: current
notes: Soft-flag overlap with endo--agents (the analog agent-instruction file in endojs/endo). Different repos, different specifics, but same role; agents working in agoric-sdk should consult this one, agents in endojs/endo the other.
---

> Abstract: Agent-facing repository guidelines for agoric-sdk (per the [agents.md](https://agents.md/) standard). Covers project structure (Yarn workspaces + Lerna Lite over `packages/*` + `golang/*`), build/test/dev commands (corepack-pinned yarn, typecheck, dprint format, pre-commit hook detail), coding style and naming (ESM, TS+JS, `@agoric/*` vs `@aglocal/*` package-name namespaces, ambient-authority discipline), testing (AVA), the async-flow durable-lifecycle model with replay constraints, A3P container build notes, and Conventional-Commits + integration-test labeling for PRs. Authored by Turadg Aleahmad.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--agents--overview.md) | agent-conventions | current |
| [project-structure-and-module-organization](../sections/agoric-sdk--agents--project-structure-and-module-organization.md) | agent-conventions, repository-governance | current |
| [build-test-and-development-commands](../sections/agoric-sdk--agents--build-test-and-development-commands.md) | agent-conventions, tooling, testing | current |
| [coding-style-and-naming-conventions](../sections/agoric-sdk--agents--coding-style-and-naming-conventions.md) | agent-conventions, typescript-conventions, capability-security | current |
| [testing-guidelines](../sections/agoric-sdk--agents--testing-guidelines.md) | agent-conventions, testing | current |
| [async-flow-model-notes](../sections/agoric-sdk--agents--async-flow-model-notes.md) | agent-conventions | current |
| [a3p-container-and-proposal-build-notes](../sections/agoric-sdk--agents--a3p-container-and-proposal-build-notes.md) | agent-conventions, tooling | current |
| [commit-and-pull-request-guidelines](../sections/agoric-sdk--agents--commit-and-pull-request-guidelines.md) | agent-conventions, repository-governance | current |

## Cross-references

- Soft-flag overlap with `endo--agents--*` (the analog AGENTS.md in endojs/endo). Same role, different repo specifics.
- `commit-and-pull-request-guidelines` points at `docs/commit-hygiene.md` (already ingested as `agoric-sdk--docs-commit-hygiene--*`).

## Source

[AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
