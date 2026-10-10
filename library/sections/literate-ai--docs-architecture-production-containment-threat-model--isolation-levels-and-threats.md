---
title: Isolation levels and threat scope
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [sandbox-platforms, agentic-sdlc]
status: current
---

> Abstract: Literate AI orders execution guarantees from ambient `host-yolo` through resource-bounded processes and OS sandboxes to VM isolation, treating generated code, repositories, dependency tooling, builds, tests, and applications as hostile while excluding kernel, hypervisor, firmware, administrator, and control-plane compromise from an individual backend's claim.

Isolation names denote guarantees, not implementation labels. A process wrapper or Bazel action does not establish `os-sandboxed`; a backend must report complete, independently checkable facts for the exact source, platform, execution, level, and controls. Even a locally sufficient report remains unauthenticated diagnostics rather than permission to launch or release evidence.

In-scope threats include credential and unrelated-file access, repository prompt injection, undeclared network use, compiler and package-manager surprises, resource exhaustion, child-process retention, path and symlink escape, target substitution, and replay or truncation of evidence. Lower levels retain the same-user host inside the trusted computing base.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
