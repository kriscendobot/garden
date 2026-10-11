---
title: "ADR 0032: Consent-bound generic orchestration"
source: docs/decisions/0032-tuple-specific-native-install-sboms.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: A dependency-free parser and host adapter execute only validated package templates, require explicit installation consent, and never guess an unsupported tuple or bootstrap a missing package manager.

Interactive use asks once before host mutation; noninteractive use requires an explicit yes. Decline reports requirements without installing the CLI. Reuse and extraction fail closed on tuple mismatch, symlinks, missing companions, unsafe relative paths, or digest failure.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
