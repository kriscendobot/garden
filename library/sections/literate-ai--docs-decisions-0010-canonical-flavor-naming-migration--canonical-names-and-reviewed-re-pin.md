---
title: "ADR 0010: Canonical names and reviewed re-pin"
source: docs/decisions/0010-canonical-flavor-naming-migration.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, software-supply-chain]
status: current
---

> Abstract: Every Flavor uses `<axis-prefix>-<value>`, disk directories match canonical names, bare ergonomic aliases may resolve to them, and a dry-run/record migration enumerates and re-pins every affected identity consumer atomically.

The fixed prefixes cover operating system, architecture, accelerator, language,
interface, JavaScript packages, build, toolchain, packaging, deployment, and document
ecosystem axes. The dash is a recognizable separator, not additional semantics, and
names remain within `flavor://<namespace>/<name>` coordinates.

Dotted live selectors were removed when the 0.8.0 window closed. Bare target aliases
remain ergonomic inputs, while locks store only canonical forms and leftover dotted
identities are normalized only to detect duplicate authority. Directories follow
canonical names, and target values remain separate.

`litai catalog migrate-flavor-names` previews and records exact drift across locks,
manifests, fixtures, and sample metadata. Catalog renames and re-pinned consumers land
together; byte and current-lock checks reject half-migrated states. Published wire
schemas remain opaque-string contracts, and historical coordinates remain historical
evidence.

Source: [docs/decisions/0010-canonical-flavor-naming-migration.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0010-canonical-flavor-naming-migration.md) at commit `fcc40bc6` (source lines 30-74).
