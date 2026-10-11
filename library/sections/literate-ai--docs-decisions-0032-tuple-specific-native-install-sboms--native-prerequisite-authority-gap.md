---
title: "ADR 0032: Native prerequisite authority gap"
source: docs/decisions/0032-tuple-specific-native-install-sboms.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Installation proved Python package closure but left Git, venv support, and other native prerequisites in drifting prose or preexisting host state.

Encoding every OS and package-manager branch in the installer would merely move the drift into code. The unavoidable bootstrap boundary is limited to Make and the Python interpreter already required to execute the installer.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
