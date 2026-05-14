---
title: Updating
source: docs/node-version.md
source_repo: agoric/agoric-sdk
source_commit: 56a5567f
source_date: 2025-08-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling]
status: current
---

> Abstract: How to update the Node.js version requirement when the project rev's.

## Updating

When a new version becomes Active LTS:
- [ ] update integrations to use it (e.g. `.github/workflows/integration.yml`)
- [ ] update the .node-version hint to use it
- [ ] update Node.js test ranges to remove the EOLed version and add the new LTS
- [ ] update package.json engines to allow the two LTS versions (by updating `yarn.config.cjs` then `yarn constraints --fix`)
- [ ] update README.md to document the new supported versions
- [ ] update AGENTS.md to document the new supported versions
- [ ] update repoconfig.sh to verify against the new supported versions

Source: [docs/node-version.md](https://github.com/agoric/agoric-sdk/blob/56a5567f/docs/node-version.md) at commit `56a5567f`.
