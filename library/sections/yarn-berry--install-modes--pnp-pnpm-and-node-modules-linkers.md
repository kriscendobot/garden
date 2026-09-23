---
title: PnP, pnpm, and node-modules linkers
source: packages/docusaurus/docs/features/install-modes.mdx
source_repo: yarnpkg/berry
source_commit: 7744e6678de126a2ca2398d4123e3f7e009256b8
source_date: 2026-07-17
source_authors: [Anton Korzunov]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Yarn's `nodeLinker` selects among PnP (the default), a pnpm-style symlinked store, and conventional `node_modules`, trading dependency visibility and tooling compatibility.

`nodeLinker: pnp` generates a loader and accesses the global store directly. `nodeLinker: pnpm` creates a flat `node_modules/.store`, hardlinks package files from Yarn's central store, then symlinks relevant packages into `node_modules`; it prevents some ghost dependencies but has ordinary Node resolution compatibility. `nodeLinker: node-modules` uses the traditional filesystem layout and offers maximal compatibility, but cannot protect against ghost dependencies and has imperfect hoisting. All three modes are supported as stable install strategies.

Source: [packages/docusaurus/docs/features/install-modes.mdx](https://github.com/yarnpkg/berry/blob/7744e6678de126a2ca2398d4123e3f7e009256b8/packages/docusaurus/docs/features/install-modes.mdx) at commit `7744e66`.
