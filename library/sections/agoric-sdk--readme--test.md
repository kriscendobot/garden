---
title: Test
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [testing]
status: current
---

> Abstract: How to run unit tests in agoric-sdk: `yarn test` from the top-level runs across all packages; per-package, `cd packages/<name>` and `yarn test`. (AVA underneath, framework-detail in `agoric-sdk--agents--testing-guidelines`.)

## Test

To run all unit tests (in all packages):

* `yarn test` (from the top-level)

To run the unit tests of just a single package (e.g. `eventual-send`):

* `cd packages/eventual-send`
* `yarn test`

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
