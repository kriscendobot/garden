---
title: "ADR 0045: Consequences"
source: docs/decisions/0045-debian-package-worker-custody.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [node-packaging, software-supply-chain]
status: current
---

> Abstract: The apt provider becomes a real target-specific package adapter and refuses unresolved dependency coordinates instead of guessing or omitting them.

The apt provider becomes a real target-specific package adapter rather than a generic
metadata archive. This adds Debian-specific projection and worker execution contracts,
but keeps the provider-neutral `PackagePlan` and release result boundary intact.

Requiring exact Debian dependency coordinates may initially refuse packages whose
accepted SBOM lacks provider mapping. That refusal is more accurate than publishing a
package with guessed or omitted dependencies. Supporting additional distributions or
maintainer scripts requires a later explicit contract rather than weakening this one.

Source: [docs/decisions/0045-debian-package-worker-custody.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0045-debian-package-worker-custody.md) at commit `fcc40bc6`.
