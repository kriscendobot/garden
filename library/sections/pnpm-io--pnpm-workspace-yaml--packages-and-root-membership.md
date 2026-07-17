---
title: pnpm-workspace.yaml packages and root membership
source: docs/pnpm-workspace_yaml.md
source_repo: pnpm/pnpm.io
source_commit: 8a01423859b423bba444cb241bf91aa7d9d499f2
source_date: 2026-07-12
source_authors: [Jiří Podivín]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm's workspace boundary is defined by `pnpm-workspace.yaml` `packages:` include/exclude globs; the root package is always a member and omission includes only it.

`pnpm-workspace.yaml` is the workspace root. Its `packages:` list accepts direct paths, recursive globs, and negated patterns. If it is omitted, pnpm includes only the root package; when patterns are present the root remains included. The file also holds workspace-wide catalogs and, from pnpm v11, can carry package-specific configuration via `packageConfigs`.

Source: [docs/pnpm-workspace_yaml.md](https://github.com/pnpm/pnpm.io/blob/8a01423859b423bba444cb241bf91aa7d499f2/docs/pnpm-workspace_yaml.md) at commit `8a01423`.
