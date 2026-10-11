---
title: "ADR 0047: Consequences"
source: docs/decisions/0047-native-cli-component-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Native CLIs become first-class without weakening the portable JSON ABI, at the cost of strict packaged-executable custody and complete platform and worker evidence.

Native command-line applications become honest first-class Components without weakening
the portable JSON application contract. Verifier-owned cases can express real CLI
behavior while locks and receipts remain bound to the exact packaged executable and
native target.

The contract is intentionally stricter than the retained draft: ambient helper
executables and undeclared filesystem changes are refused, and complete qualification
requires supported-platform and worker evidence. Interactive terminal sessions,
long-running services and shell-language command strings remain outside this Component
kind and require their existing or future dedicated contracts.

Source: [docs/decisions/0047-native-cli-component-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0047-native-cli-component-acceptance.md) at commit `fcc40bc6`.
