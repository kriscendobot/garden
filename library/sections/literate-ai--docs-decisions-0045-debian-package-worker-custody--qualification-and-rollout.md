---
title: "ADR 0045: Qualification and rollout"
source: docs/decisions/0045-debian-package-worker-custody.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [testing, node-packaging]
status: current
---

> Abstract: Qualification requires reproducible packages, exact architecture and dependency mapping, exhaustive archive verification, tamper refusal, local and remote Linux construction, and bounded cleanup.

Implementation proceeds under the explicit maintainer acceptance recorded on
2026-09-25. Qualification must prove:

- byte-for-byte reproducibility across two fresh constructions with the same bound tool;
- exact `amd64` and `arm64` mapping and refusal of unknown or contradictory targets;
- complete path, mode, ownership, control-field, dependency and digest verification;
- executable entrypoints plus retained specification and resolved-SBOM resources;
- refusal of missing or changed tools, unmapped runtime dependencies, collisions,
  traversal, symlinks outside the declared mapping, maintainer scripts and tampering;
- local Linux construction and remote Linux construction from a non-Linux controller;
- bounded command output, deadline, cleanup and returned-evidence behavior; and
- installed-wheel tests followed by the complete Linux worker and hosted matrices.

Roll out in two reviewable slices: typed projection, bound local tool adapter and real
Linux evidence; then production worker dispatch and non-Linux-controller evidence. The
roadmap item remains open until both slices and independent verification are complete.

Source: [docs/decisions/0045-debian-package-worker-custody.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0045-debian-package-worker-custody.md) at commit `fcc40bc6`.
