---
title: Peer-context store variants
source: docs/how-peers-are-resolved.md
source_repo: pnpm/pnpm.io
source_commit: 8a01423859b423bba444cb241bf91aa7d9d499f2
source_date: 2026-07-12
source_authors: [Jiří Podivín]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm creates separate `.pnpm` package instances for distinct peer-resolution sets so Node resolves each consumer's peer context correctly.

Packages with the same version normally have one dependency set. Peer dependencies are the exception because peers resolve from higher in the graph. pnpm represents each distinct peer set in a separate store-path variant, such as `foo@1.0.0_bar@1.0.0+baz@1.1.0`, and symlinks consumers to the matching instance. A package without direct peers can also gain variants when a transitive dependency has peers resolved above it.

Source: [docs/how-peers-are-resolved.md](https://github.com/pnpm/pnpm.io/blob/8a01423859b423bba444cb241bf91aa7d9d499f2/docs/how-peers-are-resolved.md) at commit `8a01423`.
