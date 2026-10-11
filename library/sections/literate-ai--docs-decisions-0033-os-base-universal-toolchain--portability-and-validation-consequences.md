---
title: "ADR 0033: Portability and validation consequences"
source: docs/decisions/0033-os-base-universal-toolchain.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: New providers update one base group plus differing tuple realizations, while new OS families add realization leaves without changing orchestration or universal capability semantics.

Validation exercises composition, all provider-selection paths, consent, native and managed installation, re-probe, integrity failures, unsupported tuples, credential non-mutation, and install cycles on macOS, Debian-family Linux, and native Windows workers.

Source: [docs/decisions/0033-os-base-universal-toolchain.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0033-os-base-universal-toolchain.md) at commit `fcc40bc6`.
