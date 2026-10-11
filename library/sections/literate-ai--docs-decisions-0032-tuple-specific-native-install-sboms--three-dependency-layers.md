---
title: "ADR 0032: Three dependency layers"
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

> Abstract: Stage-zero Make and Python, native package-manager prerequisites, and locked Python distribution dependencies remain separate authorities with separate proofs.

The installer verifies native Python support, venv support, and Git plus their version ranges before creating the private environment. Python packages remain governed by project metadata and lock data rather than being duplicated as distro packages with different version semantics.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
