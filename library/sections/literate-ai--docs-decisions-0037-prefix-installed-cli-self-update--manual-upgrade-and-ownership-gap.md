---
title: "ADR 0037: Manual upgrade and ownership gap"
source: docs/decisions/0037-prefix-installed-cli-self-update.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Prefix-installed launchers had no in-command update path, while project reconciliation already owned `litai update` and non-prefix installations belonged to other custodians.

Replacing a stable prefix required another checkout install or manual wheel installation. Checkout, editable, package-manager, and CI copies must not rewrite their trees or runners, and the exact v1 install manifest could not accept self-update fields without an intentional schema change.

Source: [docs/decisions/0037-prefix-installed-cli-self-update.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0037-prefix-installed-cli-self-update.md) at commit `fcc40bc6`.
