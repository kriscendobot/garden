---
title: "ADR 0037: Uninstall, tests, and consequences"
source: docs/decisions/0037-prefix-installed-cli-self-update.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: Install manifests and uninstall adopt the self-update staging tree as prefix-owned state, while fixture-driven tests prove enrollment, channel selection, staging, re-execution, throttling, and fail-open behavior without live GitHub.

Uninstall accepts the v2 schema, removes staging with the application root, and keeps refusing symlinks, foreign files, and filesystem-root prefixes. Configuration and unrelated state remain operator-owned.

Prefix installs can cross minor and major stable releases automatically after one new-installer enrollment; all other install forms remain on their manual or package-manager path.

Source: [docs/decisions/0037-prefix-installed-cli-self-update.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0037-prefix-installed-cli-self-update.md) at commit `fcc40bc6`.
