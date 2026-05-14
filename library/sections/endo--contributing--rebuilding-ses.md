---
title: Rebuilding ses
source: CONTRIBUTING.md
source_repo: endojs/endo
source_commit: 6ad084a6900b
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, hardened-javascript]
status: current
---

> Abstract: How to rebuild the SES shim from sources. Short procedural section; covers the build commands and what produces the published artifacts.

## Rebuilding `ses`

Changes to `ses` require a `yarn build` to be reflected in any dependency where `import 'ses';` appears. Use `yarn build` under `packages/ses` to refresh the build.
Everything else is wired up thanks to workspaces, so no need to run installs in other packages.


Source: [CONTRIBUTING.md](https://github.com/endojs/endo/blob/6ad084a6900b/CONTRIBUTING.md) at commit `6ad084a6`.
