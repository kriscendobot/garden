---
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: Companion to AGENTS.md (the document opens by pointing at AGENTS.md for robot-facing guidelines and offering this one for humans). Soft-flag overlap with endo--contributing in spirit; the agoric-sdk version has more specifics about Go toolchain prerequisites and a more elaborate src/tools/test directional rules.
---

> Abstract: agoric-sdk's human-facing contributing guide. Covers supported platforms (MacOS / Linux / WSL), the JS + Go + C toolchain prerequisites, the four-command sanity check (`yarn` / `yarn build` / `yarn test` / `yarn lint`), the `scripts/configure-vscode.sh` VSCode setup, and pointers to wiki style and unit-testing notes. The `tools` contract section names the repository scope boundary rules — `scripts/`, `src/`, `tools/`, `test/` — with directional import rules (e.g., `src/**` must not import `**/tools/**`) and publishing rules (`tools/` is not part of the semver contract). The Landing pull requests section names the per-commit-passes-CI rule, follow-up commit norms, and the "Squash and merge" preference. Integration tests run automatically when ready-for-merge labels are applied; `force:integration` / `bypass:integration` override the default.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-platforms-and-toolchain](../sections/agoric-sdk--contributing--overview-platforms-and-toolchain.md) | repository-governance, tooling, getting-started | current |
| [tools-contract](../sections/agoric-sdk--contributing--tools-contract.md) | repository-governance | current |
| [landing-pull-requests](../sections/agoric-sdk--contributing--landing-pull-requests.md) | repository-governance | current |
| [integration-tests](../sections/agoric-sdk--contributing--integration-tests.md) | repository-governance, testing | current |

## Cross-references

- Opens by pointing at AGENTS.md (already ingested as `agoric-sdk--agents--*`).
- Style and unit-testing wiki pages (`wiki/Coding-Style`, `wiki/agoric-sdk-unit-testing`) are external references not in the library.
- Conventional Commits requirement repeated from `agoric-sdk--agents--commit-and-pull-request-guidelines` and `agoric-sdk--docs-commit-hygiene--*`.

## Source

[CONTRIBUTING.md](https://github.com/Agoric/agoric-sdk/blob/de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22/CONTRIBUTING.md) at commit `de2c4cbc`.
