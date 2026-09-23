---
title: PnP resolver and strict visibility
source: packages/docusaurus/docs/features/plugnplay.mdx
source_repo: yarnpkg/berry
source_commit: 7744e6678de126a2ca2398d4123e3f7e009256b8
source_date: 2026-07-17
source_authors: [Anton Korzunov]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Yarn Plug'n'Play replaces `node_modules` with a generated `.pnp.cjs` Node loader that maps packages to their locations and rejects accesses to undeclared dependencies, making ghost dependencies explicit.

PnP is Yarn's default modern installation strategy. Its `.pnp.cjs` loader contains the project's dependency-tree information and tells tools how to resolve `require` and `import` calls. It references package cache locations directly, rather than materializing a `node_modules` tree. Because the resolver knows each package's declared dependencies, an undeclared import fails with a semantic error instead of succeeding because of incidental hoisting. Peer dependencies are represented precisely: a workspace can be instantiated separately for distinct peer-dependency sets. Missing declared edges can be corrected in `.yarnrc.yml` with `packageExtensions`, including either regular or peer dependencies.

Source: [packages/docusaurus/docs/features/plugnplay.mdx](https://github.com/yarnpkg/berry/blob/7744e6678de126a2ca2398d4123e3f7e009256b8/packages/docusaurus/docs/features/plugnplay.mdx) at commit `7744e66`.
