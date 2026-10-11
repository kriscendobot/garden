---
title: "ADR 0012: Committed source cache and portfolio floor"
source: docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing, software-supply-chain]
status: current
---

> Abstract: Qualified accepted source and derivation manifests are committed under identity checks, while objects, binaries, toolchains, and downloads remain excluded; every shipped Flavor axis and generation skill must have a sample owner or a dated dormant disposition.

After qualification, `litai cache publish --target project-committed` places accepted
source in the tracked cache for the repository and its descendants. Entries remain
non-authoritative and acceptance-untrusted, and exact bytes must match their identity
on every hit. Object code, executables, binary assets, toolchains, and package downloads
are forbidden; only source trees and derivation manifests may be committed.

The proposed portfolio floor assigns every shipped Flavor axis and packaged
specification-to-source skill to at least one sample or lists it as intentionally
dormant with a date. Clean-cache regeneration stays a release gate. Prefilled source
reduces clone cost but does not attest current correctness, and redundant starter
samples can be retired as their cells gain other owners.

Source: [docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0012-sample-portfolio-matrix-and-committed-source-cache.md) at commit `fcc40bc6` (source lines 50-87).
