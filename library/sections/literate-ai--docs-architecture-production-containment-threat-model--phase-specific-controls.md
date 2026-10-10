---
title: Phase-specific isolation controls
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

> Abstract: Acquisition, generation, observation, dependency resolution, build, generated-test, and application-execution stages receive separate grants, inputs, outputs, network rules, secrets, budgets, and verifier access, preventing one broad capability from leaking across the lifecycle.

The control vocabulary records read-only inputs, separate outputs, minimal environment, credential and device removal, network denial or restricted egress, resource limits, wall time, output bounds, and process-tree termination independently from the coarse isolation level. Policy combines request-specific controls with stage minimums and reports the exact missing set.

Process-limited execution intrinsically requires time, output, process-tree, and resource bounds. OS and VM isolation add protected inputs and outputs plus environment, credential, and device controls. Network policy remains phase-specific and must name enforced behavior rather than rely on a process promise.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
