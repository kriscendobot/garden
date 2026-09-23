---
title: Workspaces and the workspace protocol
source: packages/docusaurus/docs/features/workspaces.mdx
source_repo: yarnpkg/berry
source_commit: 7744e6678de126a2ca2398d4123e3f7e009256b8
source_date: 2026-07-17
source_authors: [Anton Korzunov]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Yarn declares workspaces with root `package.json` glob patterns, and its `workspace:` protocol always resolves a local workspace while rewriting its range for publication.

The root `workspaces` array contains relative glob patterns. A dependency using `workspace:` is resolved by workspace name, not by the specified range. The protocol accepts a normal semver range or the special `^`, `~`, and `*` tokens. On `yarn npm publish`, `workspace:^`, `workspace:~`, and `workspace:*` become `^<current version>`, `~<current version>`, and `=<current version>` respectively; an explicit range is preserved.

Source: [packages/docusaurus/docs/features/workspaces.mdx](https://github.com/yarnpkg/berry/blob/7744e6678de126a2ca2398d4123e3f7e009256b8/packages/docusaurus/docs/features/workspaces.mdx) at commit `7744e66`.
