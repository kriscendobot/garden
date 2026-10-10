---
title: Exact build binding and cgroup preflight
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

> Abstract: Production build authority commits exact isolation policy, runner, runtime, image, configuration, and host-profile identities, while a read-only Linux cgroup-v2 preflight checks a pre-provisioned empty leaf against independently reviewed finite limits without creating, mutating, joining, or killing anything.

Only the build stage and at least `os-sandboxed` isolation enter this path. The binding covers source, toolchain, builder, privileges, outputs, actor, expiry, and immutable runtime references. A launcher must retrieve and validate those exact bytes before execution; commitments do not prove configuration validity or enforcement.

The cgroup probe opens path components without following symlinks, matches the descriptor to the active cgroup-v2 mount, bounds reads, and checks exact CPU, memory, swap, process, burst, OOM, controller, emptiness, and permission facts twice. Its immutable snapshot is neither authorization nor signed evidence. Scheduling class, output storage, wall time, process membership, cleanup, and actual platform qualification remain launcher obligations.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
