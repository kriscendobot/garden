---
title: "ADR 0033: Provider selection and custody invariants"
source: docs/decisions/0033-os-base-universal-toolchain.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [capability-security, software-supply-chain]
status: current
---

> Abstract: Explicit coding-agent selection narrows the one-of group exactly, while implicit selection reuses a usable provider in declared order and installs a default only when none exists.

Installation never changes credentials or claims authentication. Managed user tools live only under the host policy's managed-tool root; native packages remain package-manager custody, and uninstall still leaves shared prerequisites and independently authenticated provider state untouched.

Source: [docs/decisions/0033-os-base-universal-toolchain.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0033-os-base-universal-toolchain.md) at commit `fcc40bc6`.
