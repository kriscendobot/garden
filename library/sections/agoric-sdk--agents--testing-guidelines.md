---
title: Testing Guidelines
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, testing]
status: current
---

> Abstract: agoric-sdk's testing framework is AVA. Test files match `**/test/**/*.test.*` per package. All-package run: `yarn test` from repo root. Per-package: `yarn test` from the package directory. Coverage with c8: `yarn test:c8`, then `yarn c8 report --reporter=html-spa`, view `coverage/html/index.html`.

## Testing Guidelines
- Framework: AVA. Test files follow `**/test/**/*.test.*` within each package.
- Run all: `yarn test`. Per-package: `yarn test` from that package directory.
- Coverage: in a package, run `yarn test:c8` and open `coverage/html/index.html` after `yarn c8 report --reporter=html-spa` if needed.

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
