---
title: "ADR 0033: Duplicated toolchain authority"
source: docs/decisions/0033-os-base-universal-toolchain.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Tuple install SBOMs and a separate bootstrap script duplicated universal toolchain requirements, leaving coding-agent availability outside install authority and explicit provider selection.

Package names are platform realizations rather than capability identities: Git remains one capability across APT, Homebrew, and WinGet, while platform-only launchers and artifact URLs do not become universal merely because conditionals hide them.

Source: [docs/decisions/0033-os-base-universal-toolchain.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0033-os-base-universal-toolchain.md) at commit `fcc40bc6`.
