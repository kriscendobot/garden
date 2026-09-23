---
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
section_count: 7
status: current
---

> Abstract: The Agoric Platform SDK README. Frames the repo as "the upper layers of the Agoric platform" with endo providing the lower layers, and tells dapp builders to go to docs.agoric.com (this repo is for platform contributors). Covers Prerequisites (Git, Go ^1.24.1, Node.js ^20.9 or ^22.11, Yarn, gcc/clang ≥10), an Apple-Silicon-specific dependency-build note, Build (corepack + yarn install + yarn build with node_modules symlink behavior explained), Test (per-package vs all), the "Run the larger demo" pointer at docs.agoric.com getting-started, the Edit Loop (modify→build→test), and Development Standards (branch hygiene, single-package-per-branch preference, changelogs/ entries, MAINTAINERS.md for releases).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--readme--overview.md) | getting-started, repository-governance | current |
| [prerequisites](../sections/agoric-sdk--readme--prerequisites.md) | getting-started, tooling | current |
| [build](../sections/agoric-sdk--readme--build.md) | tooling, bundles | current |
| [test](../sections/agoric-sdk--readme--test.md) | testing | current |
| [run-the-larger-demo](../sections/agoric-sdk--readme--run-the-larger-demo.md) | getting-started | current |
| [edit-loop](../sections/agoric-sdk--readme--edit-loop.md) | tooling | current |
| [development-standards](../sections/agoric-sdk--readme--development-standards.md) | repository-governance | current |

## Cross-references

- The overview points at endojs/endo as the lower-layer source; entire library of `endo--*` sections relevant.
- Test command (`yarn test`) matches `agoric-sdk--agents--testing-guidelines`; no soft-flag needed since they're identical 1-liner.
- Development Standards' Conventional-Commits expectation overlaps `agoric-sdk--docs-commit-hygiene--*`; soft-flag.

## Source

[README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
