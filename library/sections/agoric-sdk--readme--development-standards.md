---
title: Development Standards
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: Soft-flag overlap with agoric-sdk--docs-commit-hygiene--* (the canonical detail) and agoric-sdk--contributing--landing-pull-requests. This README section is the short summary; the docs/commit-hygiene.md is the long-form rule book.
---

> Abstract: agoric-sdk dev-process standards: all work on branches; single-commit branches can land on trunk without separate merge, but multi-commit branches should have a separate merge commit naming the affected packages (e.g., `(SwingSet,cosmic-swingset) merge 123-fix-persistence`). Tidy history; rebase to avoid overlapping branches. Every branch references an Issue and uses the issue number as a name prefix (`123-description`). Issue Labels mark affected packages. User-visible changes go into `changelogs/` named after the issue number. Branches should modify a single package unless the issue spans multiple. Releases follow `MAINTAINERS.md`.

## Development Standards

* All work should happen on branches. Single-commit branches can land on trunk
  without a separate merge, but multi-commit branches should have a separate
  merge commit. The merge commit subject should mention which packages were
  modified (e.g. `(SwingSet,cosmic-swingset) merge 123-fix-persistence`)
* Keep the history tidy. Avoid overlapping branches. Rebase when necessary.
* All work should have an Issue. All branches names should include the issue
  number as a prefix (e.g. `123-description`). Use "Labels" on the Issues to
  mark which packages are affected.
* Add user-visible changes to a new file in the `changelogs/` directory, named
  after the Issue number. See the README in those directories for instructions.
* Unless the issue spans multiple packages, each branch should only modify a
  single package.
* Releases should be made as according to [MAINTAINERS.md](MAINTAINERS.md).

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
