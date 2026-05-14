---
title: Package-Specific Requirements
source: docs/commit-hygiene.md
source_repo: agoric/agoric-sdk
source_commit: 61325fe5
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [repository-governance]
status: current
---

> Abstract: Per-package overrides where the standard pre-commit procedure differs. @agoric/client-utils has additional steps; other packages may add their own.

## Package-Specific Requirements

### @agoric/client-utils

1. Run `yarn codegen` after any changes to proto definitions or RPC client generation
2. Run `yarn format` (from repo root) before committing
3. Ensure tests pass with `yarn test`
4. Verify build succeeds with `yarn build`

### Other Packages

Check the package's `package.json` for available scripts and follow similar patterns.


Source: [docs/commit-hygiene.md](https://github.com/agoric/agoric-sdk/blob/61325fe5/docs/commit-hygiene.md) at commit `61325fe5`.
