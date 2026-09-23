---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §package-name-stays observation
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

> *The npm package `@endo/daemon` and the directory
> `packages/daemon/` keep their current names. The package-
> level name is still correctly scoped to the daemon as a whole
> (including the supervisor and worker processes); only the
> orchestration file and the `Daemon*` identifiers within it
> are renamed.*

The §inside-vs-outside-the-name-boundary observation. The
*package* names something larger than the *file* — the package
encompasses the daemon-supervisor-worker triad; the file
encompasses just the orchestration layer. The rename is
*inside* the package's naming scope; the package name itself
remains valid.

The §nested-naming-scopes discipline: a name can be wrong at
file granularity but right at package granularity (or
vice-versa). The fix is at the level where the wrongness lives.
